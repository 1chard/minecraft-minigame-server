# Build or update the plaza after its chunks are loaded.
execute in minecraft:overworld unless data storage minigames:lobby {layout:10} run forceload add -21 -25 21 13
execute unless data storage minigames:lobby {layout:10} run schedule function minigames:install 1t replace
schedule function minigames:world_rules 1t replace
scoreboard objectives add bb_disconnects minecraft.custom:minecraft.leave_game
scoreboard objectives add bb_seen dummy
scoreboard objectives add lobby_principal trigger
scoreboard objectives add hide_reconnect dummy
