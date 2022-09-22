import 'package:flutter/material.dart';
import 'package:projet_flutter_mds/elements/elements.dart';
import 'package:projet_flutter_mds/models/player.dart';
import 'package:projet_flutter_mds/providers/provider.dart';
import 'package:projet_flutter_mds/server/ws.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class WaitingRoom extends StatefulWidget {
  const WaitingRoom({Key? key}) : super(key: key);

  @override
  State<WaitingRoom> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom> {
  late CustomWebSocketsState socket;
  List<dynamic> players = <dynamic>[];

  var sockets = [];

  @override
  void initState() {
    Store store = Provider.of<Store>(context, listen: false);
    socket = store.getSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StylePage(
        routeName: ModalRoute.of(context)!.settings.name!,
        title: "En attende de joueurs",
        child: Consumer<Store>(builder: (context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              PrettyText(text: "Code :" + value.getPlayer().code),
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

  Widget buildPlayerList(List<Player> players) {
    return ListView.builder(
      clipBehavior: Clip.none,
      itemCount: players.length,
      itemBuilder: (BuildContext context, int index) {
        return PlayerContainer(player: players[index]);
      },
    );
  }

  void goToGames() {
    Navigator.pushReplacementNamed(context, '/games');
  }
}
