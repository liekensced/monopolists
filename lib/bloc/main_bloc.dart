import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';

import '../engine/data/main.dart';
import '../engine/data/map.dart';
import '../engine/data/player.dart';
import '../engine/kernel/main.dart';
import '../engine/ui/alert.dart';
import 'recent_bloc.dart';

class MainBloc {
  static const version = "0.2.5";
  static const _boxVersion = "1.1.2.8";
  static const GAMESBOX = _boxVersion + "gamesbox";

  static const PREFBOX = _boxVersion + "prefbox";
  static const METABOX = _boxVersion + "metabox";
  static const UPDATEBOX = _boxVersion + "updateBox";
  static const MAPCONFBOX = _boxVersion + "mapconfBox";
  static const ACCOUNTBOX = _boxVersion + "accountBox";
  static const RECENTBOX = _boxVersion + "recentBox";

  static int currentGame = 0;
  static bool online = false;
  static String gameId;
  static StreamSubscription<DocumentSnapshot> listener;
  static StreamSubscription<DocumentSnapshot> waiter;

  static bool dealOpen = false;

  static Box get metaBox {
    return Hive.box(METABOX);
  }

  static Future<Alert> newOnlineGame() async {
    if (player.name == null || player.name == "null")
      return Alert.accountIncomplete();
    Alert alert;
    online = true;
    Hive.box(METABOX).put("boolOnline", true);
    DocumentReference data =
        await Firestore.instance.collection("/games").add({"starting ...": ""});
    gameId = data.documentID;
    Game.newGame();
    waiter = await data.snapshots().listen((event) {
      if (event.exists) {
        Game.save();
        joinOnline(data.documentID);
      }
    });
    if (alert != null) return alert;
    Future.delayed(Duration(seconds: 10), () async {
      if (waiter != null) if (waiter.isPaused) {
        waiter.cancel();
        await cancelOnline();
        alert = Alert("Failed to start game", "Check you internet connection.");
      }
    });
    return alert;
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

  static Future<Alert> joinOnline(String gameIdInput) async {
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
        Game.setup
            .addPlayer(name: player.name, color: player.color, code: code);
      }
    } catch (e) {
      await cancelOnline();
      return Alert("Error while joining game", e.toString());
    }
    Hive.box(METABOX).put("boolOnline", true);
    RecentBloc.update(Game.data);
    return null;
  }

  static cancelOnline() async {
    online = false;
    gameId = null;
    if (listener != null) await listener.cancel();
    Hive.box(METABOX).put("boolOnline", false);
    print("===CANCELED===");
  }

  static update(DocumentSnapshot snap) {
    Game.data = GameData.fromJson(snap.data);
    print("== Received Data ==");
    Hive.box(UPDATEBOX).put("update", 0);
  }

  static save(GameData data) {
    if (!online) {
      print("== New Local Save ==");
      data.save();
    } else {
      print("== New Online Save ==");
      RecentBloc.update(data);
      if (data != null) {
        data.bot = false;
        Map<String, dynamic> json = data.toJson();
        Firestore.instance.document("/games/$gameId").updateData(json);
      }
      Hive.box(UPDATEBOX).put("update", 0);
    }
  }

  static Box get prefbox => Hive.box(PREFBOX);

  static initBloc(BuildContext context) {
    code;

    currentGame = Hive.box(METABOX).get("intCurrentGame");
    if (Hive.box(MAPCONFBOX).isEmpty) {
      Hive.box(MAPCONFBOX).put("classic", MapConfiguration.standard());
      Hive.box(MAPCONFBOX).put("dense", MapConfiguration.dense());
    }
    if (Hive.box(MainBloc.PREFBOX).get("mapConfiguration") == null) {
      Hive.box(MainBloc.PREFBOX).put(
          "mapConfiguration", UIBloc.isWide(context) ? "classic" : "dense");
    }

    RecentBloc.checkRecent();
  }

  static int get getGameNumber {
    return Hive.box(METABOX).get("intTotalGames", defaultValue: 0);
  }

  static GameData newGame() {
    GameData newGameData = GameData();
    if (!online && !Game.testing) {
      Hive.box(METABOX).put("intTotalGames", getGameNumber + 1);
      newGameData.settings.name = "Game $getGameNumber";

      Hive.box(GAMESBOX).add(newGameData);

      Hive.box(METABOX).put("intCurrentGame", getGameNumber);
    }
    return newGameData;
  }

  ///Use GameListener
  @deprecated
  static listen() {
    return Listenable.merge(
            [Hive.box(GAMESBOX).listenable(), Hive.box(UPDATEBOX).listenable()])
        as ValueListenable;
  }

  static bool get randomDices =>
      Hive.box(PREFBOX).get("boolDoneRandomSelect", defaultValue: true) ||
      online;
}
