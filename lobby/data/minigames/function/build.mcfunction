# Foundation, paths and lighting
fill -12 108 -10 12 108 10 minecraft:deepslate_tiles
fill -11 109 -9 11 109 9 minecraft:smooth_stone
fill -12 109 -10 12 109 -10 minecraft:polished_deepslate
fill -12 109 10 12 109 10 minecraft:polished_deepslate
fill -12 109 -9 -12 109 9 minecraft:polished_deepslate
fill 12 109 -9 12 109 9 minecraft:polished_deepslate
fill -1 109 -3 1 109 8 minecraft:polished_andesite
fill -10 109 -5 10 109 -1 minecraft:spruce_planks
fill -10 109 -1 10 109 -1 minecraft:dark_oak_planks
setblock -9 109 8 minecraft:sea_lantern
setblock 9 109 8 minecraft:sea_lantern
setblock -9 109 1 minecraft:sea_lantern
setblock 9 109 1 minecraft:sea_lantern

# Courtyard rail and planters
fill -12 110 -10 12 110 -10 minecraft:polished_deepslate_wall
fill -12 110 10 12 110 10 minecraft:polished_deepslate_wall
fill -12 110 -9 -12 110 9 minecraft:polished_deepslate_wall
fill 12 110 -9 12 110 9 minecraft:polished_deepslate_wall
fill -10 110 3 -7 110 7 minecraft:spruce_planks
fill 7 110 3 10 110 7 minecraft:spruce_planks
fill -9 111 4 -8 111 6 minecraft:azalea_leaves[persistent=true]
fill 8 111 4 9 111 6 minecraft:flowering_azalea_leaves[persistent=true]
setblock -7 111 5 minecraft:lantern
setblock 7 111 5 minecraft:lantern

# Arena gallery
fill -10 110 -8 -10 114 -8 minecraft:stripped_spruce_log
fill 10 110 -8 10 114 -8 minecraft:stripped_spruce_log
fill -10 110 -3 -10 114 -3 minecraft:stripped_spruce_log
fill 10 110 -3 10 114 -3 minecraft:stripped_spruce_log
fill -11 114 -9 11 114 -2 minecraft:spruce_planks
fill -9 115 -8 9 115 -3 minecraft:dark_oak_slab[type=bottom]
setblock -8 113 -4 minecraft:lantern[hanging=true]
setblock -2 113 -4 minecraft:lantern[hanging=true]
setblock 2 113 -4 minecraft:lantern[hanging=true]
setblock 8 113 -4 minecraft:lantern[hanging=true]

# Each waxed sign runs one existing plugin join command as the player.
setblock -3 110 -5 minecraft:green_terracotta
setblock 3 110 -5 minecraft:cyan_terracotta
setblock 8 110 -5 minecraft:blue_terracotta
setblock -3 111 -5 minecraft:spruce_sign[rotation=0]{is_waxed:1b,front_text:{has_glowing_text:1b,messages:[{text:"HUNGER GAMES",color:"green",bold:true},{text:"First"},{text:"Clique para jogar",color:"yellow",click_event:{action:"run_command",command:"/hg join first"}},{text:""}]}}
setblock 3 111 -5 minecraft:spruce_sign[rotation=0]{is_waxed:1b,front_text:{has_glowing_text:1b,messages:[{text:"HUNGER GAMES",color:"aqua",bold:true},{text:"Second"},{text:"Clique para jogar",color:"yellow",click_event:{action:"run_command",command:"/hg join second"}},{text:""}]}}
setblock 8 111 -5 minecraft:spruce_sign[rotation=0]{is_waxed:1b,front_text:{has_glowing_text:1b,messages:[{text:"HUNGER GAMES",color:"blue",bold:true},{text:"Third"},{text:"Clique para jogar",color:"yellow",click_event:{action:"run_command",command:"/hg join third"}},{text:""}]}}

setworldspawn 0 110 6 180 0
gamerule minecraft:respawn_radius 0
data modify storage minigames:lobby installed set value 1b
