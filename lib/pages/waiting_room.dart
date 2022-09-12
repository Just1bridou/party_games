import 'package:flutter/material.dart';
import 'package:projet_flutter_mds/elements/elements.dart';
import 'package:projet_flutter_mds/models/player.dart';
import 'package:projet_flutter_mds/server/provider.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class WaitingRoom extends StatefulWidget {
  const WaitingRoom({Key? key}) : super(key: key);

  @override
  State<WaitingRoom> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom> {
  List<dynamic> players = <dynamic>[];

  var sockets = [];

  void refreshPlayersList(String code) {
    socket.sendMessage('refreshPlayersList', {"code": code});
  }

  @override
  Widget build(BuildContext context) {
    Player player = Provider.of<Store>(context).getPlayer();

    refreshPlayersList(player.code);

    return StylePage(
        title: "En attende de joueurs",
        child: Consumer<Store>(builder: (context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: buildPlayerList(value.getPlayersList()),
              ),
              Column(
                children: [
                  value.getPlayer().admin
                      ? PrimaryButton(
                          text: "Suivant",
                          onPressed: () {
                            goToGames();
                          })
                      : Container()
                ],
              )
            ],
          );
        }));
  }

  Widget buildPlayerList(List<dynamic> players) {
    return ListView.builder(
      clipBehavior: Clip.none,
      itemCount: players.length,
      itemBuilder: (BuildContext context, int index) {
        return PlayerContainer(player: Player.fromJson(players[index]));
      },
    );
  }

  void goToGames() {
    Navigator.pushReplacementNamed(context, '/games');
  }
}
