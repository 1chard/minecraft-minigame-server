# Apply after Multiverse has loaded the arena worlds.
execute in minecraft:overworld run gamerule minecraft:pvp false
execute in minecraft:overworld run gamerule minecraft:spawn_mobs false
execute in minecraft:overworld run gamerule minecraft:mob_griefing false
execute in minecraft:bedwars run gamerule minecraft:natural_health_regeneration false
execute in minecraft:hungergames run gamerule minecraft:natural_health_regeneration false
execute in minecraft:ponte run gamerule minecraft:natural_health_regeneration false
execute unless data storage minigames:buildbattle {walls:4} in minecraft:construcao run forceload add -23 -23 23 23
execute unless data storage minigames:buildbattle {walls:4} in minecraft:construcao run schedule function minigames:install_buildbattle 1t replace
execute unless data storage minigames:buildbattle {solo8:2} in minecraft:atelie_solo run forceload add -27 -27 27 83
execute unless data storage minigames:buildbattle duplas8 in minecraft:atelie_duplas run forceload add -23 -23 23 23
execute unless data storage minigames:buildbattle {solo8:2} in minecraft:atelie_solo run schedule function minigames:install_buildbattle_expansion 1t replace
execute unless data storage minigames:buildbattle duplas8 in minecraft:atelie_duplas run schedule function minigames:install_buildbattle_expansion 1t replace
