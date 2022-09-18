import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projet_flutter_mds/elements/elements.dart';
import 'package:projet_flutter_mds/models/player.dart';
import 'package:projet_flutter_mds/pages/login/join_room.dart';
import 'package:projet_flutter_mds/pages/waiting_room.dart';
import 'package:projet_flutter_mds/providers/provider.dart';
import 'package:projet_flutter_mds/server/ws.dart';
import 'package:provider/provider.dart';
import "../main.dart";

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final TextEditingController usernameController = TextEditingController();
  late CustomWebSocketsState socket;
  late Store store;

  final sockets = [];
  @override
  void initState() {
    store = Provider.of<Store>(context, listen: false);
    socket = store.getSocket();

    sockets.add(socket.listen("savePlayer", (data) {
      Player player = Player.fromJson(data["player"]);
      store.setPlayer(player);
    }));

    sockets.add(socket.listen("ROOM_create", (data) {
      Navigator.pushReplacementNamed(context, '/waitingRoom');
    }));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void errorNickname() {
      store.setUsernameError("Pseudo incorrect");
    }

    bool checkInput(TextEditingController controller) {
      if (controller.text == "") {
        return false;
      }
      return true;
    }

    void createGame() {
      if (checkInput(usernameController)) {
        socket.sendMessage('ROOM_create', {'name': usernameController.text});
      } else {
        errorNickname();
      }
    }

    void joinGame() {
      if (checkInput(usernameController)) {
        store.setTemporaryName(usernameController.text);
        Navigator.pushNamed(context, '/joinRoom');
      } else {
        errorNickname();
      }
    }

    return StylePage(
        title: 'Créer ou rejoindre une partie',
        child: Consumer<Store>(builder: (context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(children: [
                CustomInput(
                    placeholder: "PSEUDO...", controller: usernameController),
                TextError(text: value.usernameError)
              ]),
              Column(
                children: [
                  PrimaryButton(
                      text: "Créer une partie",
                      onPressed: () {
                        createGame();
                      }),
                  Secondarybutton(
                    text: "Rejoindre une partie",
                    onPressed: () => {joinGame()},
                  ),
                ],
              )
            ],
          );
        }));
  }
}
