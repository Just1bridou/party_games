import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:projet_flutter_mds/pages/games/cards_picker/main.dart';
import 'package:projet_flutter_mds/pages/games/games.dart';
import 'package:projet_flutter_mds/pages/games/jokes/main.dart';
import 'package:projet_flutter_mds/pages/waiting_room.dart';
import 'package:projet_flutter_mds/providers/wsstate.dart';
import 'package:projet_flutter_mds/router.dart';
import 'package:projet_flutter_mds/providers/provider.dart';
import 'package:projet_flutter_mds/server/ws.dart';
import 'package:projet_flutter_mds/pages/menu.dart';
import 'package:provider/provider.dart';

import 'pages/login/join_room.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    ChangeNotifierProvider(
      create: (context) => Store(),
      child: ChangeNotifierProvider(
          create: (context) => WSState(), child: const MyApp()),
    ),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Party Games',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (_) => const CustomRouter(),
        '/menu': (_) => const Menu(),
        '/waitingRoom': (_) => const WaitingRoom(),
        '/joinRoom': (_) => const JoinRoom(),
        '/games': (_) => const Games(),
        //  '/games/jokes': (_) => const Jokes(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/games/jokes') {
          final args = settings.arguments;
          return MaterialPageRoute(
              builder: (_) => Jokes(
                    data: args,
                  ));
        }
        if (settings.name == '/games/cards_picker') {
          final args = settings.arguments;
          return MaterialPageRoute(
              builder: (_) => CardsPicker(
                    data: args,
                  ));
        }
        return null;
      },
      builder: (context, child) => CustomWebSockets(child: child!),
    );
  }
}
