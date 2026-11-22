execute unless data storage minigames:buildbattle solo8 run clone -26 98 -26 26 99 26 -26 98 30
fill -2 98 27 2 98 29 minecraft:polished_deepslate
fill -2 99 27 2 99 29 minecraft:polished_andesite
execute positioned 0 0 0 run function minigames:buildbattle_solo_rooms
execute positioned 0 0 56 run function minigames:buildbattle_solo_rooms
data modify storage minigames:buildbattle solo8 set value 2
forceload remove -27 -27 27 83
