import 'dart:convert';

import 'package:projet_flutter_mds/models/player.dart';

class ExtraPlayer {
  Player player;
  Map<String, dynamic> extra;

  ExtraPlayer(this.player, this.extra);

  Map toJson() {
    return {
      'player': player,
      'extra': jsonEncode(extra),
    };
  }
}
