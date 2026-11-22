gamerule minecraft:spawn_mobs false
setworldspawn 0 100 0 0 0

# Walkways and the center between the four plots
fill -26 98 -26 26 98 26 minecraft:polished_deepslate
fill -26 99 -26 26 99 26 minecraft:smooth_stone
fill -26 100 -26 26 100 -26 minecraft:polished_deepslate_wall
fill -26 100 26 26 100 26 minecraft:polished_deepslate_wall
fill -26 100 -25 -26 100 25 minecraft:polished_deepslate_wall
fill 26 100 -25 26 100 25 minecraft:polished_deepslate_wall
fill -2 99 -25 2 99 25 minecraft:polished_andesite
fill -25 99 -2 25 99 2 minecraft:polished_andesite
setblock 0 99 0 minecraft:sea_lantern

# Each plot has a neutral 17x17 surface and a colored border outside its bounds.
fill -23 99 -23 -5 99 -5 minecraft:orange_terracotta
fill -22 99 -22 -6 99 -6 minecraft:grass_block
fill 5 99 -23 23 99 -5 minecraft:light_blue_terracotta
fill 6 99 -22 22 99 -6 minecraft:grass_block
fill -23 99 5 -5 99 23 minecraft:lime_terracotta
fill -22 99 6 -6 99 22 minecraft:grass_block
fill 5 99 5 23 99 23 minecraft:magenta_terracotta
fill 6 99 6 22 99 22 minecraft:grass_block
setblock -5 99 -5 minecraft:sea_lantern
setblock 5 99 -5 minecraft:sea_lantern
setblock -5 99 5 minecraft:sea_lantern
setblock 5 99 5 minecraft:sea_lantern
