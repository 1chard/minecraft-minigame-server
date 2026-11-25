fill -31 97 -7 31 105 7 minecraft:air
fill -7 94 0 -7 98 0 minecraft:deepslate_bricks
fill 7 94 0 7 98 0 minecraft:deepslate_bricks
setblock -7 99 0 minecraft:red_concrete
setblock 7 99 0 minecraft:blue_concrete
setworldspawn -7 100 0
gamerule minecraft:spawn_mobs false
gamerule minecraft:natural_health_regeneration false
data modify storage minigames:duels pilares set value 1
forceload remove -31 -7 31 7
