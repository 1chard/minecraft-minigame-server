#Requires -Version 5.1
param(
    [switch] $AcceptEula,
    [switch] $Offline
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$configs = Join-Path $PSScriptRoot 'configs'
$cache = Join-Path $PSScriptRoot '.downloads'
$server = Join-Path $PSScriptRoot 'server-data'
$plugins = Join-Path $server 'plugins'
$utf8 = [Text.UTF8Encoding]::new($false)
$properties = Join-Path $server 'server.properties'

function Set-OfflineMode {
    $content = [IO.File]::ReadAllText($properties)
    foreach ($key in 'online-mode', 'enforce-secure-profile') {
        $pattern = "(?m)^[ `t]*$key(?:[ `t]*[=:][ `t]*|[ `t]+|(?=\r?$))[^\r\n]*"
        if ($content -match $pattern) {
            $content = $content -replace $pattern, "$key=false"
        } else {
            $content = $content.TrimEnd("`r", "`n") + "`r`n$key=false`r`n"
        }
    }
    $temporary = "$properties.$([guid]::NewGuid()).part"
    try {
        [IO.File]::WriteAllText($temporary, $content, $utf8)
        [IO.File]::Replace($temporary, $properties, [NullString]::Value)
    } finally {
        if (Test-Path -LiteralPath $temporary) { Remove-Item -LiteralPath $temporary }
    }
    Write-Host 'Modo offline configurado para a proxima inicializacao.'
}

function Write-NewConfig($Path, $Content) {
    if (Test-Path -LiteralPath $Path) { return }
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Path) | Out-Null
    [IO.File]::WriteAllText($Path, $Content, $utf8)
}

function Get-Download($Item) {
    $path = Join-Path $cache $Item.file
    if (Test-Path -LiteralPath $path) {
        if ((Get-FileHash -LiteralPath $path).Hash -eq $Item.sha256) { return $path }
        throw "Checksum incorreto em $path. Remova o arquivo do cache e execute o setup novamente."
    }

    $temporary = "$path.$([guid]::NewGuid()).part"
    try {
        Write-Host "Baixando $($Item.file)..."
        & curl.exe --fail --location --silent --show-error --retry 2 --connect-timeout 15 --max-time 180 --output $temporary $Item.url
        if ($LASTEXITCODE -ne 0) { throw "Falha ao baixar $($Item.url)" }
        if ((Get-FileHash -LiteralPath $temporary).Hash -ne $Item.sha256) { throw "Checksum incorreto para $($Item.file)." }
        [IO.File]::Move($temporary, $path)
    } finally {
        if (Test-Path -LiteralPath $temporary) { Remove-Item -LiteralPath $temporary }
    }
    return $path
}

function Install-World($Archive, $Name, $ArchiveName = $Name) {
    $destination = Join-Path $server $Name
    if (Test-Path -LiteralPath $destination) {
        if (-not (Test-Path -LiteralPath (Join-Path $destination 'level.dat'))) { throw "Mundo incompleto em $destination." }
        return
    }

    $staging = Join-Path $cache ([guid]::NewGuid().ToString())
    $world = Join-Path $staging "$ArchiveName/world"
    New-Item -ItemType Directory -Path $staging | Out-Null
    try {
        & tar.exe -xf $Archive -C $staging "$ArchiveName/world"
        if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath (Join-Path $world 'level.dat')) -or -not (Test-Path -LiteralPath (Join-Path $world 'region'))) {
            throw "Mundo invalido em $Archive."
        }
        $cleanWorld = Join-Path $staging 'import'
        New-Item -ItemType Directory -Path $cleanWorld | Out-Null
        foreach ($entry in 'level.dat', 'region', 'entities', 'poi', 'data') {
            $source = Join-Path $world $entry
            if (Test-Path -LiteralPath $source) { Move-Item -LiteralPath $source -Destination $cleanWorld }
        }
        [IO.Directory]::Move($cleanWorld, $destination)
    } finally {
        # The temporary directory is a fresh GUID directly under the workspace cache.
        $resolvedStaging = (Resolve-Path -LiteralPath $staging).ProviderPath
        if ([IO.Path]::GetDirectoryName($resolvedStaging) -eq (Resolve-Path -LiteralPath $cache).ProviderPath) {
            Remove-Item -LiteralPath $resolvedStaging -Recurse -Force
        }
    }
}

