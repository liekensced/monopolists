import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../engine/data/main_data.dart';
import '../engine/data/map.dart';
import '../engine/data/player.dart';
import '../engine/data/ui_actions.dart';
import '../engine/kernel/main.dart';
import '../engine/ui/alert.dart';
import '../engine/ui/game_navigator.dart';
import '../helpers/online_extensions.dart';
import '../helpers/progress_helper.dart';
import '../helpers/route_helper.dart';
import '../screens/store/currencies_data.dart';
import '../screens/store/game_icons_data.dart';
import '../store/preset.dart';
import 'dailyBloc.dart';
import 'preset_bloc.dart';
import 'recent_bloc.dart';
import 'ui_bloc.dart';

class MainBloc {
  static const version = "0.8.1";
  static const List<int> supported = [5, 6, 7];
  static const website = "https://filorux.web.app/Plutopoly.html";
  static List<int> get versionCode =>
      version.split(".").map<int>((e) => int.tryParse(e)).toList();
  static const _boxVersion = "1.1.2.8";
  static const GAMESBOX = _boxVersion + "gamesbox4";

  static const PREFBOX = _boxVersion + "prefbox";
  static const METABOX = _boxVersion + "metabox";
  static const UPDATEBOX = _boxVersion + "updateBox";
  static const MAPCONFBOX = _boxVersion + "mapconfBox";
  static const ACCOUNTBOX = _boxVersion + "accountBox";
  static const RECENTBOX = _boxVersion + "recentBox";
  static const MOVEBOX = _boxVersion + "moveBox";
  static const PRESETSBOX = _boxVersion + "presetsBox";
  static const STATBOX = "statBox";
  static Box<Preset> get presetsBox => Hive.box<Preset>(PRESETSBOX);
  static const PRESETGAMESBOX = _boxVersion + "presetGamesBox";
  static Box<GameData> get presetGamesBox => Hive.box<GameData>(PRESETGAMESBOX);

  static bool studio = false;
  static bool initialized = false;
  static int currentGame = 0;
  static bool online = false;
  static String gameId;
  static StreamSubscription<DocumentSnapshot> listener;
  static StreamSubscription<DocumentSnapshot> waiter;

  static bool dealOpen = false;

  static bool get isPro => false;

  static Box get metaBox {
    return Hive.box(METABOX);
  }

  static Future newOnlineGame([GameData preset]) async {
    MainBloc.studio = false;
    if (player.name == null || player.name == "null")
      return Alert.accountIncomplete();
    online = true;
    Hive.box(METABOX).put("boolOnline", true);
    Game.data = null;
    DocumentReference data =
        await Firestore.instance.collection("/games").add({"starting ...": ""});
    gameId = data.documentID;
    Game.newGame(preset);
    Game.data.settings.name = "Game $getGameNumber";

    waiter = data.snapshots().listen((event) {
      if (event.exists) {
        Game.save();
        joinOnline(data.documentID);
      }
    });
  }

  static int get code {
    int code = Hive.box(ACCOUNTBOX).get("intCode");
    if (code == null) {
      code = Random().nextInt(4294967000);
      Hive.box(ACCOUNTBOX).put("intCode", code);
    }
    return code;
  }

  static Alert setCode(String code) {
    int newCode = int.tryParse(code);
    if (newCode == null)
      return Alert("Couldn't parse code", "Please enter a normal integer");
    Box _accountBox = Hive.box(ACCOUNTBOX);
    _accountBox.put("intCode", newCode);
    _accountBox.put(
        "playerPlayer", _accountBox.get("playerPlayer")..code = newCode);
    return Alert(
        "Changed succesfully", "Your auth code has been changed succesfully.",
        failed: false);
  }

  static bool get isListening {
    if (listener != null) return !listener.isPaused;
    return false;
  }

  static Player get player => Hive.box(ACCOUNTBOX).get("playerPlayer",
      defaultValue:
          Player(name: "null", color: Colors.amber.value, code: code));

  static setPlayer({String name: "", int color: 0}) {
    Hive.box(ACCOUNTBOX)
        .put("playerPlayer", Player(color: color, name: name, code: code));
  }

