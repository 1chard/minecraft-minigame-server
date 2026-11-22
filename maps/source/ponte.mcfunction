gamerule minecraft:spawn_mobs false
setworldspawn -22 100 0 -90 0

# Bases and bridge
fill -30 98 -6 -17 98 6 minecraft:deepslate_bricks
fill 17 98 -6 30 98 6 minecraft:deepslate_bricks
fill -30 99 -6 -17 99 6 minecraft:red_terracotta
fill 17 99 -6 30 99 6 minecraft:blue_terracotta
fill -16 99 -1 16 99 1 minecraft:smooth_stone
fill -16 99 0 16 99 0 minecraft:polished_andesite
fill -30 100 -6 -21 100 -6 minecraft:deepslate_brick_wall
fill -30 100 6 -21 100 6 minecraft:deepslate_brick_wall
fill 21 100 -6 30 100 -6 minecraft:deepslate_brick_wall
fill 21 100 6 30 100 6 minecraft:deepslate_brick_wall

# Red goal. The gap below the arch is the scoring region.
fill -29 99 -1 -27 99 1 minecraft:red_glazed_terracotta
fill -28 100 -2 -28 103 -2 minecraft:red_concrete
fill -28 100 2 -28 103 2 minecraft:red_concrete
fill -28 103 -2 -28 103 2 minecraft:red_concrete
setblock -28 104 0 minecraft:sea_lantern

# Blue goal
fill 27 99 -1 29 99 1 minecraft:blue_glazed_terracotta
fill 28 100 -2 28 103 -2 minecraft:blue_concrete
fill 28 100 2 28 103 2 minecraft:blue_concrete
fill 28 103 -2 28 103 2 minecraft:blue_concrete
setblock 28 104 0 minecraft:sea_lantern
setblock -22 99 0 minecraft:sea_lantern
setblock 22 99 0 minecraft:sea_lantern
