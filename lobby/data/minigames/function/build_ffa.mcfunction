fill -31 97 -7 31 105 7 minecraft:air
gamerule minecraft:spawn_mobs false
$function minigames:$(map)_map
$data modify storage minigames:duels $(arena) set value 1
forceload remove -31 -10 31 10
