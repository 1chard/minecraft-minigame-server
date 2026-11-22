function Get-PaperProperty($Path, $Key, $Default) {
    $pattern = '^[ \t]*{0}(?:[ \t]*[=:][ \t]*|[ \t]+|$)(.*)$' -f [regex]::Escape($Key)
    $match = Select-String -LiteralPath $Path -Pattern $pattern -CaseSensitive | Select-Object -Last 1
    if ($match) { return $match.Matches[0].Groups[1].Value.Trim() }
    return $Default
}

function Get-UPnPLocalAddress($BindAddress) {
    if ($BindAddress -and $BindAddress -ne '0.0.0.0') {
        $address = [Net.IPAddress]::Parse($BindAddress)
    } else {
        $socket = [Net.Sockets.UdpClient]::new()
        try {
            # UDP Connect selects a route and source address without sending a packet.
            $socket.Connect('1.1.1.1', 53)
            $address = $socket.Client.LocalEndPoint.Address
        } finally {
            $socket.Dispose()
        }
    }
    if ($address.AddressFamily -ne [Net.Sockets.AddressFamily]::InterNetwork -or [Net.IPAddress]::IsLoopback($address)) {
        throw 'O UPnP precisa de um endereco IPv4 da rede local.'
    }
    return $address.ToString()
}

