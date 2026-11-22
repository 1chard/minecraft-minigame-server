# Expand the walkable floor while preserving the plot surfaces and their borders.
execute if data storage minigames:buildbattle {solo8:1} run function minigames:remove_buildbattle_enclosures
fill ~-26 ~100 ~-26 ~26 ~100 ~-26 minecraft:air replace minecraft:polished_deepslate_wall
fill ~-26 ~100 ~26 ~26 ~100 ~26 minecraft:air replace minecraft:polished_deepslate_wall
fill ~-26 ~100 ~-25 ~-26 ~100 ~25 minecraft:air replace minecraft:polished_deepslate_wall
fill ~26 ~100 ~-25 ~26 ~100 ~25 minecraft:air replace minecraft:polished_deepslate_wall
fill ~-27 ~98 ~-27 ~27 ~98 ~27 minecraft:polished_deepslate replace minecraft:air
fill ~-27 ~99 ~-27 ~27 ~99 ~27 minecraft:smooth_stone replace minecraft:air

# The walls enclose 24 by 24 blocks around each original 17 by 17 plot.
fill ~-27 ~100 ~-27 ~-2 ~127 ~-27 minecraft:smooth_sandstone
fill ~-27 ~100 ~-2 ~-2 ~127 ~-2 minecraft:smooth_sandstone
fill ~-27 ~100 ~-26 ~-27 ~127 ~-3 minecraft:smooth_sandstone
fill ~-2 ~100 ~-26 ~-2 ~127 ~-3 minecraft:smooth_sandstone

fill ~2 ~100 ~-27 ~27 ~127 ~-27 minecraft:smooth_sandstone
fill ~2 ~100 ~-2 ~27 ~127 ~-2 minecraft:smooth_sandstone
fill ~2 ~100 ~-26 ~2 ~127 ~-3 minecraft:smooth_sandstone
fill ~27 ~100 ~-26 ~27 ~127 ~-3 minecraft:smooth_sandstone

fill ~-27 ~100 ~2 ~-2 ~127 ~2 minecraft:smooth_sandstone
fill ~-27 ~100 ~27 ~-2 ~127 ~27 minecraft:smooth_sandstone
fill ~-27 ~100 ~3 ~-27 ~127 ~26 minecraft:smooth_sandstone
fill ~-2 ~100 ~3 ~-2 ~127 ~26 minecraft:smooth_sandstone

fill ~2 ~100 ~2 ~27 ~127 ~2 minecraft:smooth_sandstone
fill ~2 ~100 ~27 ~27 ~127 ~27 minecraft:smooth_sandstone
fill ~2 ~100 ~3 ~2 ~127 ~26 minecraft:smooth_sandstone
fill ~27 ~100 ~3 ~27 ~127 ~26 minecraft:smooth_sandstone
