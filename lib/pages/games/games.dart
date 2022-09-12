import 'package:flutter/material.dart';
import 'package:projet_flutter_mds/main.dart';
import 'package:projet_flutter_mds/server/provider.dart';
import 'package:provider/provider.dart';
import '../../elements/elements.dart';

class Games extends StatefulWidget {
  const Games({super.key});

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  List<dynamic> games = <dynamic>[
    {"name": "Jokes de papa", "code": "jokes"}
  ];

  var sockets = [];

  @override
  void initState() {
    sockets.add(socket.listen("START_GAME", (data) {
      print(data);
    }));
    super.initState();
  }

  @override
  void dispose() {
    for (var payload in sockets) {
      socket.close(payload);
    }
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
                name: games[index]["name"], code: games[index]["code"]),
            onTap: () => {
              socket.sendMessage('START_GAME', {
                "ROOM_code": value.getPlayer().code,
                "GAME_code": games[index]["code"]
              })
            },
          );
        },
      );
    });
  }

  /* void goToGames() {
    Navigator.pushReplacementNamed(context, '/games');
  }*/
}
