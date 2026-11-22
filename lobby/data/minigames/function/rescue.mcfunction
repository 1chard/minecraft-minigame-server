# Recover old spawn positions and falls anywhere below the lobby platform.
execute if data storage minigames:lobby installed as @a[gamemode=!creative,gamemode=!spectator] at @s if dimension minecraft:overworld if entity @s[y=-512,dy=619] run tp @s 0.5 110 6.5 180 0

# The imported Hunger Games map has its own old lobby beside the stock exit.
# Redirect that waiting room to the central plaza. Match areas are elsewhere.
execute if data storage minigames:lobby layout in minecraft:hungergames positioned 209 98 51 as @a[dx=17,dy=12,dz=18] in minecraft:overworld run tp @s 0.5 110 6.5 180 0
