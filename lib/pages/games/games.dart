import 'package:flutter/material.dart';
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
              if (value.getPlayer().admin)
                {
                  socket.sendMessage('START_GAME', {
                    "ROOM_code": value.getPlayer().code,
                    "GAME_code": games[index]["code"]
                  })
                }
            },
          );
        },
      );
    });
  }
}
