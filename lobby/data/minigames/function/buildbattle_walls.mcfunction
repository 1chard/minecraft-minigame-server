# Remove the old enclosures from existing worlds, then divide the four quadrants.
execute if data storage minigames:buildbattle {walls:1} positioned 0 0 0 run function minigames:remove_buildbattle_enclosures
fill 0 100 -25 0 127 25 minecraft:smooth_sandstone
fill -25 100 0 25 127 0 minecraft:smooth_sandstone
# Close the outer sides and roof of the four quadrants without blocking the view.
fill -25 100 -25 25 127 -25 minecraft:barrier replace minecraft:air
fill -25 100 25 25 127 25 minecraft:barrier replace minecraft:air
fill -25 100 -24 -25 127 24 minecraft:barrier replace minecraft:air
fill 25 100 -24 25 127 24 minecraft:barrier replace minecraft:air
fill -25 128 -25 25 128 25 minecraft:barrier replace minecraft:air
data modify storage minigames:buildbattle walls set value 4
forceload remove -23 -23 23 23
