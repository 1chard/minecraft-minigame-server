function Set-BuildBattleDefaults($Server) {
    $directory = Join-Path $Server 'plugins/BuildBattle'
    $config = Join-Path $directory 'config.yml'
    $archivePath = Join-Path $Server 'plugins/BuildBattle-5.1.8.jar'
    if (-not (Test-Path -LiteralPath $archivePath)) { return }

    $hasConfig = Test-Path -LiteralPath $config
    if ($hasConfig) {
        $content = [IO.File]::ReadAllText($config)
    } else {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $archive = [IO.Compression.ZipFile]::OpenRead($archivePath)
        try {
            $reader = [IO.StreamReader]::new($archive.GetEntry('config.yml').Open())
            try { $content = $reader.ReadToEnd() } finally { $reader.Dispose() }
        } finally {
            $archive.Dispose()
        }
    }

    # Update the shipped timers for Solo and Duplas, preserving custom timers.
    $section = '(?ms)^Time-Manager:[^\r\n]*\r?\n.*?(?=^\S|\z)'
    $updated = [regex]::Replace($content, $section, {
        param($timers)
        [regex]::Replace($timers.Value, '(?ms)^  (Classic|Teams):[^\r\n]*\r?\n.*?(?=^  \S|^\S|\z)', {
            param($mode)
            $default = if ($mode.Groups[1].Value -eq 'Teams') { 540 } else { 480 }
            $mode.Value -replace "(?m)^(    In-Game:[ \t]*)$default(?=[ \t]*(?:#.*)?\r?$)", '${1}300'
        })
    })
    if (-not $hasConfig -or $updated -cne $content) {
        New-Item -ItemType Directory -Path $directory -Force | Out-Null
        [IO.File]::WriteAllText($config, $updated, [Text.UTF8Encoding]::new($false))
    }

    # Move unmodified stock positions out of the new solid intersection.
    $arenas = Join-Path $directory 'arenas.yml'
    if (Test-Path -LiteralPath $arenas) {
        $content = [IO.File]::ReadAllText($arenas)
        $updated = $content -creplace '(?m)^(    (?:startlocation|spectatorlocation):[ \t]*["'']?construcao,)0\.5,(100\.0|108\.0),0\.5(?=,0\.0,0\.0["'']?[ \t]*\r?$)', '${1}3.5,${2},3.5'
        if ($updated -cne $content) {
            [IO.File]::WriteAllText($arenas, $updated, [Text.UTF8Encoding]::new($false))
        }
    }
}
