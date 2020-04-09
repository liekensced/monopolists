import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../engine/data/main.dart';

class MainBloc {
  static const _version = "1.1.1.2";
  static const GAMESBOX = _version + "gamesbox";
  static const PREFBOX = _version + "prefbox";
  static const METABOX = _version + "metabox";

  static int currentGame = 0;

  static bool isWide(BuildContext context) {
    return MediaQuery.of(context).size.width >
        prefbox.get("doubleWideWidth", defaultValue: 400);
  }

  static Box get prefbox => Hive.box(PREFBOX);

  static initBoc() {
    currentGame = Hive.box(METABOX).get("intCurrentGame");
  }

  static int get getGameNumber {
    return Hive.box(METABOX).get("intTotalGames", defaultValue: 0);
  }

  static toggleDarkMode() {
    Hive.box(MainBloc.PREFBOX).put("boolDark",
        !Hive.box(MainBloc.PREFBOX).get("boolDark", defaultValue: false));
  }

  static GameData newGame() {
    GameData newGameData = GameData();
    Hive.box(METABOX).put("intTotalGames", getGameNumber + 1);
    newGameData.settings.name = "Game $getGameNumber";
    Hive.box(GAMESBOX).add(newGameData);

    Hive.box(METABOX).put("intCurrentGame", getGameNumber);
    return newGameData;
  }

  static ValueListenable<Box<dynamic>> listen() {
    return Hive.box(GAMESBOX).listenable();
  }
}
