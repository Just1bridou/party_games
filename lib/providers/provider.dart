import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:projet_flutter_mds/models/extra_player.dart';
import 'package:projet_flutter_mds/server/ws.dart';
import '../models/player.dart';

class Store with ChangeNotifier {
  Player _player = Player(id: "", name: "", code: "", admin: false, avatar: "");
  String temporaryName = "";
  String usernameError = "";
  String codeError = "";
  List<Player> playersList = [];
  CustomWebSocketsState socket = CustomWebSocketsState();
  BuildContext? nContext;
  ExtraPlayer ePlayer = ExtraPlayer(
      Player(id: "", name: "", code: "", admin: false, avatar: ""), {});

  void setExtraPlayer(ExtraPlayer player) {
    ePlayer = player;
    notifyListeners();
  }

  ExtraPlayer getExtraPlayer() {
    return ePlayer;
  }

  void setNContext(BuildContext nContext) {
    this.nContext = nContext;
  }

  BuildContext getNContext() {
    return nContext!;
  }

  void setSocket(CustomWebSocketsState socket) {
    this.socket = socket;
  }

  CustomWebSocketsState getSocket() {
    return socket;
  }

  void setPlayer(Player player) {
    _player = player;
    notifyListeners();
  }

  Player getPlayer() {
    return _player;
  }

  void setTemporaryName(String name) {
    temporaryName = name;
    notifyListeners();
  }

  String getTemporaryName() {
    return temporaryName;
  }

  void setUsernameError(String text) {
    usernameError = text;
    notifyListeners();
  }

  String getUsernameError() {
    return usernameError;
  }

  void setCodeError(String text) {
    codeError = text;
    notifyListeners();
  }

  String getCodeError() {
    return codeError;
  }

  void setPlayersList(List<Player> players) {
    this.playersList = players;
    notifyListeners();
  }

  List<Player> getPlayersList() {
    return playersList;
  }
}
