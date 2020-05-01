import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:plutopoly/engine/data/map.dart';
import 'package:plutopoly/engine/data/player.dart';
import 'package:plutopoly/engine/kernel/main.dart';

import 'main_bloc.dart';

class UIBloc {
  static int posOveride;

  static double get maxWidth =>
      Hive.box(MainBloc.PREFBOX).get("doubleMaxWidth", defaultValue: 700.0);
  static int get carrouselPosition {
    if (posOveride == null)
      return Game.data.player.position;
    else
      return posOveride;
  }

  static Player get gamePlayer {
    if (!MainBloc.online) return Game.data.player;
    return Game.data.players
            .firstWhere((Player p) => p.code == MainBloc.code) ??
        Game.data.player;
  }

  static MapConfiguration get mapConfiguration {
    MapConfiguration config = Hive.box(MainBloc.MAPCONFBOX).get(
        Hive.box(MainBloc.PREFBOX)
            .get("mapConfiguration", defaultValue: "classic"));

    return config;
  }

  static bool isWide(BuildContext context) {
    return MediaQuery.of(context).size.width >
        MainBloc.prefbox.get("doubleWideWidth", defaultValue: 500);
  }

  static toggleDarkMode() {
    Hive.box(MainBloc.PREFBOX).put("boolDark",
        !Hive.box(MainBloc.PREFBOX).get("boolDark", defaultValue: false));
  }

  static bool get hideOverlays =>
      Hive.box(MainBloc.PREFBOX).get("boolOverlays", defaultValue: true);
}
