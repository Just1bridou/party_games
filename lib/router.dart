import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projet_flutter_mds/elements/elements.dart';
import 'package:projet_flutter_mds/providers/provider.dart';
import 'package:projet_flutter_mds/providers/wsstate.dart';
import 'package:provider/provider.dart';

class CustomRouter extends StatefulWidget {
  const CustomRouter({super.key});

  @override
  State<CustomRouter> createState() => _CustomRouterState();
}

class _CustomRouterState extends State<CustomRouter> {
  @override
  Widget build(BuildContext context) {
    Provider.of<Store>(context, listen: false).setNContext(context);

    return Consumer<WSState>(
      builder: (context, value, child) {
        return StylePage(
            routeName: ModalRoute.of(context)!.settings.name!,
            title: title(value.getStatus()),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 80,
                child: router(value.getStatus()),
              ),
            ));
      },
    );
  }

  title(String value) {
    if (value == "connected") {
      return "Connecté";
    } else if (value == "loading") {
      return "Chargement";
    } else {
      return "Erreur";
    }
  }

  router(String value) {
    if (value == "connected") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/menu');
      });
      return const Text("Connecté !");
    } else if (value == "error") {
      return const Text("Impossible de se connecter au serveur");
    } else {
      return const Text("Chargement...");
    }
  }
}
