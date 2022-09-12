import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projet_flutter_mds/elements/elements.dart';
import 'package:projet_flutter_mds/models/player.dart';
import 'package:projet_flutter_mds/server/provider.dart';
import 'package:provider/provider.dart';
import "../../main.dart";

class JoinRoom extends StatefulWidget {
  const JoinRoom({super.key});

  @override
  State<JoinRoom> createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  final TextEditingController codeController = TextEditingController();

  @override
  void initState() {
    socket.listen("savePlayer", (data) {
      Player player = Player.fromJson(data["player"]);

      Provider.of<Store>(context, listen: false).setPlayer(player);
    });

    socket.listen("ROOM_join", (data) {
      Navigator.pushNamed(context, '/waitingRoom');
    });
    super.initState();
  }

  void errorNickname() {
    Provider.of<Store>(context, listen: false).setCodeError("Code incorrect");
  }

  bool checkInput(TextEditingController controller) {
    if (controller.text == "") {
      return false;
    }
    return true;
  }

  void joinRoom() {
    if (checkInput(codeController)) {
      String temporaryName =
          Provider.of<Store>(context, listen: false).getTemporaryName();

      socket.sendMessage(
          'ROOM_join', {'name': temporaryName, "code": codeController.text});
    } else {
      errorNickname();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StylePage(
        backArrow: true,
        title: 'Rejoindre une partie',
        child: Consumer<Store>(builder: (context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(children: [
                CustomInput(placeholder: "CODE...", controller: codeController),
                TextError(text: value.codeError)
              ]),
              Column(
                children: [
                  PrimaryButton(
                      text: "Rejoindre une partie",
                      onPressed: () {
                        joinRoom();
                      }),
                  Secondarybutton(
                    text: "Annuler",
                    onPressed: () => {
                      Navigator.pushReplacementNamed(context, '/waitingRoom')
                    },
                  ),
                ],
              )
            ],
          );
        }));
  }
}