  static Future<Alert> joinOnline(String gameIdInput,
      [bool force = false]) async {
    MainBloc.studio = false;
    if (player.name == null || player.name == "null")
      return Alert.accountIncomplete();

    online = true;

    Alert alert;
    gameId = gameIdInput.trim();
    DocumentSnapshot snapshot;
    DocumentReference ref;
    if (waiter != null) waiter.cancel();

    bool preJoined = false;

    try {
      ref = Firestore.instance.document("/games/$gameId");
      snapshot = await ref.get();
      if (snapshot == null || !snapshot.exists) {
        await cancelOnline();
        return Alert("Game key does not exist",
            "We couldn't find a game with id:$gameIdInput\n Check key or create a new game");
      }
      List players = snapshot.data["players"];
      List lostPlayers = snapshot.data["lostPlayers"];
      String joinVersion = snapshot.data["version"] ?? "0.0.0";
      List<int> joinVersionCode =
          joinVersion.split(".").map<int>((e) => int.tryParse(e)).toList();
      if (!force) {
        if (joinVersionCode.length >= 2 && versionCode[0] != null) {
          if (joinVersionCode[0] != versionCode[0] ||
              joinVersionCode[1] != versionCode[1]) {
            await cancelOnline();
            if (supported.contains(joinVersionCode[1])) {
              return Alert("Upgrade game?",
                  "The versions are not the same:\nYour version: $version\nGame version: $joinVersion\nDo you want to upgrade the version?",
                  actions: {
                    "yes": (BuildContext context) async {
                      Navigator.pop(context);
                      Alert alert =
                          await MainBloc.joinOnline(gameIdInput, true);
                      if (Alert.handle(() => alert, context)) {
                        GameNavigator.navigate(context, loadGame: true);
                      }
                    }
                  });
            }
            return Alert("Versions not correct",
                "The versions are not the same:\nYour version: $version\nGame version: $joinVersion");
          }
        }
      }

      if (players != null) {
        players.forEach((iplayer) {
          if (iplayer["code"] == player.code) {
            preJoined = true;
            return;
          }
          if (iplayer["name"] == player.name) {
            alert = Alert("Name already taken",
                "${player.name} is already taken. Please change your name and try again");
            return;
          }
        });
      }
      if (lostPlayers != null) {
        lostPlayers.forEach((iplayer) {
          if (iplayer["code"] == player.code) {
            preJoined = true;
            return;
          }
        });
      }
    } catch (e) {
      await cancelOnline();
      return Alert("Error while opening connection", e.toString());
    }
    if (alert != null) {
      await cancelOnline();
      return alert;
    }

    try {
      GameData data = GameData.fromJson(snapshot.data);
      Game.loadGame(data);
      listener = ref.snapshots().listen(update);
      if (!preJoined) {
        Game.setup.addPlayer(
          name: player.name,
          color: player.color,
          code: code,
          icon: GameIconHelper.selectedGameIcon.id,
        );
      }
      Game.checkBot();
    } catch (e) {
      await cancelOnline();
      return Alert("Error while joining game", e.toString());
    }
    Hive.box(METABOX).put("boolOnline", true);
    RecentBloc.update(Game.data);
    if (force) Game.save();
    return null;
  }

  static cancelOnline() async {
    online = false;
    gameId = null;
    studio = false;
    PresetBloc.preset = null;
    if (listener != null) await listener.cancel();
    Hive.box(METABOX).put("boolOnline", false);
    print("===CANCELED===");
  }

  static update(DocumentSnapshot snap) {
    Screen lastScreen = Game.data.ui.screenState;
    Game.data = GameData.fromJson(snap.data);
    if (lastScreen != Game.data.ui.screenState) {
      UIBloc.changeScreen();
    }
    OnlineExtensions.setData(snap.data);
    print("== Received Data ==");
    Hive.box(UPDATEBOX).put("update", 0);
  }

