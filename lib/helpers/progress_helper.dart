import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:overlay_support/overlay_support.dart';

import '../bloc/main_bloc.dart';
import '../bloc/ui_bloc.dart';
import '../engine/ai/ai_type.dart';
import '../engine/data/tip.dart';
import '../engine/kernel/main.dart';
import '../screens/start/info_screen.dart';
import '../widgets/animated_count.dart';

class ProgressHelper {
  static const String expKey = "intExp";
  static const String ticketKey = "intKey";
  static const String levelsReceivedKey = "intLevelsReceivedKey";
  static const String energyKey = "intEnergy";
  static const String starsKey = "intStars";

  static const int defaultExp = 170;
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
      tickets += ticketReward(levelsReceived + 1);
      box.put(levelsReceivedKey, amount);
    }
  }

  static int ticketReward(int level) {
    if (level % 21 == 0) return 100;
    if (level % 8 == 0) return 50;
    if (level % 6 == 0) return 30;
    if (level % 2 == 0) return 20;
    return 5;
  }

  static int get level => exp ~/ expPerLevel;

  static int get tickets => box.get(ticketKey, defaultValue: 0);
  static set tickets(int amount) => box.put(ticketKey, amount);

  static int get stars => box.get(starsKey, defaultValue: 0);
  static set stars(int amount) => box.put(starsKey, amount);

  static int get energy => box.get(energyKey, defaultValue: 0);
  static set energy(int amount) {
    if (amount > energy) {
      showSimpleNotification(
        Text("Your received ${amount - energy} energy!"),
        leading: FaIcon(
          FontAwesomeIcons.bolt,
          color: Colors.yellow,
        ),
        slideDismiss: true,
        background: Colors.white,
      );
    }
    box.put(energyKey, amount);
  }

  static void init() {
    if (!box.containsKey(expKey)) {
      box.put(expKey, defaultExp);
    }
    if (!box.containsKey(ticketKey)) {
      box.put(ticketKey, 20);
    }
    if (!box.containsKey(energyKey)) {
      box.put(energyKey, 3);
    }
  }

  static void onNext() {
    double reward = 3;
    Game.data.players.forEach((element) {
      if (element.ai == AIType.player) {
        reward += MainBloc.online ? 2 : 1;
      } else {
        reward += 0.7;
      }
    });
    exp += min(reward.floor(), 50);
  }

  static const Map<int, Info> LevelInfo = {
    2: Info("Adventure mode",
        "Navigate to the adventure page on your homescreen!", InfoType.alert),
    10: Info("Hard mode", "You can add a hard AI when creating a new game!",
        InfoType.tip),
    20: Info("Time dilation",
        "Change how fast the game runs in the visual settings.", InfoType.tip),
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
        level ?? ProgressHelper.level.toString(),
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
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
            color: Colors.white,
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
  final int level;

  const LevelUpScreen({Key key, @required this.level}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("You leveled up"),
        actions: [
          Center(
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValueListenableBuilder(
                valueListenable: Hive.box(MainBloc.ACCOUNTBOX).listenable(),
                builder: (BuildContext context, _, __) {
                  return Row(
                    children: <Widget>[
                      AnimatedCount(
                        count: ProgressHelper.tickets,
                        duration: Duration(seconds: 1),
                      ),
                      Container(
                        height: 0,
                        width: 5,
                      ),
                      Icon(
                        Icons.local_activity,
                        size: 20,
                      )
                    ],
                  );
                },
              ),
            )),
          ),
          Container(
            width: 5,
          )
        ],
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: UIBloc.maxWidth),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: LevelUpNotification(
                    level: level.toString(),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('level'),
                      Text(
                        level.toString() ?? ProgressHelper.level.toString(),
                        style: TextStyle(fontSize: 100),
                      ),
                      Chip(
                          label: Text(
                              '+${ProgressHelper.ticketReward(level)} tickets'),
                          avatar: CircleAvatar(
                            backgroundColor: Colors.grey.shade800,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Icon(
                                Icons.local_activity,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
                Spacer(),
                if (ProgressHelper.LevelInfo.containsKey(level))
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GeneralInfoCard(
                      info: ProgressHelper.LevelInfo[level],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: FloatingActionButton.extended(
                      onPressed: () {
                        ProgressHelper.levelsReceived = level;
                        if (ProgressHelper.levelsReceived <
                            ProgressHelper.level) {
                          MainBloc.prefbox.put("update", true);
                        } else {
                          Future.delayed(Duration(milliseconds: 500), () {
                            MainBloc.prefbox.put("update", true);
                          });
                        }
                      },
                      label: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 50,
                        ),
                        child: Text(
                          "Receive",
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ),
                Container(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
