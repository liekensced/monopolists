import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../engine/data/map.dart';
import '../engine/data/player.dart';
import '../engine/kernel/main.dart';
import '../engine/ui/alert.dart';
import 'main_bloc.dart';

class UIBloc {
  static int posOveride;

  static List<Alert> alerts = [];

  static showAlerts(BuildContext context) {
    alerts.forEach((Alert alert) {
      Alert.handle(() => alert, context);
    });
    alerts.clear();
  }

  static double get maxWidth {
    var max =
        Hive.box(MainBloc.PREFBOX).get("doubleMaxWidth", defaultValue: 700.0);
    if (max is double) {
      return max;
    }
    if (max is int) {
      return max.toDouble();
    }
    return 700.0;
  }

  static int get carrouselPosition {
    if (posOveride == null)
      return Game.data.player.position;
    else
      return posOveride;
  }

  static set maxWidth(double maxWidth) =>
      Hive.box(MainBloc.PREFBOX).put("doubleMaxWidth", max(maxWidth, 400.0));

  static Player get gamePlayer {
    if (!MainBloc.online) return Game.data.player;
    return Game.data.players
            .firstWhere((Player p) => p.code == MainBloc.code) ??
        Game.data.player;
  }

  static bool get playing {
    return Game.data.players.firstWhere(
            (Player p) => p.code == MainBloc.code || p.code == -1, orElse: () {
          return null;
        }) !=
        null;
  }

  static MapConfiguration get mapConfiguration {
    MapConfiguration config = Hive.box(MainBloc.MAPCONFBOX).get(
        Hive.box(MainBloc.METABOX)
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

  static bool get darkMode =>
      Hive.box(MainBloc.PREFBOX).get("boolDark", defaultValue: false);

  static bool get hideOverlays =>
      Hive.box(MainBloc.PREFBOX).get("boolOverlays", defaultValue: true);
}
