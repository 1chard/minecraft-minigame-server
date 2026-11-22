# Build or update after the four chunks surrounding the courtyard are loaded.
execute in minecraft:overworld unless data storage minigames:lobby {layout:3} run forceload add -12 -10 12 10
execute unless data storage minigames:lobby {layout:3} run schedule function minigames:install 1t replace
schedule function minigames:world_rules 1t replace
