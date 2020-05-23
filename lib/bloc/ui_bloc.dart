import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:plutopoly/engine/data/ui_actions.dart';

import '../engine/data/map.dart';
import '../engine/data/player.dart';
import '../engine/kernel/main.dart';
import '../engine/ui/alert.dart';
import 'main_bloc.dart';

class UIBloc {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static int posOveride;

  static ValueNotifier screenUpdate = ValueNotifier<Screen>(Screen.idle);

  static List<Alert> alerts = [];

  static changeScreen([Screen screen]) {
    if (screen != null) Game.data.ui.screenState = screen;
    screenUpdate.value = screen;
  }

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
    try {
      return Game.data.players
          .firstWhere((Player p) => p.code == MainBloc.code);
    } catch (e) {
      return Game.data.player;
    }
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
            .get("mapConfiguration", defaultValue: "dense"));

    return config;
  }

  static bool isWide(BuildContext context) {
    return MediaQuery.of(context).size.width >
        MainBloc.prefbox.get("doubleWideWidth", defaultValue: 500);
  }

  static toggleDarkMode() {
    Hive.box(MainBloc.PREFBOX).put("boolDark",
        !Hive.box(MainBloc.PREFBOX).get("boolDark", defaultValue: true));
  }

  static bool get darkMode =>
      Hive.box(MainBloc.PREFBOX).get("boolDark", defaultValue: true);

  static bool get hideOverlays =>
      Hive.box(MainBloc.PREFBOX).get("boolOverlays", defaultValue: true);
}