function Install-HungerGamesArenas($Source) {
    # Convert the pinned FragSoc file to the per-arena format used by HungerGames 5.
    $legacy = Get-Content -LiteralPath $Source -Raw
    $defaultExit = [regex]::Match($legacy, '(?m)^global-exit-location: world:([^\r\n]+)').Groups[1].Value
    $arenas = [regex]::Matches($legacy, '(?ms)^  (\w+):\r?\n(.*?)(?=^  \w+:|^global-exit-location:)')
    if ($arenas.Count -ne 3 -or -not $defaultExit) { throw 'Formato inesperado no arquivo de arenas do FragSoc.' }

    foreach ($arena in $arenas) {
        $name = $arena.Groups[1].Value.ToLowerInvariant()
        $body = $arena.Groups[2].Value
        $values = @{}
        foreach ($entry in [regex]::Matches($body, '(?m)^\s+(x2?|y2?|z2?|timer|max-players): (-?\d+)\r?$')) {
            $values[$entry.Groups[1].Value] = [int] $entry.Groups[2].Value
        }
        $points = foreach ($axis in 'x', 'y', 'z') {
            $first = $values[$axis]
            $second = $values["${axis}2"]
            $coordinate = $axis.ToUpperInvariant()
            "    min${coordinate}: $([Math]::Min($first, $second))"
            "    max${coordinate}: $([Math]::Max($first, $second) + 1)"
        }
        $bounds = $points -join "`n"
        $sign = [regex]::Match($body, '(?m)^    lobbysign: world:([^\r\n]+)').Groups[1].Value
        $spawns = foreach ($entry in [regex]::Matches($body, '(?m)^    - world:([^\r\n]+)')) {
            "  - 'hungergames:$($entry.Groups[1].Value)'"
        }
        $spawnList = $spawns -join "`n"
        if ($values.Count -ne 8 -or -not $sign -or $spawns.Count -lt 2) { throw "Arena incompleta: $name" }

        $config = @"
info:
  timer: $($values.timer)
  min_players: 2
  max_players: $($values['max-players'])
  free_roam_time: 0
region:
  world: hungergames
  bounding_box:
    ==: BoundingBox
$bounds
locations:
  lobby_sign: 'hungergames:$sign'
  exit: 'hungergames:$defaultExit'
  spawns:
$spawnList
"@
        Write-NewConfig (Join-Path $plugins "HungerGames/arenas/$name.yml") $config
    }
}

function Add-YamlEntry($Path, $ExistingPattern, $Entry, $Parent = '') {
    $content = ''
    if (Test-Path -LiteralPath $Path) { $content = [IO.File]::ReadAllText($Path) }
    if ($content -match $ExistingPattern) { return }

    if ($Parent) {
        $header = "${Parent}:"
        $placeholder = '(?m)^' + [regex]::Escape($header) + '[ \t]*(?:\{\})?[ \t]*\r?$'
        if ($content -match $placeholder) {
            $content = $content -replace $placeholder, "$header`n$Entry"
        } elseif ($content -notmatch ('(?m)^' + [regex]::Escape($header))) {
            $content = "$header`n$Entry`n$content"
        } else {
            throw "Formato inesperado em $Path."
        }
    } else {
        if ($content.Trim() -eq '{}') { $content = '' }
        $content = $content.TrimEnd("`r", "`n") + "`n$Entry`n"
    }
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Path) | Out-Null
    [IO.File]::WriteAllText($Path, $content, $utf8)
}

