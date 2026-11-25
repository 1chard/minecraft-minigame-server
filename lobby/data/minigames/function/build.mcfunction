# Remove the previous courtyard fixtures before rebuilding the plaza.
fill -12 110 -10 12 115 10 minecraft:air

# Foundation, rail and main promenade.
fill -21 108 -25 21 108 13 minecraft:deepslate_tiles
fill -21 109 -25 21 109 13 minecraft:polished_deepslate
fill -20 109 -24 20 109 12 minecraft:smooth_stone
fill -2 109 -20 2 109 11 minecraft:polished_andesite
fill 0 109 -20 0 109 11 minecraft:chiseled_stone_bricks
fill -21 110 -25 21 110 -25 minecraft:polished_deepslate_wall
fill -21 110 13 21 110 13 minecraft:polished_deepslate_wall
fill -21 110 -24 -21 110 12 minecraft:polished_deepslate_wall
fill 21 110 -24 21 110 12 minecraft:polished_deepslate_wall
fill -2 109 5 2 109 8 minecraft:quartz_bricks
setblock 0 109 6 minecraft:sea_lantern
setblock -4 109 6 minecraft:sea_lantern
setblock 4 109 6 minecraft:sea_lantern
setblock -4 109 -3 minecraft:sea_lantern
setblock 4 109 -3 minecraft:sea_lantern
setblock -4 109 -12 minecraft:sea_lantern
setblock 4 109 -12 minecraft:sea_lantern

# Bays face the promenade, with a colored floor and back panel for each game.
execute positioned -14.5 110 8.5 rotated 90 0 run function minigames:lobby_bay {accent:"red_terracotta"}
execute positioned -14.5 110 0.5 rotated 90 0 run function minigames:lobby_bay {accent:"green_terracotta"}
execute positioned -14.5 110 -7.5 rotated 90 0 run function minigames:lobby_bay {accent:"orange_terracotta"}
execute positioned -14.5 110 -15.5 rotated 90 0 run function minigames:lobby_bay {accent:"purple_terracotta"}
execute positioned 15.5 110 8.5 rotated -90 0 run function minigames:lobby_bay {accent:"lime_terracotta"}
execute positioned 15.5 110 0.5 rotated -90 0 run function minigames:lobby_bay {accent:"magenta_terracotta"}
execute positioned 15.5 110 -7.5 rotated -90 0 run function minigames:lobby_bay {accent:"cyan_terracotta"}

# The Bridge has a wider gallery at the end of the promenade.
fill -11 109 -24 11 109 -20 minecraft:light_blue_terracotta
fill -11 110 -24 11 113 -24 minecraft:light_blue_terracotta
fill -11 114 -24 11 114 -20 minecraft:dark_oak_planks
fill -11 110 -20 -11 113 -20 minecraft:stripped_spruce_log
fill 11 110 -20 11 113 -20 minecraft:stripped_spruce_log
setblock -6 113 -21 minecraft:lantern[hanging=true]
setblock 0 113 -21 minecraft:lantern[hanging=true]
setblock 6 113 -21 minecraft:lantern[hanging=true]

# Small planted beds at the sides leave direct paths to every station.
fill -20 109 -17 -19 109 10 minecraft:moss_block
fill 19 109 -17 20 109 10 minecraft:moss_block
setblock -19 110 10 minecraft:azalea
setblock -19 110 4 minecraft:flowering_azalea
setblock -19 110 -5 minecraft:azalea
setblock 19 110 10 minecraft:flowering_azalea
setblock 19 110 4 minecraft:azalea
setblock 19 110 -5 minecraft:flowering_azalea

setworldspawn 0 110 6 180 0
gamerule minecraft:respawn_radius 0
data modify storage minigames:lobby installed set value 1b
