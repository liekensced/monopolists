import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:plutopoly/engine/data/ui_actions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../engine/data/map.dart';
import '../engine/data/player.dart';
import '../engine/kernel/main.dart';
import '../engine/ui/alert.dart';
import 'main_bloc.dart';

class UIBloc {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static ValueNotifier screenUpdate = ValueNotifier<Screen>(Screen.idle);

  static List<Alert> alerts = [];

  static resetColors() {
    MainBloc.prefbox.delete("primaryColor");
    MainBloc.prefbox.delete("accentColor");
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.teal));
  }

  static changeScreen([Screen screen]) {
    if (screen != null) Game.data.ui.screenState = screen;
    screenUpdate.value = screen;
  }

  static launchUrl(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Couldn't open url"),
              content: Text(url),
              actions: [
                MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "close",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ))
              ]);
        },
      );
    }
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
    return Game.data.player.position;
  }

  static set maxWidth(double maxWidth) =>
      Hive.box(MainBloc.PREFBOX).put("doubleMaxWidth", max(maxWidth, 400.0));

  static Player get gamePlayer {
    if (!MainBloc.online) return Game.data?.nextRealPlayer;
    try {
      return Game.data.players
          .firstWhere((Player p) => p.code == MainBloc.code);
    } catch (e) {
      return Game.data.player;
    }
  }

  static double scrollOffset = 0;

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
