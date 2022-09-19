import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet_flutter_mds/elements/elements.dart';
import 'package:projet_flutter_mds/models/extra_player.dart';
import 'package:projet_flutter_mds/models/joke.dart';
import 'package:projet_flutter_mds/models/player.dart';
import 'package:projet_flutter_mds/pages/games/jokes/jokes_server.dart';
import 'package:projet_flutter_mds/providers/provider.dart';
import 'package:projet_flutter_mds/server/ws.dart';
import 'package:provider/provider.dart';

JokesServer server = JokesServer();

class Jokes extends StatefulWidget {
  Jokes({super.key, required this.data});
  final data;

  String GAME_code = "jokes";

  @override
  State<Jokes> createState() => _JokesState();
}

class _JokesState extends State<Jokes> {
  List<ExtraPlayer> players = [];
  late Store store;
  ExtraPlayer? playerTurn;

  @override
  void initState() {
    store = Provider.of<Store>(context, listen: false);
    var jsonPlayers = widget.data["players"];

    for (var player in jsonPlayers) {
      ExtraPlayer ePlayer =
          ExtraPlayer(Player.fromJson(player), {'speaker': player['speaker']});

      if (ePlayer.player.id == store.getPlayer().id) {
        //ePlayer.extra["isMe"] = true;
        store.setExtraPlayer(ePlayer);
      }

      if (ePlayer.extra["speaker"] == true) {
        playerTurn = ePlayer;
      }

      players.add(ePlayer);
    }

    // jsonPlayers.map((e) {
    //   print(e);
    //   Player p = Player.fromJson(e);
    //   print(p);
    //   //ExtraPlayer(Player.fromJson(e), [e["speaker"]]);
    // });
    //print(widget.data);
    print(players);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Store>(builder: (context, value, child) {
      return StylePage(
          title: "Jokes de papa",
          child: Column(children: [
            Row(
              children: [
                Expanded(
                    child: CustomContainerText(
                        text: "Au tour de " + playerTurn!.player.name)),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ActionButton(
                      icon: const Icon(
                        Icons.leaderboard,
                        color: Color(0xFFEFF0FF),
                      ),
                      color: const Color(0xFF2638DC),
                      onTap: () {
                        switchTurn(value.getSocket(), value.getPlayer().code);
                      }),
                ),
              ],
            ),
            value.getPlayer().equals(playerTurn!.player)
                ? FutureBuilder<Joke>(
                    future: server.getRandomJoke(),
                    builder:
                        (BuildContext context, AsyncSnapshot<Joke> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                            child:
                                CircularProgressIndicator(color: Colors.black),
                          );
                        default:
                          if (snapshot.hasError && snapshot.data != null) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return builderJokes(snapshot);
                          }
                      }
                    },
                  )
                : Expanded(child: Container()),
            Row(
              children: [
                value.getPlayer().equals(playerTurn!.player)
                    ? Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: ActionButton(
                            icon: const Icon(
                              Icons.check,
                              color: Color(0xFFEFF0FF),
                            ),
                            color: const Color(0xFF2638DC),
                            onTap: () {
                              print("Joueur suivant");
                            }),
                      )
                    : Container(),
                const Expanded(child: CustomContainerText(text: "A vous")),
                !value.getPlayer().equals(playerTurn!.player)
                    ? Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: ActionButton(
                            icon: const Icon(
                              Icons.mic_rounded,
                              color: Colors.black87,
                            ),
                            color: Color(0xFFBFBFBF),
                            onTap: () {
                              print("pas spécialement un bouton lui");
                            }),
                      )
                    : Container(),
              ],
            )
          ]));
    });
  }

  switchTurn(CustomWebSocketsState socket, String code) {
    socket.sendMessage('GAME_ACTION', {
      'ROOM_code': code,
      'GAME_code': widget.GAME_code,
      "GAME_action": 'switch'
    });
  }

  builderJokes(AsyncSnapshot<Joke> snapshot) {
    Joke joke = snapshot.data!;
    return Expanded(
        child: Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: CustomContainer(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFF8C26DC),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(joke.type.toUpperCase(),
                              style: GoogleFonts.robotoCondensed(
                                  textStyle:
                                      const TextStyle(color: Color(0xFFEFF0FF)),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.0)),
                        )),
                  ),
                ),
                PrettyText(text: joke.joke)
              ]),
              PrettyText(text: joke.answer)
            ]),
      ),
    ));
  }
}
