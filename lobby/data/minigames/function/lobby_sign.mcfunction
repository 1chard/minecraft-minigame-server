setblock ~ ~ ~ minecraft:polished_deepslate
$setblock ~ ~1 ~ minecraft:spruce_sign[rotation=$(rotation)]{is_waxed:1b,front_text:{has_glowing_text:1b,messages:[{text:"$(title)",color:"$(color)"},{text:"$(mode)"},{text:"$(action)",color:"yellow",click_event:{action:"run_command",command:"$(command)"}},{text:""}]}}
