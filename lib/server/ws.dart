// ignore_for_file: unnecessary_this, avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:projet_flutter_mds/main.dart';
import 'package:projet_flutter_mds/models/player.dart';
import 'package:projet_flutter_mds/server/provider.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert';

class Config {
  String ip = "10.0.2.2";
  //String ip = "localhost";
  String port = "3001";
}

class WebSockets extends StatefulWidget {
  WebSockets({super.key});

  final _WebSocketsState wsState = new _WebSocketsState();

  @override
  State<WebSockets> createState() => _WebSocketsState();

  void sendMessage(action, data) {
    wsState.sendMessage(action, data);
  }

  void close(payload) {
    wsState.close(payload);
  }

  Payload listen(action, callback) {
    return wsState.listen(action, callback);
  }

  void init() {
    wsState.init();
  }
}

class _WebSocketsState extends State<WebSockets> {
  Config conf = Config();

  late final channel =
      IOWebSocketChannel.connect('ws://${conf.ip}:${conf.port}');

  ObserverList listeners = ObserverList();

  sendMessage(action, data) {
    channel.sink.add(json.encode({'action': action, ...data}));
  }

  Payload listen(action, callback) {
    Payload pl = Payload(action, callback);
    listeners.add(pl);
    return pl;
  }

  close(payload) {
    listeners.remove(payload);
  }

  sendToListeners(data, listeners) {
    var decoded = json.decode(data);

    if (decoded["action"] != null) {
      listeners.forEach((element) {
        if (element.action == decoded["action"]) {
          element.callback(decoded);
        }
      });
    } else {
      print("ws error");
    }
  }

  void webSocketsListeners() {
    listen("refreshPlayersList", (data) {
      // setState(() {
      // convert data["players"] into Player list
      List<Player> playersList = <Player>[];
      for (var player in data["players"]) {
        playersList.add(Player.fromJson(player));
      }
      Provider.of<Store>(context, listen: false).setPlayersList(playersList);
      // });
    });

    listen("START_GAME", (data) {
      print(data);
    });
  }

  void init() {
    channel.stream.listen((data) {
      sendToListeners(data, listeners);
    });

    listen("connect", (data) {
      print("Connected to server");
    });

    webSocketsListeners();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
/*
class Socket {
  Config conf = Config();

  late final channel =
      IOWebSocketChannel.connect('ws://${conf.ip}:${conf.port}');

  ObserverList listeners = ObserverList();

  init() {
    channel.stream.listen((data) {
      sendToListeners(data, listeners);
    });

    listen("connect", (data) {
      print("Connected to server");
    });

    listen("refreshPlayersList", (data) {
      // setState(() {
      // convert data["players"] into Player list
      List<Player> playersList = <Player>[];
      for (var player in data["players"]) {
        playersList.add(Player.fromJson(player));
      }
      Provider.of<Store>(context, listen: false).setPlayersList(playersList);
      // });
    });

    listen("START_GAME", (data) {
      print(data);
    });
  }

  sendMessage(action, data) {
    channel.sink.add(json.encode({'action': action, ...data}));
  }

  listen(action, callback) {
    Payload pl = Payload(action, callback);
    listeners.add(pl);
    return pl;
  }

  close(payload) {
    listeners.remove(payload);
  }

  sendToListeners(data, listeners) {
    var decoded = json.decode(data);

    if (decoded["action"] != null) {
      listeners.forEach((element) {
        if (element.action == decoded["action"]) {
          element.callback(decoded);
        }
      });
    } else {
      print("ws error");
    }
  }
}*/

class Payload {
  final String action;
  final Function callback;

  Payload(this.action, this.callback);
}
