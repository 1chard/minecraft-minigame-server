# Recover old spawn positions and falls anywhere below the lobby platform.
execute if data storage minigames:lobby installed as @a[gamemode=!creative,gamemode=!spectator] at @s if dimension minecraft:overworld if entity @s[y=-512,dy=619] run tp @s 0.5 110 6.5 180 0

# The imported Hunger Games map has its own old lobby beside the stock exit.
# Redirect that waiting room to the central plaza. Match areas are elsewhere.
execute if data storage minigames:lobby layout in minecraft:hungergames positioned 209 98 51 as @a[dx=17,dy=12,dz=18] in minecraft:overworld run tp @s 0.5 110 6.5 180 0

# A disconnect or a first sighting in a Build Battle world means the saved
# location may belong to a match the player has already left.
scoreboard players add @a bb_disconnects 0
execute if data storage minigames:lobby installed as @a unless score @s bb_seen = @s bb_disconnects at @s if dimension minecraft:construcao run function minigames:return_from_buildbattle
execute if data storage minigames:lobby installed as @a unless score @s bb_seen = @s bb_disconnects at @s if dimension minecraft:atelie_solo run function minigames:return_from_buildbattle
execute if data storage minigames:lobby installed as @a unless score @s bb_seen = @s bb_disconnects at @s if dimension minecraft:atelie_duplas run function minigames:return_from_buildbattle
# Hide and Hunt restores saved state five ticks after login. Check where the
# player ended up after that restoration, without moving anyone mid-round.
execute if data storage minigames:lobby installed as @a unless score @s bb_seen = @s bb_disconnects at @s if dimension minecraft:versteckjagd_arena run scoreboard players set @s hide_reconnect 12
execute if data storage minigames:lobby installed as @a unless score @s bb_seen = @s bb_disconnects at @s if dimension minecraft:versteckjagd_lobby run scoreboard players set @s hide_reconnect 12
execute as @a unless score @s bb_seen = @s bb_disconnects run scoreboard players operation @s bb_seen = @s bb_disconnects
scoreboard players remove @a[scores={hide_reconnect=1..}] hide_reconnect 1
execute as @a[scores={hide_reconnect=0}] at @s if dimension minecraft:versteckjagd_arena run function minigames:return_from_hide
execute as @a[scores={hide_reconnect=0}] at @s if dimension minecraft:versteckjagd_lobby run function minigames:return_from_hide
scoreboard players reset @a[scores={hide_reconnect=0}] hide_reconnect

# Let the plugin finish restoring the player, then forward its lobby return to the hub.
execute if data storage minigames:lobby installed as @a[tag=hide_played] at @s if dimension minecraft:versteckjagd_lobby run function minigames:return_from_hide
execute as @a[tag=hide_played] at @s unless dimension minecraft:versteckjagd_arena run tag @s remove hide_played
execute as @a[tag=!hide_played] at @s if dimension minecraft:versteckjagd_arena run tag @s add hide_played

execute in minecraft:versteckjagd_lobby if loaded 6 65 16 unless block 6 66 16 minecraft:oak_sign run function minigames:build_hide_exit
execute if data storage minigames:lobby installed as @a at @s if dimension minecraft:versteckjagd_lobby run function minigames:hide_lobby_return
execute as @a[tag=hide_lobby] at @s unless dimension minecraft:versteckjagd_lobby run tag @s remove hide_lobby
scoreboard players reset @a[scores={lobby_principal=1..}] lobby_principal
