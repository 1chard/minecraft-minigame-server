execute unless data storage minigames:lobby installed run function minigames:build
execute unless data storage minigames:lobby layout run function minigames:entrance
function minigames:new_arenas

data modify storage minigames:lobby layout set value 3
forceload remove -12 -10 12 10
