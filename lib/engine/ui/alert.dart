import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/engine/ui/game_navigator.dart';
import 'package:plutopoly/helpers/money_helper.dart';

import '../../screens/start/players.dart';
import '../data/player.dart';
import '../kernel/main.dart';

/// This can be returned by a Game method to show in the UI
class Alert {
  static const String FASTJOIN = ">FAST_JOIN";
  String title = "";
  String content = "";

  /// The key is the shown name
  /// Gets added after the cancel action.
  /// Please pop when done
  Map<String, Function(BuildContext context)> actions;
  bool closable = true;
  bool snackbar = false;
  bool failed = true;
  DialogType type;
  Alert(
    this.title,
    this.content, {
    this.actions,
    this.closable: true,
    this.failed: true,
    this.snackbar: false,
    this.type,
  });
  Alert.snackBar(this.title, [this.content]) {
    content = content ?? "";
    snackbar = true;
    failed = false;
  }
  Alert.exception(e) {
    title = "Something went wrong :/";
    content = e.toString();
  }
  Alert.join(String gamePin) {
    if (gamePin == null) {
      title = "failed alert";
      content = "failed unsucessfullly";
    } else {
      title = FASTJOIN;
      content = gamePin;
    }
  }
  Alert.accountIncomplete() {
    title = "Please complete your account";
    content = "Change your name and add a color";

    actions = {
      "change": (BuildContext context) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return AddPlayerDialog(prefPlayer: true);
          },
        );
      }
    };
  }
  Alert.funds([Player player, int needed]) {
    title = "Not enough funds";
    double money = player?.money ?? Game.data.player.money;
    content = (player?.name ?? Game.data.player.name) +
        " does not have enough money" +
        (needed == null ? "." : ":\n${mon(needed)} > ${mon(money)}}");
  }

  static void handleAndPop(Alert Function() f, BuildContext context) {
    if (handle(f, context)) {
      Navigator.pop(context);
    }
  }

  static joinOnline(BuildContext context, String gamePin) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AddPlayerDialog(prefPlayer: true);
      },
    );
    if (MainBloc.player.name != "null") {
      Alert alert = await MainBloc.joinOnline(gamePin);
      if (handle(() => alert, context)) {
        GameNavigator.navigate(context);
      }
    }
  }

  static bool handle(Function() function, BuildContext context) {
    Alert alert;
    if (UIBloc.lost) {
      alert = Alert(
        "Lost",
        "You already lost and can't do anything.",
      );
    } else {
      try {
        alert = function();
      } catch (e) {
        if (e is Alert) {
          alert = e;
        } else {
          alert = Alert.exception(e);
        }
      }
    }
    if (alert != null) {
      if (alert.title == FASTJOIN) {
        joinOnline(context, alert.content);
        return true;
      }
      if (alert.snackbar) {
        try {
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(alert.title),
          ));
        } finally {
          return true;
        }
      }

      List<Widget> actions = [];
      if (alert.closable) {
        actions.add(MaterialButton(
            onPressed: () {
              UIBloc.navigatorKey.currentState.pop();
            },
            child: Text(
              "close",
              style: TextStyle(color: Theme.of(context).primaryColor),
            )));
      }
      if (alert.actions != null) {
        alert.actions.forEach((String key, Function value) {
          actions.add(MaterialButton(
              onPressed: () => value(context),
              child: Text(
                key,
                style: TextStyle(color: Theme.of(context).primaryColor),
              )));
        });
      }

      if (alert.closable && actions.length == 1) {
        AwesomeDialog(
          dialogType: alert.type ??
              (alert.failed ? DialogType.ERROR : DialogType.WARNING),
          title: alert.title,
          desc: alert.content,
          context: context,
          headerAnimationLoop: false,
        ).show();
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text(alert.title),
                content: Text(alert.content),
                actions: actions);
          },
        );
      }
      return !alert.failed;
    } else
      return true;
  }

  @override
  String toString() {
    return "$title: $content";
  }
}