  static save(GameData data,
      {Map<String, dynamic> bots,
      List<String> only,
      List<String> exclude,
      bool local: false}) {
    if (!online) {
      print("== New Local Save ==");
      if (data.isInBox)
        data.save();
      else
        print("not in box!");
    } else {
      print("== New Online Save ==");
      RecentBloc.update(data);
      if (data != null && !local) {
        data.bot = false;
        Map<String, dynamic> json = data.toJson();
        Map<String, dynamic> saveJson = {};
        if (bots != null) {
          json["bots"] = bots;
        }

        if (only == null) {
          saveJson = json;
        } else {
          only.forEach((String key) {
            List<String> str = key.split(".");
            if (json.containsKey(str.last)) {
              saveJson[str.last] = json[str.last];
            }
          });
        }
        if (exclude != null) {
          exclude.forEach((String key) {
            List<String> str = key.split(".");
            saveJson.remove(str.last);
          });
        }
        if (saveJson.isNotEmpty) {
          saveJson["updatedOn"] = DateTime.now().toString();
          saveJson["version"] = MainBloc.version;
          Firestore.instance.document("/games/$gameId").updateData(saveJson);
        }
      }
      updateUI();
    }
  }

  static updateUI() {
    Hive.box(UPDATEBOX).put("update", 0);
  }

  static Box get prefbox => Hive.box(PREFBOX);

  static initBloc(BuildContext context) {
    if (initialized) return;
    initialized = true;
    code;
    DailyBloc.checkNewDay();

    ProgressHelper.init();

    currentGame = Hive.box(METABOX).get("intCurrentGame");
    if (Hive.box(MAPCONFBOX).isEmpty) {
      Hive.box(MAPCONFBOX).put("classic", MapConfiguration.standard());
      Hive.box(MAPCONFBOX).put("dense", MapConfiguration.dense());
    }
    if (!Hive.box(MAPCONFBOX).containsKey("wide")) {
      Hive.box(MAPCONFBOX).put("wide", MapConfiguration.wide());
    }
    if (!Hive.box(MAPCONFBOX).containsKey("extra wide")) {
      Hive.box(MAPCONFBOX).put("extra wide", MapConfiguration.extraWide());
    }
    if (!Hive.box(MAPCONFBOX).containsKey("tween")) {
      Hive.box(MAPCONFBOX).put("tween", MapConfiguration.tween());
    }
    if (Hive.box(MainBloc.METABOX).get("mapConfiguration") == null) {
      Hive.box(MainBloc.METABOX)
          .put("mapConfiguration", UIBloc.isWide(context) ? "wide" : "dense");
    }

    RecentBloc.checkRecent();
    RouteHelper.initUniLinks();
  }

  static int get getGameNumber {
    return Hive.box(METABOX).get("intTotalGames", defaultValue: 0);
  }

  static resetGame([GameData data]) {
    GameData newData = data ?? GameData();
    if (!MainBloc.online) {
      Hive.box(GAMESBOX).put(currentGame, newData);
      if (currentGame == null)
        throw Alert("New offline data not in box", "My bad, sorry");
    }
    Game.data = newData;
    Game.save();
  }

  static deleteGame() {
    if (!MainBloc.online) {
      Game.data.delete();
    }
  }

  static GameData newGame([GameData preset]) {
    GameData newGameData = preset ?? GameData();
    if (!online && !Game.testing) {
      Hive.box(METABOX).put("intTotalGames", getGameNumber + 1);
      newGameData.settings.name = "Game $getGameNumber";
      Hive.box(GAMESBOX).add(newGameData);

      Hive.box(METABOX).put("intCurrentGame", getGameNumber);
    }
    newGameData.currency = CurrencyHelper.selectedCurrency.icon;
    newGameData.placeCurrencyInFront =
        CurrencyHelper.selectedCurrency.placeCurrencyInFront;
    return newGameData;
  }

  static bool get randomDices =>
      Hive.box(PREFBOX).get("boolDoneRandomSelect", defaultValue: true) ||
      online;
}

enum SaveData {
  gmap,
  players,
  lostPlayers,
  dealData,
  settings,
  bankData,
}
