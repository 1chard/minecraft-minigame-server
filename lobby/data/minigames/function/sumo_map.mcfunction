fill -31 97 -7 31 105 7 minecraft:air
fill -5 99 -5 5 99 5 minecraft:polished_deepslate
fill -3 99 -3 3 99 3 minecraft:smooth_quartz
setblock -3 99 0 minecraft:red_concrete
setblock 3 99 0 minecraft:blue_concrete
setworldspawn 0 100 0
gamerule minecraft:spawn_mobs false
data modify storage minigames:duels sumo set value 1
forceload remove -31 -7 31 7