function Install-AdditionalArenas {
    $bridgeModes = [ordered]@{ ponte = 1; ponte_2x2 = 2; ponte_3x3 = 3; ponte_4x4 = 4; ponte_4times_solo = 1; ponte_4times_duplas = 2 }
    $worlds = Join-Path $plugins 'Multiverse-Core/worlds.yml'
    foreach ($name in @($bridgeModes.Keys) + @('construcao', 'atelie_solo', 'atelie_duplas')) {
        $archiveName = $name
        if ($name -like 'atelie_*') { $archiveName = 'construcao' }
        if ($bridgeModes.Contains($name)) { $archiveName = 'ponte' }
        Install-World (Join-Path $PSScriptRoot "maps/$archiveName.zip") $name $archiveName
        $pvp = $bridgeModes.Contains($name).ToString().ToLowerInvariant()
        $spawnX = '0.5'
        $spawnYaw = '0.0'
        if ($pvp -eq 'true') {
            $spawnX = '-21.5'
            $spawnYaw = '-90.0'
        }
        $world = @"
minecraft:${name}:
  auto-load: true
  adjust-spawn: false
  gamemode: adventure
  generator: ''
  biome: ''
  portal-form: none
  pvp: $pvp
  spawn-location:
    ==: MVSpawnLocation
    x: $spawnX
    y: 100.0
    z: 0.5
    yaw: $spawnYaw
    pitch: 0.0
  read-only:
    environment: normal
    generator-settings: '{"layers":[{"block":"minecraft:air","height":1}],"biome":"minecraft:the_void"}'
    legacy-world-name: $name
  version: 1.3
"@
        Add-YamlEntry $worlds "(?m)^[""']?(?:minecraft:)?${name}[""']?:" $world
    }

    $permissions = Join-Path $server 'permissions.yml'
    Install-Bridge $bridgeModes $permissions
    foreach ($arena in 'construcao', 'atelie_solo', 'atelie_duplas') {
        $buildArena = [IO.File]::ReadAllText((Join-Path $configs "arenas/$arena.yml")).TrimEnd("`r", "`n")
        Add-YamlEntry (Join-Path $plugins 'BuildBattle/arenas.yml') "(?m)^  [""']?${arena}[""']?:" "$buildArena`n" 'instances'
        Add-YamlEntry $permissions "(?m)^[""']?buildbattle\.join\.${arena}[""']?:" "buildbattle.join.${arena}:`n  default: true"
    }
    $extraModes = @'
minigames.buildbattle-gamemode:
  default: true
  children:
    mv.bypass.gamemode.atelie_solo: true
    mv.bypass.gamemode.atelie_duplas: true
'@
    Add-YamlEntry $permissions '(?m)^["'']?minigames\.buildbattle-gamemode["'']?:' $extraModes
    $plotOptions = @'
minigames.buildbattle-plot-options:
  default: true
  children:
    biomes.vip: true
    buildbattle.heads: true
    buildbattle.particles: true
'@
    Add-YamlEntry $permissions '(?m)^["'']?minigames\.buildbattle-plot-options["'']?:' $plotOptions
    # The game plugins set and restore player modes for their matches.
    $gameModes = @'
minigames.arena-gamemode:
  default: true
  children:
    mv.bypass.gamemode.ponte: true
    mv.bypass.gamemode.construcao: true
'@
    Add-YamlEntry $permissions '(?m)^["'']?minigames\.arena-gamemode["'']?:' $gameModes
}

