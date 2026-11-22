# Recover old spawn positions and falls directly beneath the lobby.
execute if data storage minigames:lobby installed in minecraft:overworld positioned -12 -64 -10 as @a[dx=24,dy=171,dz=20] run tp @s 0.5 110 6.5 180 0

# The imported Hunger Games map has its own old lobby beside the stock exit.
# Redirect that waiting room to the central plaza. Match areas are elsewhere.
execute if data storage minigames:lobby layout in minecraft:hungergames positioned 209 98 51 as @a[dx=17,dy=12,dz=18] in minecraft:overworld run tp @s 0.5 110 6.5 180 0