function Find-UPnPDescription($Address) {
    $gateway = Get-NetIPConfiguration | Where-Object { $_.IPv4Address.IPAddress -contains $Address } |
        ForEach-Object { $_.IPv4DefaultGateway.NextHop } | Select-Object -First 1
    if (-not $gateway) { throw "Nenhum gateway IPv4 encontrado para $Address." }

    $local = [Net.IPAddress]::Parse($Address)
    $socket = [Net.Sockets.UdpClient]::new([Net.IPEndPoint]::new($local, 0))
    try {
        $socket.Client.SetSocketOption([Net.Sockets.SocketOptionLevel]::IP, [Net.Sockets.SocketOptionName]::MulticastInterface, $local.GetAddressBytes())
        $socket.Client.ReceiveTimeout = 500
        $target = [Net.IPEndPoint]::new([Net.IPAddress]::Parse('239.255.255.250'), 1900)
        foreach ($version in 1, 2) {
            $search = "M-SEARCH * HTTP/1.1`r`nHOST: 239.255.255.250:1900`r`nMAN: `"ssdp:discover`"`r`nMX: 1`r`nST: urn:schemas-upnp-org:device:InternetGatewayDevice:${version}`r`n`r`n"
            $bytes = [Text.Encoding]::ASCII.GetBytes($search)
            $null = $socket.Send($bytes, $bytes.Length, $target)
        }

        $timer = [Diagnostics.Stopwatch]::StartNew()
        while ($timer.ElapsedMilliseconds -lt 2500) {
            $sender = [Net.IPEndPoint]::new([Net.IPAddress]::Any, 0)
            try {
                $response = [Text.Encoding]::ASCII.GetString($socket.Receive([ref] $sender))
            } catch [Net.Sockets.SocketException] {
                if ($_.Exception.SocketErrorCode -eq [Net.Sockets.SocketError]::TimedOut) { continue }
                throw
            }
            if ($sender.Address.ToString() -ne $gateway -or $response -notmatch '(?im)^location:[ \t]*([^\r\n]+)') { continue }
            $description = $null
            if ([uri]::TryCreate($Matches[1].Trim(), [UriKind]::Absolute, [ref] $description) -and
                $description.Scheme -eq 'http' -and $description.Host -eq $gateway) { return $description }
        }
    } finally {
        $socket.Dispose()
    }
    throw "O gateway $gateway nao respondeu a descoberta UPnP em $Address."
}

function Get-UPnPControl($Client, [uri] $Description) {
    $stream = $Client.GetStreamAsync($Description).GetAwaiter().GetResult()
    try {
        $device = Read-UPnPXml $stream
    } finally {
        $stream.Dispose()
    }
    foreach ($type in 'WANIPConnection', 'WANPPPConnection') {
        $services = $device.SelectNodes("//*[local-name()='service']") | Where-Object { $_.serviceType -match ":${type}:\d+$" }
        foreach ($service in $services) {
            $uri = [uri]::new($Description, [string] $service.controlURL)
            if ($uri.Scheme -eq 'http' -and $uri.Host -eq $Description.Host) {
                return @{ Client = $Client; Uri = $uri; Type = [string] $service.serviceType }
            }
        }
    }
    throw 'O roteador respondeu ao UPnP, mas nao anunciou um servico WAN de encaminhamento.'
}

function New-UPnPHttpClient {
    Add-Type -AssemblyName System.Net.Http
    $handler = [Net.Http.HttpClientHandler]::new()
    $handler.AllowAutoRedirect = $false
    $handler.UseProxy = $false
    $client = [Net.Http.HttpClient]::new($handler)
    $client.Timeout = [TimeSpan]::FromSeconds(4)
    return $client
}

function Read-UPnPXml($Stream, [switch] $IgnoreMappingDescription) {
    # Some gateways advertise an invalid HTTP charset or send legacy bytes in rule descriptions.
    $buffer = [IO.MemoryStream]::new()
    $document = [Xml.XmlDocument]::new()
    $document.XmlResolver = $null
    try {
        $Stream.CopyTo($buffer)
        $buffer.Position = 0
        try {
            $document.Load($buffer)
        } catch [Xml.XmlException] {
            $decoded = [Text.Encoding]::GetEncoding(28591).GetString($buffer.ToArray())
            if ($IgnoreMappingDescription) {
                $decoded = $decoded -replace '(?s)<NewPortMappingDescription>.*?</NewPortMappingDescription>', ''
            }
            $document.LoadXml(($decoded -replace '[\x00-\x08\x0B\x0C\x0E-\x1F]', ''))
        }
    } finally {
        $buffer.Dispose()
    }
    return ,$document
}

function Invoke-UPnPAction($Control, $Action, $Arguments) {
    $parameters = foreach ($key in $Arguments.Keys) {
        '<{0}>{1}</{0}>' -f $key, [Security.SecurityElement]::Escape([string] $Arguments[$key])
    }
    $body = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><u:{0} xmlns:u="{1}">{2}</u:{0}></s:Body></s:Envelope>' -f $Action, $Control.Type, ($parameters -join '')
    $request = [Net.Http.HttpRequestMessage]::new([Net.Http.HttpMethod]::Post, $Control.Uri)
    $response = $null
    try {
        $request.Content = [Net.Http.StringContent]::new($body, [Text.Encoding]::UTF8, 'text/xml')
        $null = $request.Headers.TryAddWithoutValidation('SOAPAction', ('"{0}#{1}"' -f $Control.Type, $Action))
        $response = $Control.Client.SendAsync($request).GetAwaiter().GetResult()
        $result = Read-UPnPXml ($response.Content.ReadAsStreamAsync().GetAwaiter().GetResult()) -IgnoreMappingDescription:($Action -eq 'GetGenericPortMappingEntry')
        $code = $result.SelectSingleNode("//*[local-name()='errorCode']")
        if ($code) {
            $detail = $result.SelectSingleNode("//*[local-name()='errorDescription']")
            $error = [InvalidOperationException]::new("$Action recusado pelo roteador (UPnP $($code.InnerText)) $($detail.InnerText)")
            $error.Data['UPnPError'] = $code.InnerText
            throw $error
        }
        $null = $response.EnsureSuccessStatusCode()
        return $result
    } finally {
        if ($response) { $response.Dispose() }
        $request.Dispose()
    }
}

function Get-MinecraftPortMapping($Control, [int] $Port, $Protocol, [switch] $SkipPortVerification) {
    try {
        $result = Invoke-UPnPAction $Control 'GetSpecificPortMappingEntry' ([ordered] @{
            NewRemoteHost = ''; NewExternalPort = $Port; NewProtocol = $Protocol
        })
    } catch {
        if ($_.Exception.Data['UPnPError'] -eq '714') { return }
        throw
    }
    $mapping = $result.SelectSingleNode("//*[local-name()='GetSpecificPortMappingEntryResponse']")
    $internalPort = [int] $mapping.NewInternalPort
    # Some gateways corrupt the internal port in the individual lookup but return it in the list.
    if (-not $SkipPortVerification -and $internalPort -ne $Port) {
        for ($index = 0; $index -lt 256; $index++) {
            try {
                $listed = Invoke-UPnPAction $Control 'GetGenericPortMappingEntry' ([ordered] @{ NewPortMappingIndex = $index })
            } catch {
                if ($_.Exception.Data['UPnPError'] -in '401', '713') { break }
                throw
            }
            $candidate = $listed.SelectSingleNode("//*[local-name()='GetGenericPortMappingEntryResponse']")
            if ([int] $candidate.NewExternalPort -eq $Port -and $candidate.NewProtocol -eq $Protocol -and
                [string] $candidate.NewRemoteHost -in '', '0.0.0.0', '*' -and $candidate.NewInternalClient -eq $mapping.NewInternalClient) {
                $internalPort = [int] $candidate.NewInternalPort
                break
            }
        }
    }
    return @{
        InternalClient = [string] $mapping.NewInternalClient
        InternalPort = $internalPort
        Enabled = [string] $mapping.NewEnabled -in '1', 'true'
        Description = [string] $mapping.NewPortMappingDescription
    }
}

function Add-MinecraftPortMapping($Control, [int] $Port, $Protocol, $Address, $Description) {
    if ($Port -lt 1 -or $Port -gt 65535) { throw "Porta invalida: $Port/$Protocol." }
    $existing = Get-MinecraftPortMapping $Control $Port $Protocol
    if ($existing) {
        if ($existing.InternalClient -ne $Address -or $existing.InternalPort -ne $Port -or -not $existing.Enabled) {
            throw "Ja existe um mapeamento para $Port/$Protocol apontando para $($existing.InternalClient):$($existing.InternalPort)."
        }
        Write-Host "UPnP: usando o mapeamento existente $Port/$Protocol."
        return $false
    }

    $null = Invoke-UPnPAction $Control 'AddPortMapping' ([ordered] @{
        NewRemoteHost = ''; NewExternalPort = $Port; NewProtocol = $Protocol
        NewInternalPort = $Port; NewInternalClient = $Address; NewEnabled = 1
        NewPortMappingDescription = $Description; NewLeaseDuration = 0
    })
    try {
        $added = Get-MinecraftPortMapping $Control $Port $Protocol
        if (-not $added -or $added.InternalClient -ne $Address -or $added.InternalPort -ne $Port -or -not $added.Enabled) {
            throw "O roteador nao confirmou o destino $($Address):$Port para $Port/$Protocol."
        }
    } catch {
        Remove-MinecraftPortMapping $Control @{ Port = $Port; Protocol = $Protocol; Address = $Address } $Description
        throw
    }
    Write-Host "UPnP: $Port/$Protocol encaminhada para $Address."
    return $true
}

function Remove-MinecraftPortMapping($Control, $Mapping, $Description) {
    try {
        $existing = Get-MinecraftPortMapping $Control $Mapping.Port $Mapping.Protocol -SkipPortVerification
        if ($existing -and $existing.Description -eq $Description -and $existing.InternalClient -eq $Mapping.Address) {
            $null = Invoke-UPnPAction $Control 'DeletePortMapping' ([ordered] @{
                NewRemoteHost = ''; NewExternalPort = $Mapping.Port; NewProtocol = $Mapping.Protocol
            })
        }
    } catch {
        Write-Warning "UPnP: falha ao remover $($Mapping.Port)/$($Mapping.Protocol). $($_.Exception.Message)"
    }
}
