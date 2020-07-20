import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/screens/game/win_screen.dart';
import 'package:plutopoly/screens/game/zoom_map.dart';
import 'package:plutopoly/widgets/end_of_list.dart';
import 'package:plutopoly/widgets/my_card.dart';

import '../engine/ai/ai_type.dart';
import '../engine/ai/normal/normal_ai.dart';
import '../engine/data/main_data.dart';
import '../engine/data/map.dart';
import '../engine/kernel/main.dart';
import '../engine/ui/alert.dart';

class GmapChecker {
  static check(List<Tile> map) {
    List<String> usedIds = [];
    map.forEach((Tile element) {
      if (usedIds.contains(element.id)) {
        throw Alert(
            "No unique id", "There are two tiles with the same id:\n$element");
      }
      usedIds.add(element.id);
    });
  }

  static botGame({bool nullify: false}) async {
    GameData oldData = Game.data;
    try {
      timeDilation = 0.0001;
      Game.data = GameData.fromJson(Game.data.toJson());

      Game.testing = true;
      Game.setup.addPlayer(name: "test", color: Colors.black.value, code: 555);
      Game.data.players.last.ai.type = AIType.normal;
      Game.data.settings.maxTurnes = min(Game.data.settings.maxTurnes, 500);
      if (Game.data.players.length < 2) {
        Game.setup.addBot();
        Game.setup.addBot(hard: true);
      }
      Game.launch();
      await NormalAI.onPlayerTurn();
    } catch (e) {
      print("Bot game failed: $e");
    } finally {
      Timer checker =
          Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
        if (Game.data.ui.ended) {
          timer.cancel();
          cleanUp(oldData, nullify);
        }
      });
      Future.delayed(Duration(seconds: 3), () {
        if (checker.isActive) {
          checker.cancel();
          cleanUp(oldData, nullify);
        }
      });
    }
  }

  static cleanUp(GameData oldData, bool nullify) {
    timeDilation = 1;
    UIBloc.navigatorKey.currentState
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Test game"),
        ),
        body: ListView(
          children: [
            MyCard(
              title: "info",
              children: [
                ListTile(
                  title: Text("Amount of turns"),
                  subtitle: Text(Game.data.turn.toString()),
                ),
                MoneyProgressionChart()
              ],
            ),
            ZoomMap(),
            EndOfList()
          ],
        ),
      );
    })).then((value) {
      Game.data = nullify ? null : oldData;
      Game.testing = false;
    });
  }
}
