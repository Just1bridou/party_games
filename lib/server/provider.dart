import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:projet_flutter_mds/main.dart';
import './ws.dart';
import '../models/player.dart';

class Store with ChangeNotifier {
  Player _player = Player(name: "", code: "", admin: false, avatar: "");
  String temporaryName = "";
  String usernameError = "";
  String codeError = "";
  List<Player> playersList = <Player>[];

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
