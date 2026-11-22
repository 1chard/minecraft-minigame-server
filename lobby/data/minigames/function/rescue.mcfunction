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
execute as @a unless score @s bb_seen = @s bb_disconnects run scoreboard players operation @s bb_seen = @s bb_disconnects
