import 'package:flutter/material.dart';
import 'package:projet_flutter_mds/pages/games/games.dart';
import 'package:projet_flutter_mds/pages/games/jokes/main.dart';
import 'package:projet_flutter_mds/pages/waiting_room.dart';
import 'package:projet_flutter_mds/server/provider.dart';
import 'package:projet_flutter_mds/server/ws.dart';
import 'package:projet_flutter_mds/pages/menu.dart';
import 'package:provider/provider.dart';

import 'pages/login/join_room.dart';

//Socket socket = Socket();
WebSockets socket = WebSockets();

void main() {
  socket.init();
  runApp(ChangeNotifierProvider(
    create: (context) => Store(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Party Games',
      routes: {
        '/': (_) => const Menu(),
        '/waitingRoom': (_) => const WaitingRoom(),
        '/joinRoom': (_) => const JoinRoom(),
        '/games': (_) => const Games(),
        '/games/jokes': (_) => const Jokes(),
      },
      // onGenerateRoute: (settings) {
      //   if (settings.name == '/games/jokes') {
      //     final value = settings.arguments as int;
      //     return MaterialPageRoute(
      //         builder: (_) => Jokes()); // Pass it to BarPage.
      //   }
      //   return null;
      // },
    );
  }
}
