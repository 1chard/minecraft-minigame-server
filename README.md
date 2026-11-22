# Minecraft Minigames no Windows

Servidor local de **Minecraft Java Edition 1.21.11** com Paper build 132. O PowerShell instala os plugins e os mapas existentes e inicia o Paper diretamente com o Java do Windows.

| Modo | Plugin | Arenas instaladas |
| --- | --- | --- |
| BedWars | ScreamingBedWars 0.2.44 | `ilhas` |
| Hunger Games | HungerGames 5.1.1 | `first`, `second`, `third` |
| The Bridge | TheBridge 1.1.0 | `ponte` (1v1, cinco gols) |
| Build Battle | BuildBattle 5.1.8 | `construcao` (Ateliê, dois a quatro jogadores) |

O Multiverse-Core 5.8.2 carrega os mundos `bedwars`, `hungergames`, `ponte` e `construcao`. As três arenas de Hunger Games ocupam regiões distintas do mesmo mundo. Os jogadores entram na praça `lobby` e escolhem uma arena pelas placas ou pelos comandos abaixo. As arenas iniciais foram ajustadas para começar com pelo menos dois jogadores.

O PvP está desligado na praça. BedWars, Hunger Games e The Bridge usam dificuldade Normal e têm a regeneração natural de vida desligada. Os itens e efeitos de cura continuam funcionando conforme as regras de cada minijogo.

## Instalação e início

Use Java 21 ou superior no `PATH` e execute os comandos abaixo em um PowerShell aberto na pasta do projeto. A primeira instalação e o primeiro início precisam de internet. Se precisar instalar o Java, use o instalador Windows do [Eclipse Temurin 21](https://adoptium.net/temurin/releases/?version=21&os=windows).

Leia a [EULA do Minecraft](https://www.minecraft.net/pt-br/eula). Execute a primeira linha se aceitar os termos.

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\setup.ps1 -AcceptEula
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\start.ps1
```

Na próxima vez, basta executar a segunda linha. O limite padrão de memória do Java é 4 GB. Para usar 2 GB, acrescente `-MemoryGB 2` ao comando de início. Para encerrar e salvar os mundos, digite `stop` no console do Paper.

Em uma instalação que veio de uma versão anterior do projeto, pare o servidor e execute `setup.ps1` novamente para instalar os mapas novos e registrar as arenas. O lobby aplica as placas novas na próxima inicialização.

## Modo offline

Instalações novas usam autenticação do Minecraft por padrão. Para instalar em modo offline, acrescente `-Offline` à linha de instalação. Para ativá-lo em uma instalação existente, pare o servidor com `stop` e execute:

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

Na primeira inicialização com o datapack, o servidor monta uma praça elevada no mundo `lobby` e define o ponto de entrada acima do piso. Quem reconectar no spawn antigo ou cair na antiga sala de espera do Hunger Games é levado à praça. Na entrada ficam **BedWars — Ilhas** e **Sair da fila do Hunger Games**. As placas de **The Bridge** ficam à esquerda, as de **Build Battle** à direita e as três arenas de Hunger Games ao fundo. Use o botão direito na frente da placa desejada ou digite o comando no chat.

| No chat do jogo | Ação |
| --- | --- |
| `/bw join ilhas` | Entrar no BedWars |
| `/bw leave` | Sair do BedWars |
| `/hg listgames` | Listar as arenas de Hunger Games |
| `/hg join first` | Entrar em `first`. Use também `second` ou `third`. |
| `/hg leave` | Sair da fila ou da partida de Hunger Games |
| `/thebridge join ponte` | Entrar na Ponte 1v1 |
| `/thebridge leave` | Sair da fila ou da partida de The Bridge |
| `/buildbattle join construcao` | Entrar no Ateliê para construir no criativo e votar |
| `/buildbattle leave` | Sair da fila ou da partida de Build Battle |

Para conferir o carregamento, veja `server-data/logs/latest.log`. Para testar uma partida, entre na mesma arena com duas contas Java e confira o início, o fim e a restauração do mapa ao jogar de novo. [Comandos do BedWars](https://docs.screamingsandals.org/BedWars/latest/commands/) · [Comandos do HungerGames](https://github.com/ShaneBeeStudios/HungerGames/wiki/Commands-Permissions)

## Jogar em rede local

Pare o servidor, esvazie o valor de `server-ip` em `server-data/server.properties` e mude `white-list` para `true`. Após reiniciar, use `whitelist add NomeDoJogador` no console para cada conta, incluindo a sua. Os amigos entram usando o IPv4 do PC que hospeda o servidor, exibido por `ipconfig`, seguido de `:25565`. Se o Windows solicitar acesso para o Java, use o perfil de rede privada.

## Adicionar outros mapas

1. Pare o servidor e copie a pasta de um mundo Java compatível para `server-data/<nome_do_mundo>`. Ela deve conter `level.dat` e `region/` diretamente na raiz. Dê um nome único ao mundo, por exemplo `bw_sakura`.
2. Inicie o servidor e use `op SeuNick` no console para administrar pelo Minecraft. No jogo, use `/mv import bw_sakura normal` e `/mv tp bw_sakura`. [Importar mundos com Multiverse](https://mvplugins.org/core/fundamentals/commands-usage/)
3. Cadastre uma arena com nome próprio. No BedWars, comece com `/bw admin sakura add`, marque os cantos, cadastre equipes, camas, geradores, lojas e os pontos de espera e de espectador, depois execute `/bw admin sakura save`. No Hunger Games, use `/hg create` e `/hg edit` para definir a região e os pontos de início. [Configuração de arena do BedWars](https://docs.screamingsandals.org/BedWars/latest/arena/) · [Configuração do HungerGames](https://github.com/ShaneBeeStudios/HungerGames/wiki)

Para **The Bridge**, importe um mundo com uma ponte e duas bases. Com permissão de administrador, execute `/thebridge create <arena>` dentro desse mundo e use `/thebridge setup <arena>` para marcar a área, os gols, as posições iniciais e a sala de espera. Configure um jogador por equipe para 1v1 e valide com `/thebridge enable <arena>`. [Guia de arena de TheBridge](https://github.com/Kylan1940/TheBridge#arena-setup-example)

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
