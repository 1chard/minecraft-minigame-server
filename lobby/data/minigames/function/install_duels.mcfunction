execute in minecraft:sumo_duelo unless data storage minigames:duels sumo if loaded -24 99 -4 if loaded -8 99 -4 if loaded 8 99 -4 if loaded 24 99 -4 if loaded -24 99 4 if loaded -8 99 4 if loaded 8 99 4 if loaded 24 99 4 run function minigames:sumo_map
execute in minecraft:pilares_duelo unless data storage minigames:duels pilares if loaded -24 99 -4 if loaded -8 99 -4 if loaded 8 99 -4 if loaded 24 99 -4 if loaded -24 99 4 if loaded -8 99 4 if loaded 8 99 4 if loaded 24 99 4 run function minigames:pilares_map
execute in minecraft:sumo_duelo unless data storage minigames:duels sumo run schedule function minigames:install_duels 1t replace
execute in minecraft:pilares_duelo unless data storage minigames:duels pilares run schedule function minigames:install_duels 1t replace
