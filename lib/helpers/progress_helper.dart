import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/engine/ai/ai_type.dart';
import 'package:plutopoly/engine/data/tip.dart';
import 'package:plutopoly/engine/kernel/main.dart';
import 'package:plutopoly/screens/start/info_screen.dart';

class ProgressHelper {
  static const String expKey = "intExp";
  static const String ticketKey = "intKey";
  static const String levelsReceivedKey = "intLevelsReceived";
  static const String energyKey = "intEnergy";
  static const int defaultExp = 150;
  static const int expPerLevel = 100;

  static double get levelProgress => (exp % expPerLevel) / expPerLevel;

  static Box get box => Hive.box(MainBloc.ACCOUNTBOX);

  static int get exp => box.get(expKey, defaultValue: defaultExp);
  static set exp(int amount) {
    int lastLevel = level;
    box.put(expKey, amount);
    if (lastLevel < level) {
      showSimpleNotification(
        LevelUpNotification(level: level.toString()),
        slideDismiss: true,
        background: Colors.black,
      );
    }
  }

  static int get levelsReceived => box.get(levelsReceivedKey, defaultValue: 1);
  static set levelsReceived(int amount) {
    if (amount > levelsReceived) {
      box.put(levelsReceivedKey, amount);
    }
  }

  static int get level => exp ~/ expPerLevel;

  int get tickets => box.get(ticketKey, defaultValue: 0);

  static int get energy => box.get(energyKey, defaultValue: 0);
  static set energy(int amount) => box.put(energyKey, amount);

  static void init() {
    if (!box.containsKey(expKey)) {
      box.put(expKey, defaultExp);
    }
    if (!box.containsKey(ticketKey)) {
      box.put(ticketKey, 5);
    }
  }

  static void onNext() {
    int reward = 0;
    Game.data.players.forEach((element) {
      if (element.ai == AIType.player) {
        reward += MainBloc.online ? 5 : 2;
      } else {
        reward += 2;
      }
    });
    exp += min(reward, 50);
  }

  static const Map<int, Info> LevelInfo = {
    2: Info("Adventure mode", "Navigate to adventure on your homescreen!",
        InfoType.tip),
    10: Info("Hard mode", "You can add a hard AI when creating a new game!",
        InfoType.tip),
  };
}

class LevelUpNotification extends StatelessWidget {
  final String level;
  const LevelUpNotification({
    Key key,
    @required this.level,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Text(
        level,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
      ),
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.deepPurple,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            Icons.arrow_upward,
            size: 40,
          ),
        ),
      ),
      title: Text(
        "You leveled up!",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: LinearProgressIndicator(
        value: null,
        backgroundColor: Colors.green,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.green[900]),
      ),
    );
  }
}

class LevelUpScreen extends StatelessWidget {
  final String level;

  const LevelUpScreen({Key key, this.level}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("You leveled up"),
      ),
      body: Container(
        constraints: BoxConstraints(maxWidth: UIBloc.maxWidth),
        child: Center(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('level'),
                    Text(level),
                  ],
                ),
              ),
              LevelUpNotification(
                level: level,
              ),
              if (ProgressHelper.LevelInfo.containsKey(level))
                GeneralInfoCard(
                  info: ProgressHelper.LevelInfo[level],
                )
            ],
          ),
        ),
      ),
    );
  }
}
