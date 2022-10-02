import 'package:flutter/material.dart';
import 'package:indexed/indexed.dart';
import 'package:projet_flutter_mds/elements/elements.dart';
import 'package:projet_flutter_mds/models/player.dart';
import 'package:projet_flutter_mds/providers/provider.dart';
import 'package:projet_flutter_mds/server/ws.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
    qrcodeModal(value) {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: PrettyText(
                    color: Colors.white,
                    text: "Code : " + value.getPlayer().code,
                    alignement: Alignment.center,
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(bottom: 30, left: 30, right: 30, top: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          QrImage(data: value.getPlayer().code),
                          PrimaryButton(
                              text: "Retour",
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ],
                      )),
                )
              ],
            );
          });
    }

    return StylePage(
        routeName: ModalRoute.of(context)!.settings.name!,
        //backArrow: true,
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
                      ? Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: ActionButton(
                                  icon: const Icon(
                                    Icons.qr_code_2,
                                    color: Color(0xFF2638DC),
                                  ),
                                  color: Color.fromARGB(255, 228, 228, 228),
                                  onTap: () {
                                    qrcodeModal(value);
                                  }),
                            ),
                            Expanded(
                                child: PrimaryButton(
                                    text: "Suivant",
                                    onPressed: () {
                                      goToGames();
                                    }))
                          ],
                        )
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
