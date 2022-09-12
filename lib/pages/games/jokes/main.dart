import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projet_flutter_mds/elements/elements.dart';

class Jokes extends StatefulWidget {
  const Jokes({super.key});

  @override
  State<Jokes> createState() => _JokesState();
}

class _JokesState extends State<Jokes> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StylePage(title: "Jokes", child: Column(children: []));
  }
}
