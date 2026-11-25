execute unless entity @s[tag=hide_lobby] run tellraw @s {text:"[Voltar ao lobby principal]",color:"green",underlined:true,click_event:{action:"run_command",command:"/trigger lobby_principal"}}
execute unless entity @s[tag=hide_lobby] run tag @s add hide_lobby
scoreboard players enable @s lobby_principal
execute if entity @s[x=4,y=65,z=15,dx=1,dy=1,dz=2] run return run function minigames:return_from_hide
execute if score @s lobby_principal matches 1.. run function minigames:return_from_hide
