import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projet_flutter_mds/elements/elements.dart';
import 'package:projet_flutter_mds/models/player.dart';
import 'package:projet_flutter_mds/providers/provider.dart';
import 'package:projet_flutter_mds/server/ws.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import "../../main.dart";

class JoinRoom extends StatefulWidget {
  const JoinRoom({super.key});

  @override
  State<JoinRoom> createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  final TextEditingController codeController = TextEditingController();
  late Store store;
  late CustomWebSocketsState socket;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool qrCodeDetected = false;

  @override
  void initState() {
    store = Provider.of<Store>(context, listen: false);
    socket = store.getSocket();

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
    void detectQrCode(QRViewController controller) {
      this.controller = controller;
      controller.scannedDataStream.listen((scanData) {
        //print(scanData);
        if (!qrCodeDetected && scanData.code != null) {
          setState(() {
            qrCodeDetected = true;
            codeController.text = scanData.code!;
            joinRoom();
            Navigator.pop(context);
          });
        }
      });
    }

    openScanModal() {
      setState(() {
        qrCodeDetected = false;
      });

      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return Container(
              margin: EdgeInsets.only(bottom: 30, left: 30, right: 30, top: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: QRView(
                          key: qrKey,
                          onQRViewCreated: detectQrCode,
                        ),
                      ),
                      PrimaryButton(
                          text: "Retour",
                          onPressed: () => Navigator.pop(context)),
                    ],
                  )),
            );
          });
    }

    return StylePage(
        routeName: ModalRoute.of(context)!.settings.name!,
        backArrow: true,
        title: 'Rejoindre une partie',
        child: Consumer<Store>(builder: (context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(children: [
                Row(children: [
                  Expanded(
                      child: CustomInput(
                          placeholder: "CODE...", controller: codeController)),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: ActionButton(
                        icon: const Icon(
                          Icons.qr_code_scanner_rounded,
                          color: Color(0xFFEFF0FF),
                        ),
                        color: const Color(0xFF2638DC),
                        onTap: () {
                          print("qr scan");
                          openScanModal();
                        }),
                  )
                ]),
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
