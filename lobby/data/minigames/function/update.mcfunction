execute unless data storage minigames:lobby installed run function minigames:build
execute unless data storage minigames:lobby layout run function minigames:entrance
execute unless data storage minigames:lobby {layout:3} unless data storage minigames:lobby {layout:4} run function minigames:new_arenas
function minigames:buildbattle_signs
function minigames:bridge_signs

data modify storage minigames:lobby layout set value 5
forceload remove -12 -10 12 10
