import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noise_meter/noise_meter.dart';
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
  Map<String, dynamic> options = {};
  late Store store;
  ExtraPlayer? playerTurn;
  Color microphoneColor = Color.fromARGB(255, 121, 201, 119);
  String loose = "Ne pas rire";

  bool isRecording = false;
  late StreamSubscription<NoiseReading>? noiseSubscription;
  late NoiseMeter noiseMeter;

  void reset() {
    setState(() {
      players = [];
      playerTurn = null;
      microphoneColor = Color.fromARGB(255, 121, 201, 119);
      loose = "Ne pas rire";
    });
  }

  void parsePlayers(var jsonPlayers) {
    for (var player in jsonPlayers) {
      ExtraPlayer ePlayer = ExtraPlayer(Player.fromJson(player),
          {'speaker': player['speaker'], "score": player['score']});

      if (ePlayer.player.id == store.getPlayer().id) {
        store.setExtraPlayer(ePlayer);
      }

      if (ePlayer.extra["speaker"] == true) {
        playerTurn = ePlayer;
      }

      players.add(ePlayer);
    }
  }

  void parseOptions(var myOptions) {
    List<String> keys = myOptions.keys.toList();
    for (var key in keys) {
      options[key] = myOptions[key];
    }
  }

  @override
  void initState() {
    noiseMeter = new NoiseMeter(onError);
    store = Provider.of<Store>(context, listen: false);
    var jsonPlayers = widget.data["players"];
    var options = widget.data["options"];

    parseOptions(options);
    parsePlayers(jsonPlayers);

    store.socket.listen("GAME_action", (data) {
      if (data['game'] != widget.GAME_code) return;
      switch (data["data"]["action"]) {
        case 'newTurn':
          reset();
          parsePlayers(data["data"]["players"]);
          if (!store.getPlayer().equals(playerTurn!.player) &&
              options['jokes_mic'] == true) {
            recordMicrophone();
          }
          break;

        case 'stopTurn':
          stopRecorder();
          loose = "Fin de la manche";
          microphoneColor = Color.fromARGB(255, 196, 196, 196);
          break;
      }
    });

    if (!store.getPlayer().equals(playerTurn!.player) &&
        options['jokes_mic'] == true) {
      recordMicrophone();
    }

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
          routeName: "games",
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
                        leaderBoardModal(players);
                      }),
                ),
              ],
            ),
            value.getPlayer().equals(playerTurn!.player)
                ? FutureBuilder<Joke>(
                    future: server.getRandomJoke(options['jokes_dark']),
                    builder:
                        (BuildContext context, AsyncSnapshot<Joke> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Expanded(
                              child: Center(
                            child:
                                CircularProgressIndicator(color: Colors.black),
                          ));
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
                              switchTurn(
                                  value.getSocket(), value.getPlayer().code);
                            }),
                      )
                    : Container(),
                Expanded(
                    child: CustomContainerText(
                        text: value.getPlayer().equals(playerTurn!.player)
                            ? "A vous de lire"
                            : loose)),
                !value.getPlayer().equals(playerTurn!.player) &&
                        options['jokes_mic'] == true
                    ? Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: ActionButton(
                            icon: const Icon(
                              Icons.mic_rounded,
                              color: Colors.black87,
                            ),
                            color: microphoneColor,
                            onTap: () {}),
                      )
                    : Container(),
              ],
            )
          ]));
    });
  }

  leaderBoardModal(List<ExtraPlayer> players) {
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
                    const PrettyText(text: "Classement"),
                    Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 8),
                            itemCount: players.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                height: 50,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(players[index].player.name),
                                      Text(players[index]
                                              .extra['score']
                                              .toString() ??
                                          "0")
                                    ]),
                              );
                            })),
                    PrimaryButton(
                        text: "Retour",
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                )),
          );
        });
  }

  void recordMicrophone() async {
    try {
      stopRecorder();
      noiseSubscription = noiseMeter.noiseStream.listen(onData);
    } catch (exception) {
      print(exception);
    }
  }

  void onData(NoiseReading noiseReading) {
    setState(() {
      if (!this.isRecording) {
        isRecording = true;
      }
    });

    //print(noiseReading.toString());
    if (noiseReading.meanDecibel > 50) {
      setState(() {
        microphoneColor = Color.fromARGB(255, 231, 63, 63);
        loose = "Perdu !";
      });

      stopRecorder();

      store.getSocket().sendMessage('GAME_ACTION', {
        'ROOM_code': store.getPlayer().code,
        'GAME_code': widget.GAME_code,
        "GAME_action": 'stopTurn',
        'reason': "loose",
        'loose_id': store.getPlayer().id,
        'players': jsonEncode(players)
      });
    }
  }

  void onError(Object error) {
    print(error.toString());
    isRecording = false;
  }

  void stopRecorder() async {
    try {
      if (noiseSubscription != null) {
        noiseSubscription?.cancel();
        noiseSubscription = null;
      }
      setState(() {
        isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
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
