import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projet_flutter_mds/elements/elements.dart';
import 'package:projet_flutter_mds/providers/provider.dart';
import 'package:projet_flutter_mds/providers/provider.dart';
import 'package:projet_flutter_mds/server/ws.dart';
import 'package:provider/provider.dart';

class Games extends StatefulWidget {
  const Games({super.key});

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  List<dynamic> games = <dynamic>[
    {"name": "Jokes de papa", "code": "jokes", "minPlayers": 2}
  ];
  late CustomWebSocketsState socket;

  var sockets = [];

  Map<String, dynamic> options = {};

  @override
  void initState() {
    socket = Provider.of<Store>(context, listen: false).getSocket();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StylePage(
        title: "Choix du mini-jeu",
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: buildPlayerList(games),
            ),
            Column(
              children: [Container()],
            )
          ],
        ));
  }

  Widget buildPlayerList(List<dynamic> games) {
    return Consumer<Store>(builder: (context, value, child) {
      return ListView.builder(
        clipBehavior: Clip.none,
        itemCount: games.length,
        itemBuilder: (BuildContext context, int index) {
          return MiniGameContainer(
            payload: MiniGamePayload(
                name: games[index]["name"],
                code: games[index]["code"],
                players: value.getPlayersList().length,
                minPlayers: games[index]["minPlayers"] as int),
            onTap: () => {
              startModal(games[index], value)
              // if (value.getPlayer().admin)
              //   {
              //     socket.sendMessage('START_GAME', {
              //       "ROOM_code": value.getPlayer().code,
              //       "GAME_code": games[index]["code"]
              //     })
              //   }
            },
          );
        },
      );
    });
  }

  startModal(var game, Store value) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            margin: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const PrettyText(text: "Options de jeu"),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: gamesOptions(game),
                    )),
                    PrimaryButton(
                        text: "Jouer",
                        onPressed: () {
                          if (value.getPlayer().admin) {
                            socket.sendMessage('START_GAME', {
                              "ROOM_code": value.getPlayer().code,
                              "GAME_code": game["code"],
                              "GAME_options": options
                            });
                          }
                        }),
                  ],
                )),
          );
        });
  }

  setOption(String key, dynamic value) {
    // setState(() {
    options[key] = value;
    // });
  }

  gamesOptions(var game) {
    print(game);
    bool jokes_mic = true;

    switch (game["code"]) {
      case "jokes":
        setOption("jokes_mic", true);
        setOption("tt", "t");
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrettyText(text: "Microphone ?"),
                    Text('(Detection de la voix)'),
                  ],
                ),
                //PrettyText(text: "[]")
                CustomCheckbox(
                  active: jokes_mic,
                  onTap: () {
                    jokes_mic = !jokes_mic;
                    setOption("jokes_mic", jokes_mic);
                  },
                )
              ],
            ),
          ],
        );
    }

    return const Text(
      "Aucun paramètre",
    );
  }
}
