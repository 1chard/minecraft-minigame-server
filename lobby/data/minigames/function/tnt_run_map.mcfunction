# Clear the structure in the imported void-world template.
fill -31 97 -7 31 105 7 minecraft:air

# Three removable sandstone floors with open space beneath the bottom floor.
fill -10 64 -10 10 64 10 minecraft:sandstone
fill -4 64 -4 4 64 4 minecraft:red_sandstone
fill -10 56 -10 10 56 10 minecraft:red_sandstone
fill -4 56 -4 4 56 4 minecraft:sandstone
fill -10 48 -10 10 48 10 minecraft:sandstone
fill -4 48 -4 4 48 4 minecraft:red_sandstone

fill -11 46 -11 11 67 -11 minecraft:orange_stained_glass
fill -11 46 11 11 67 11 minecraft:orange_stained_glass
fill -11 46 -10 -11 67 10 minecraft:orange_stained_glass
fill 11 46 -10 11 67 10 minecraft:orange_stained_glass
fill -11 68 -11 11 68 -11 minecraft:polished_deepslate
fill -11 68 11 11 68 11 minecraft:polished_deepslate
fill -11 68 -10 -11 68 10 minecraft:polished_deepslate
fill 11 68 -10 11 68 10 minecraft:polished_deepslate

# Separate waiting platform with a view of the arena.
fill 20 64 -4 28 64 4 minecraft:polished_deepslate
fill 20 65 -4 28 66 -4 minecraft:orange_stained_glass
fill 20 65 4 28 66 4 minecraft:orange_stained_glass
fill 20 65 -3 20 66 3 minecraft:orange_stained_glass
fill 28 65 -3 28 66 3 minecraft:orange_stained_glass
setblock 24 64 0 minecraft:sea_lantern
setworldspawn 24 65 0 90 0

data modify storage minigames:tnt_run built set value 1
forceload remove -31 -11 31 11
