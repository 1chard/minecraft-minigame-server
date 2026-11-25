# Minecraft Minigames no Windows

Servidor local de **Minecraft Java Edition 1.21.11** com Paper build 132. O PowerShell instala os plugins e os mapas existentes e inicia o Paper diretamente com o Java do Windows.

O ViaVersion permite que clientes Java mais novos, até a versão 26.3, entrem no servidor 1.21.11. O suporte a novos protocolos depende de atualizações do plugin. [ViaVersion](https://modrinth.com/plugin/viaversion)

| Modo | Plugin | Arenas instaladas |
| --- | --- | --- |
| BedWars | ScreamingBedWars 0.2.44 | `ilhas` |
| Hunger Games | HungerGames 5.1.1 | `first`, `second`, `third` |
| The Bridge | The Bridge 4.1.0 | 1x1, 2x2, 3x3, 4x4, 1x1x1x1 e 2x2x2x2 |
| TNT Run | TNTRun 2.9.1 | `torre` (Torre de Areia, de dois a oito jogadores, três andares) |
| Esconde-esconde | Hide and Hunt 1.6.0 | Mapas gerados pelo plugin, com partidas em grupo |
| Sumô e Pilares da Fortuna | Minigames Framework 1.0.0 | Duelo 1x1 nos dois modos, Sumô de 3 a 4 jogadores e Pilares de 3 a 4 ou de 6 a 8 jogadores |
| Build Battle | BuildBattle 5.1.8 | `construcao` (Ateliê, dois a quatro jogadores, cinco minutos de construção) |
| Build Battle | BuildBattle 5.1.8 | `atelie_solo` (Solo, dois a oito jogadores) e `atelie_duplas` (Duplas, quatro a oito jogadores) |

O Multiverse-Core 5.8.2 carrega os mundos `bedwars`, `hungergames`, `ponte` e `construcao`. As três arenas de Hunger Games ocupam regiões distintas do mesmo mundo. Os jogadores entram na praça `lobby` e escolhem uma arena pelas placas ou pelos comandos abaixo. As arenas iniciais foram ajustadas para começar com pelo menos dois jogadores.

A praça fica em um mundo vazio e os jogadores entram em modo Aventura, com o PvP desligado. BedWars, Hunger Games e The Bridge usam dificuldade Normal e têm a regeneração natural de vida desligada. Os itens e efeitos de cura continuam funcionando conforme as regras de cada minijogo.

No Build Battle, as paredes opacas separam os terrenos durante a construção. Depois dos cinco minutos de construção, o plugin leva os jogadores a cada terreno para votar.

Para mudar o piso durante a construção, coloque um bloco sólido, como pedra, na barra rápida. Abra o menu de opções do terreno, pegue o bloco com o cursor no inventário e clique no ícone **Change floor material** com o bloco no cursor. Jogadores comuns também podem usar as opções de biomas, cabeças decorativas e partículas.

## Instalação e início

Use Java 25 ou superior no `PATH` e execute os comandos abaixo em um PowerShell aberto na pasta do projeto. A primeira instalação e o primeiro início precisam de internet. Se precisar instalar o Java, use o instalador Windows do [Eclipse Temurin 25](https://adoptium.net/temurin/releases/?version=25&os=windows).

Leia a [EULA do Minecraft](https://www.minecraft.net/pt-br/eula). Execute a primeira linha se aceitar os termos.

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\setup.ps1 -AcceptEula -Offline
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\start.ps1
```

Na próxima vez, basta executar a segunda linha. O limite padrão de memória do Java é 4 GB. Para usar 2 GB, acrescente `-MemoryGB 2` ao comando de início. Para encerrar e salvar os mundos, digite `stop` no console do Paper.

Em uma instalação que veio de uma versão anterior do projeto, pare o servidor e execute `setup.ps1` novamente para instalar os mapas novos e registrar as arenas. O lobby aplica as placas novas na próxima inicialização.

## Modo offline

Instalações novas usam autenticação do Minecraft por padrão. Para instalar com autenticação, remova `-Offline` à linha de instalação. Para ativá-lo em uma instalação existente, pare o servidor com `stop` e execute:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\setup.ps1 -Offline
```

O comando altera `online-mode` e `enforce-secure-profile` para `false`. Em uma instalação pronta, dispensa novos downloads e mantém os arquivos dos jogadores. Ao alternar o modo, o Minecraft usa identificadores de jogador diferentes, e inventários, permissões e estatísticas podem aparecer separados. Para voltar à autenticação, mude as duas propriedades para `true` em `server-data/server.properties` e reinicie.

## Acesso pela internet com UPnP

Ao iniciar, `start.ps1` procura o gateway UPnP pela interface IPv4 usada pelo servidor e tenta encaminhar a porta TCP de `server-port` (por padrão, `25565`). Se `enable-query=true`, também tenta encaminhar a porta UDP de `query.port`. Se o servidor estava configurado para escutar só no loopback, um mapeamento TCP bem-sucedido faz o Paper escutar nas interfaces IPv4 durante essa execução. O script remove os mapeamentos que criou ao encerrar normalmente. Se o roteador recusar o pedido, o Paper mostra o motivo no console e segue com a inicialização. [Especificação UPnP IGD](https://upnp.org/specs/gw/UPnP-gw-WANPPPConnection-v1-Service.pdf)

O acesso externo também depende de um IPv4 público alcançável e de uma regra de entrada no Firewall do Windows para o `java.exe` que executa o Paper. Se o console confirmar o UPnP mas a conexão externa expirar, confira se a porta TCP de `server-port` está liberada para esse executável no perfil da rede. O teste externo deve vir de outra rede, pois alguns roteadores não aceitam acesso ao próprio endereço público por dentro da LAN.

Em modo offline, o servidor aceita nomes sem verificar a identidade do jogador. Use autenticação para partidas expostas à internet.

## Entrar e jogar

Abra **Multijogador** no Minecraft Java **1.21.11** e conecte a `127.0.0.1:25565`.

O datapack monta uma praça elevada no mundo `lobby`. A partir da entrada, **BedWars**, **Hunger Games**, **TNT Run** e **Sumô** ficam à esquerda. **Esconde-esconde**, **Build Battle** e **Pilares** ficam à direita. **The Bridge** ocupa a galeria ao fundo. Cada área reúne as placas de entrada e saída do jogo. Use o botão direito na frente da placa desejada ou digite o comando no chat.

| No chat do jogo | Ação |
| --- | --- |
| `/bw join ilhas` | Entrar no BedWars |
| `/bw leave` | Sair do BedWars |
| `/hg listgames` | Listar as arenas de Hunger Games |
| `/hg join first` | Entrar em `first`. Use também `second` ou `third`. |
| `/hg leave` | Sair da fila ou da partida de Hunger Games |
| `/tb join ponte` | Ponte 1x1, 2 jogadores |
| `/tb join ponte_2x2` | Ponte 2x2, 4 jogadores |
| `/tb join ponte_3x3` | Ponte 3x3, 6 jogadores |
| `/tb join ponte_4x4` | Ponte 4x4, 8 jogadores |
| `/tb join ponte_4times_solo` | Quatro times de um jogador |
| `/tb join ponte_4times_duplas` | Quatro times de dois jogadores |
| `/tb leave` | Sair da fila ou da partida de The Bridge |
| `/tr join torre` | Entrar na Torre de Areia do TNT Run |
| `/tr leave` | Sair da fila ou da partida de TNT Run |
| `/vj lobby` | Ir ao lobby de esconde-esconde |
| `/vj play` | Abrir o menu para criar ou entrar em uma partida de esconde-esconde |
| `/vj leave` | Sair da partida de esconde-esconde |
| `/trigger lobby_principal` | Voltar ao lobby principal a partir do lobby de esconde-esconde |
| `/mg sumo join type1` | Entrar no duelo de Sumô |
| `/mg pillars join type1` | Entrar no duelo de Pilares da Fortuna |
| `/mg sumo join type2` | Entrar no Sumô para 3 a 4 jogadores |
| `/mg pillars join type2` | Entrar em Pilares para 3 a 4 jogadores |
| `/mg pillars join type3` | Entrar em Pilares para 6 a 8 jogadores |
| `/mg leave` | Sair da fila ou partida de Sumô ou Pilares |
| `/buildbattle join construcao` | Entrar no Ateliê para construir no criativo e votar |
| `/buildbattle join atelie_solo` | Entrar no Solo 8, com um jogador por terreno |
| `/buildbattle join atelie_duplas` | Entrar em Duplas, com até quatro equipes de dois jogadores |
| `/buildbattle leave` | Sair da fila ou da partida de Build Battle |

Para conferir o carregamento, veja `server-data/logs/latest.log`. Para testar uma partida, entre na mesma arena com duas contas Java e confira o início, o fim e a restauração do mapa ao jogar de novo. [Comandos do BedWars](https://docs.screamingsandals.org/BedWars/latest/commands/) · [Comandos do HungerGames](https://github.com/ShaneBeeStudios/HungerGames/wiki/Commands-Permissions)

No Hide and Hunt, entre pela placa **Esconde-esconde**, use o portal do modo desejado ou abra `/vj play`. Crie um grupo, convide os amigos e escolha o mapa. Ao terminar a partida, usar `/vj leave` ou reconectar em um mundo do minigame, o jogador volta ao hub principal. Para sair da sala de espera, pise no piso verde junto à placa **Hub principal** ou use `/trigger lobby_principal`. [Hide and Hunt](https://modrinth.com/plugin/hide-and-hunt)

## Jogar em rede local

Pare o servidor, esvazie o valor de `server-ip` em `server-data/server.properties` e mude `white-list` para `true`. Após reiniciar, use `whitelist add NomeDoJogador` no console para cada conta, incluindo a sua. Os amigos entram usando o IPv4 do PC que hospeda o servidor, exibido por `ipconfig`, seguido de `:25565`. Se o Windows solicitar acesso para o Java, use o perfil de rede privada.

## Adicionar outros mapas

1. Pare o servidor e copie a pasta de um mundo Java compatível para `server-data/<nome_do_mundo>`. Ela deve conter `level.dat` e `region/` diretamente na raiz. Dê um nome único ao mundo, por exemplo `bw_sakura`.
2. Inicie o servidor e use `op SeuNick` no console para administrar pelo Minecraft. No jogo, use `/mv import bw_sakura normal` e `/mv tp bw_sakura`. [Importar mundos com Multiverse](https://mvplugins.org/core/fundamentals/commands-usage/)
3. Cadastre uma arena com nome próprio. No BedWars, comece com `/bw admin sakura add`, marque os cantos, cadastre equipes, camas, geradores, lojas e os pontos de espera e de espectador, depois execute `/bw admin sakura save`. No Hunger Games, use `/hg create` e `/hg edit` para definir a região e os pontos de início. [Configuração de arena do BedWars](https://docs.screamingsandals.org/BedWars/latest/arena/) · [Configuração do HungerGames](https://github.com/ShaneBeeStudios/HungerGames/wiki)

As seis arenas de **The Bridge** têm mundos e filas separados. A contagem regressiva começa quando a fila está cheia. Para cadastrar outra arena, use `/tb create <arena>` com permissão de administrador. O instalador guarda os arquivos e as estatísticas do plugin anterior em `server-data/legacy-thebridge-1.1.0`. [Guia do The Bridge](https://modrinth.com/plugin/the-bridge)

Para **Build Battle**, importe um mundo com terrenos de construção. Use `/bba setup create <arena>` e `/bba setup edit <arena>` para cadastrar a arena individual, os terrenos e os pontos de espera e retorno. Libere a permissão `buildbattle.join.<arena>` para os jogadores. [Projeto BuildBattle](https://github.com/Plugily-Projects/BuildBattle)

## Versionamento e backup

| Caminho | O que contém | Como guardar |
| --- | --- | --- |
| `configs/` | Configuração inicial do Paper, mundos, arenas e lista de downloads com SHA-256 | Git |
| `lobby/` | Datapack com a praça, as placas e as regras de jogo | Git |
| `maps/` | Mapas-base originais de The Bridge e Build Battle, com as funções usadas para construí-los | Git |
| `setup.ps1`, `start.ps1`, `scripts/` | Instalação, inicialização e encaminhamento UPnP | Git |
| `server-data/` | Instância em uso, com JARs, configurações ativas de plugins, mundos editados, jogadores e logs | Backup separado, com o servidor parado |
| `.downloads/` | Cache dos arquivos baixados pelo instalador | Recriado pelo instalador |

`configs/server.properties` é o modelo inicial. O Paper usa `server-data/server.properties` enquanto roda. O instalador preserva configurações existentes e o Git não leva para outra máquina as mudanças feitas só em `server-data/`, como o modo offline ou arenas criadas no jogo. Para tornar uma mudança padrão em novas instalações, reproduza o ajuste no modelo ou no script correspondente. Para recuperar exatamente a instância em uso, restaure o backup de `server-data/`.

## Créditos

Os mundos e as coordenadas iniciais vêm do pacote comunitário [FragSoc/minecraft-minigames](https://github.com/FragSoc/minecraft-minigames/tree/2bc1878e60ea8bccac655d0815de58d9c18461b2/static_maps), cuja licença está no [repositório original](https://github.com/FragSoc/minecraft-minigames/blob/2bc1878e60ea8bccac655d0815de58d9c18461b2/LICENSE). O projeto baixa os arquivos originais e adapta as configurações de arena durante a instalação.
