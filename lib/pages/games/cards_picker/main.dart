import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projet_flutter_mds/elements/elements.dart';
import 'package:projet_flutter_mds/models/joke.dart';
import 'package:projet_flutter_mds/pages/games/cards_picker/cards_picker_server.dart';
import 'package:projet_flutter_mds/providers/provider.dart';
import 'package:projet_flutter_mds/server/ws.dart';
import 'package:provider/provider.dart';

CardsPickerServer server = CardsPickerServer();

class CardsPicker extends StatefulWidget {
  CardsPicker({super.key, required this.data});
  final data;

  String GAME_code = "cards_picker";

  @override
  State<CardsPicker> createState() => _JokesState();
}

class _JokesState extends State<CardsPicker> {
  Config conf = Config();
  late Store store;
  late String actualCardID;

  @override
  void initState() {
    store = Provider.of<Store>(context, listen: false);
    actualCardID = "back";

    store.socket.listen("GAME_action", (data) {
      if (data['game'] != widget.GAME_code) return;
      switch (data["data"]["action"]) {
        case 'draw':
          setState(() {
            actualCardID = data["data"]["card"]["id"];
          });
          break;
      }
    });
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
          title: "Cartes",
          child: Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                  child: GestureDetector(
                onTap: () => {drawCard()},
                child: Image.network(
                    "http://${conf.expressIP}:${conf.expressPort}/cards/" +
                        actualCardID),
              )),
            ),
          ));
    });
  }

  drawCard() {
    store.getSocket().sendMessage('GAME_ACTION', {
      'ROOM_code': store.getPlayer().code,
      'GAME_code': widget.GAME_code,
      "GAME_action": 'draw',
    });
  }
}
