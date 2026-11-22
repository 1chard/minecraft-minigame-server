# Replace just the original BedWars stand if it still carries the old join action.
execute if data block -8 111 -5 front_text.messages[{click_event:{command:"/bw join ilhas"}}] if block -8 110 -5 minecraft:red_terracotta run setblock -8 110 -5 minecraft:air
setblock -2 110 3 minecraft:red_terracotta
setblock 2 110 3 minecraft:yellow_terracotta
setblock -2 111 3 minecraft:spruce_sign[rotation=0]{is_waxed:1b,front_text:{has_glowing_text:1b,messages:[{text:"BEDWARS",color:"red",bold:true},{text:"Ilhas"},{text:"Entrar na arena",color:"yellow",click_event:{action:"run_command",command:"/bw join ilhas"}},{text:""}]}}
setblock 2 111 3 minecraft:spruce_sign[rotation=0]{is_waxed:1b,front_text:{has_glowing_text:1b,messages:[{text:"HUNGER GAMES",color:"gold",bold:true},{text:"Sair da fila",color:"yellow",click_event:{action:"run_command",command:"/hg leave"}},{text:"/hg leave"},{text:""}]}}
