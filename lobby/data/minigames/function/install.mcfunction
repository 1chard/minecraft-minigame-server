execute in minecraft:overworld if loaded -12 109 -10 if loaded 12 109 -10 if loaded -12 109 10 if loaded 12 109 10 run function minigames:update
execute unless data storage minigames:lobby {layout:3} run schedule function minigames:install 10t replace
