execute positioned -15 110 9 run function minigames:lobby_sign {rotation:12,title:"BEDWARS",color:"red",mode:"Ilhas",action:"Entrar",command:"/bw join ilhas"}
execute positioned -15 110 7 run function minigames:lobby_sign {rotation:12,title:"BEDWARS",color:"red",mode:"Fila / partida",action:"Sair",command:"/bw leave"}
execute positioned -15 110 3 run function minigames:lobby_sign {rotation:12,title:"HUNGER GAMES",color:"green",mode:"First",action:"Entrar",command:"/hg join first"}
execute positioned -15 110 1 run function minigames:lobby_sign {rotation:12,title:"HUNGER GAMES",color:"green",mode:"Second",action:"Entrar",command:"/hg join second"}
execute positioned -15 110 -1 run function minigames:lobby_sign {rotation:12,title:"HUNGER GAMES",color:"green",mode:"Third",action:"Entrar",command:"/hg join third"}
execute positioned -15 110 -3 run function minigames:lobby_sign {rotation:12,title:"HUNGER GAMES",color:"green",mode:"Fila / partida",action:"Sair",command:"/hg leave"}
execute positioned 15 110 8 run function minigames:lobby_sign {rotation:4,title:"Esconde-esconde",color:"green",mode:"Hide and Hunt",action:"Entrar",command:"/vj lobby"}
setblock -3 110 4 minecraft:polished_deepslate
setblock 3 110 4 minecraft:polished_deepslate
setblock -3 111 4 minecraft:spruce_sign[rotation=0]{is_waxed:1b,front_text:{has_glowing_text:1b,messages:[{text:"À esquerda",color:"gold"},{text:"BedWars"},{text:"Hunger Games"},{text:"TNT Run / Sumô"}]}}
setblock 3 111 4 minecraft:spruce_sign[rotation=0]{is_waxed:1b,front_text:{has_glowing_text:1b,messages:[{text:"À direita",color:"gold"},{text:"Esconde-esconde"},{text:"Build Battle"},{text:"Pilares"}]}}
