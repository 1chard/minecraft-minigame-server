$execute in minecraft:$(arena) unless data storage minigames:duels $(arena) run forceload add -31 -10 31 10
$execute in minecraft:$(arena) unless data storage minigames:duels $(arena) if loaded -24 99 -8 if loaded -8 99 -8 if loaded 8 99 -8 if loaded 24 99 -8 if loaded -24 99 8 if loaded -8 99 8 if loaded 8 99 8 if loaded 24 99 8 run function minigames:build_ffa {arena:"$(arena)",map:"$(map)"}
$execute in minecraft:$(arena) unless data storage minigames:duels $(arena) run schedule function minigames:ffa_worlds 1t replace
