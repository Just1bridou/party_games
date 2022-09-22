// ignore_for_file: unnecessary_this, avoid_print, library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:projet_flutter_mds/main.dart';
import 'package:projet_flutter_mds/models/player.dart';
import 'package:projet_flutter_mds/providers/provider.dart';
import 'package:projet_flutter_mds/providers/wsstate.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert';

class Config {
  // For emulator
  // String ip = "10.0.2.2";
  // For localhost
  // String ip = "192.168.1.25";
  //String ip = "172.24.232.115";
  // String port = "3001";
  String ip = "51.210.104.99";
  String port = "2122";
}

class CustomWebSockets extends StatefulWidget {
  const CustomWebSockets({super.key, required this.child});
  final Widget child;

  @override
  State<CustomWebSockets> createState() => CustomWebSocketsState();
}

class CustomWebSocketsState extends State<CustomWebSockets> {
  Config conf = Config();

  late final IOWebSocketChannel channel;

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
      List<Player> playersList = [];
      for (var player in data["players"]) {
        playersList.add(Player.fromJson(player));
      }
      Provider.of<Store>(context, listen: false).setPlayersList(playersList);
    });

    listen("START_GAME", (data) {
      navigatorKey.currentState!.pushReplacementNamed('/games/' + data["game"],
          arguments: data["data"]);
    });
  }

  @override
  void dispose() {
    print("WS Dispose");
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    connect();
  }

  connect() async {
    Provider.of<Store>(context, listen: false).setSocket(this);
    try {
      await WebSocket.connect('ws://${conf.ip}:${conf.port}')
          .timeout(const Duration(seconds: 2))
          .then((ws) {
        try {
          channel = IOWebSocketChannel(ws);

          channel.stream.listen((data) {
            sendToListeners(data, listeners);
          });

          listen("connect", (data) {
            print("WS Connected to server");
          });

          webSocketsListeners();

          Provider.of<WSState>(context, listen: false).setStatus("connected");
        } catch (e) {
          Provider.of<WSState>(context, listen: false).setStatus("error");
          print('WS connection error : ${e.toString()}');
        }
      });
    } catch (e) {
      Provider.of<WSState>(context, listen: false).setStatus("error");
      print('WS connection error : ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class Payload {
  final String action;
  final Function callback;

  Payload(this.action, this.callback);
}
