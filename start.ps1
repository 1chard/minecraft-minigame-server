#Requires -Version 5.1
param(
    [ValidateRange(2, 128)]
    [int] $MemoryGB = 4
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'scripts/upnp.ps1')
. (Join-Path $PSScriptRoot 'scripts/buildbattle.ps1')
$server = Join-Path $PSScriptRoot 'server-data'
if (-not (Test-Path -LiteralPath (Join-Path $server 'paper.jar'))) {
    throw 'Execute .\setup.ps1 antes de iniciar o servidor.'
}
$eula = Join-Path $server 'eula.txt'
if (-not (Test-Path -LiteralPath $eula) -or -not (Select-String -LiteralPath $eula -Pattern '^\s*eula\s*=\s*true\s*$' -Quiet)) {
    throw 'Leia https://www.minecraft.net/pt-br/eula e, se aceitar, execute .\setup.ps1 -AcceptEula.'
}
$java = Get-Command java.exe -CommandType Application | Select-Object -First 1
$version = & $java.Source --version | Select-Object -First 1
if ($version -notmatch '^[\w-]+\s+(\d+)' -or [int] $Matches[1] -lt 25) {
    throw "O TNT Run requer Java 25 ou superior no PATH. Detectado: $version"
}

$lockPath = Join-Path $server 'server.lock'
try {
    $lock = [IO.File]::Open($lockPath, 'OpenOrCreate', 'ReadWrite', 'None')
} catch [IO.IOException] {
    throw 'Esta instancia ja esta em uso. Confira o console do servidor.'
}
$createdMappings = @()
$upnpClient = $null
$description = 'Minecraft-' + [guid]::NewGuid().ToString('N').Substring(0, 8)
try {
    $serverArguments = @('--nogui')
    $properties = Join-Path $server 'server.properties'
    Set-BuildBattleDefaults $server
    if ((Get-PaperProperty $properties 'level-name' 'world') -ceq 'lobby') {
        $datapacks = Join-Path $server 'lobby/datapacks'
        New-Item -ItemType Directory -Force -Path $datapacks | Out-Null
        Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'lobby') -Destination $datapacks -Recurse -Force
    }
    try {
        $bindAddress = Get-PaperProperty $properties 'server-ip' ''
        $parsedBindAddress = $null
        $loopback = $bindAddress -eq 'localhost' -or ([Net.IPAddress]::TryParse($bindAddress, [ref] $parsedBindAddress) -and [Net.IPAddress]::IsLoopback($parsedBindAddress))
        $targetAddress = $bindAddress
        if ($loopback) { $targetAddress = '' }
        $address = Get-UPnPLocalAddress $targetAddress
        $upnpClient = New-UPnPHttpClient
        $router = Find-UPnPDescription $address
        $control = Get-UPnPControl $upnpClient $router
        Write-Host "UPnP: roteador $($router.Host) respondeu para a interface $address."

        $port = [int] (Get-PaperProperty $properties 'server-port' '25565')
        if (Add-MinecraftPortMapping $control $port 'TCP' $address $description) {
            $createdMappings += @{ Port = $port; Protocol = 'TCP'; Address = $address }
        }
        if ($loopback) { $serverArguments += @('--host', '0.0.0.0') }

        if ((Get-PaperProperty $properties 'enable-query' 'false') -eq 'true') {
            $queryPort = [int] (Get-PaperProperty $properties 'query.port' '25565')
            if (Add-MinecraftPortMapping $control $queryPort 'UDP' $address $description) {
                $createdMappings += @{ Port = $queryPort; Protocol = 'UDP'; Address = $address }
            }
        }
    } catch {
        Write-Warning "UPnP: $($_.Exception.Message) O servidor vai iniciar."
    }

    Push-Location -LiteralPath $server
    try {
        & $java.Source '-Xms1G' "-Xmx${MemoryGB}G" '-jar' 'paper.jar' @serverArguments
        if ($LASTEXITCODE -ne 0) { throw "O servidor terminou com codigo $LASTEXITCODE." }
    } finally {
        Pop-Location
    }
} finally {
    foreach ($mapping in $createdMappings) { Remove-MinecraftPortMapping $control $mapping $description }
    if ($upnpClient) { $upnpClient.Dispose() }
    $lock.Dispose()
}