function Install-Bridge($Modes, $Permissions) {
    $directory = Join-Path $plugins 'TheBridge'
    $oldJar = Join-Path $plugins 'TheBridge-1.1.0.jar'
    $backup = Join-Path $server 'legacy-thebridge-1.1.0'
    if (Test-Path -LiteralPath $oldJar) {
        New-Item -ItemType Directory -Force -Path $backup | Out-Null
        if (Test-Path -LiteralPath (Join-Path $directory 'arenas')) {
            [IO.Directory]::Move($directory, (Join-Path $backup 'TheBridge'))
        }
        Move-Item -LiteralPath $oldJar -Destination $backup
    }

    $config = Join-Path $directory 'config.yml'
    Write-NewConfig $config @'
Save_Locally: true
Save_players_inventory: true
Start_percentage: 1.0
Waiting_For_Next_Round: 0
pit_radius: 1
lobby:
  enabled: true
  world: lobby
  x: 0.5
  y: 110.0
  z: 6.5
  yaw: 180.0
  pitch: 0.0
'@
    $content = [IO.File]::ReadAllText($config)
    $roundDelay = '(?m)^["'']?Waiting_For_Next_Round["'']?:[ \t]*[^ \t\r\n#]*'
    $updated = if ($content -cmatch $roundDelay) {
        $content -creplace $roundDelay, 'Waiting_For_Next_Round: 0'
    } else {
        $content.TrimEnd("`r", "`n") + "`nWaiting_For_Next_Round: 0`n"
    }
    if ($updated -cne $content) {
        [IO.File]::WriteAllText($config, $updated, $utf8)
    }
    $gameIndex = Join-Path $directory 'data.yml'
    Write-NewConfig $gameIndex ("games:`n" + (($Modes.Keys | ForEach-Object { "  - $_" }) -join "`n") + "`n")
    foreach ($name in $Modes.Keys) {
        $teams = "    team1: 0`n    team2: 1"
        if ($name -like 'ponte_4times_*') { $teams += "`n    team3: 2`n    team4: 3" }
        $edge = if ($name -eq 'ponte') { 1 } else { 3 }
        # The scoring layer (y=97) must be above the plugin's void cutoff (y=96).
        $arena = @"
game:
  world: $name
  direction: NEG_X
  center: {x: 0.0, y: 97.0, z: 0.0}
  pit: {x: -28.0, y: 100.0, z: 0.0}
  spawn: {x: -22.0, y: 99.0, z: 0.0}
  respawn: {x: -22.0, y: 99.0, z: 0.0}
  bridge:
    size: {y: 0}
    border: $edge
  border: 34
  team:
    max-players: $($Modes[$name])
  teams:
$teams
"@
        Write-NewConfig (Join-Path $directory "data/games/$name.yml") $arena
    }
    $gameModes = "minigames.bridge-modes:`n  default: true`n  children:`n" +
        (($Modes.Keys | ForEach-Object { "    mv.bypass.gamemode.${_}: true" }) -join "`n")
    Add-YamlEntry $Permissions '(?m)^["'']?minigames\.bridge-modes["'']?:' $gameModes
    $newJar = Join-Path $plugins 'Bridge-4.1.0.jar'
    if (-not (Test-Path -LiteralPath $newJar)) {
        [IO.File]::Copy((Join-Path $cache 'Bridge-4.1.0.jar'), $newJar)
    }
}

function Install-Server {
    New-Item -ItemType Directory -Force -Path $cache, $plugins | Out-Null
    $manifest = Get-Content -LiteralPath (Join-Path $configs 'downloads.json') -Raw | ConvertFrom-Json
    foreach ($item in $manifest) {
        $path = Get-Download $item
        if ($item.destination) {
            $destination = Join-Path $server $item.destination
            if (-not (Test-Path -LiteralPath $destination)) { [IO.File]::Copy($path, $destination) }
        }
        if ($item.world) { Install-World $path $item.world }
    }

    Write-NewConfig $properties ([IO.File]::ReadAllText((Join-Path $configs 'server.properties')))
    Write-NewConfig (Join-Path $plugins 'Multiverse-Core/worlds.yml') ([IO.File]::ReadAllText((Join-Path $configs 'worlds.yml')))
    $bedWars = Get-Content -LiteralPath (Join-Path $cache 'fragsoc-bedwars.yml') -Raw
    $bedWars = $bedWars -replace '(?m)^name: Arena\r?$', 'name: ilhas' -replace '(?m)^(world|lobbySpawnWorld): world\r?$', '$1: bedwars' -replace '(?m)^minPlayers: 4\r?$', 'minPlayers: 2'
    Write-NewConfig (Join-Path $plugins 'BedWars/arenas/ilhas.yml') $bedWars
    Install-HungerGamesArenas (Join-Path $cache 'fragsoc-hungergames.yml')
    Install-AdditionalArenas
}

New-Item -ItemType Directory -Force -Path $server | Out-Null
try {
    $lock = [IO.File]::Open((Join-Path $server 'server.lock'), 'OpenOrCreate', 'ReadWrite', 'None')
} catch [IO.IOException] {
    throw 'Pare o servidor antes de executar o instalador.'
}
try {
    $installed = (Test-Path -LiteralPath $properties) -and (Test-Path -LiteralPath (Join-Path $server 'paper.jar'))
    if (-not ($Offline -and $installed)) { Install-Server }
    if ($Offline) { Set-OfflineMode }
    if ($AcceptEula) {
        [IO.File]::WriteAllText((Join-Path $server 'eula.txt'), "eula=true`r`n", $utf8)
    } else {
        Write-NewConfig (Join-Path $server 'eula.txt') "eula=false`r`n"
    }
    Write-Host 'Instalacao preparada. Execute .\start.ps1 para abrir o servidor.'
} finally {
    $lock.Dispose()
}
