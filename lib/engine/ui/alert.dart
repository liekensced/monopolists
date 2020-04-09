import 'package:flutter/material.dart';
import 'package:monopolists/engine/data/player.dart';
import 'package:monopolists/engine/kernel/main.dart';

/// This can be returned by a Game method to show in the UI
class Alert {
  String title = "";
  String content = "";
  Map<String, Function> actions;
  bool closable = true;
  bool snackbar = false;
  bool failed = true;
  Alert(
    this.title,
    this.content, {
    this.actions,
    this.closable: true,
    this.failed: true,
    this.snackbar: false,
  });
  Alert.snackBar(this.title, [this.content]) {
    content = content ?? "";
    snackbar = true;
    failed = false;
  }
  Alert.funds([Player player]) {
    title = "Not enough funds";
    content = (player?.name ?? Game.data.player.name) +
        " does not have enough money.";
  }

  static void handleAndPop(Alert Function() f, BuildContext context) {
    if (handle(f, context)) {
      Navigator.pop(context);
    }
  }

  static bool handle(Alert Function() function, BuildContext context) {
    Alert alert = function();
    if (alert != null) {
      if (alert.snackbar) {
        Scaffold.of(context).hideCurrentSnackBar();

        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(alert.title),
        ));

        return true;
      }

      List<Widget> actions = [];
      if (alert.closable) {
        actions.add(MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "close",
              style: TextStyle(color: Theme.of(context).primaryColor),
            )));
      }
      if (alert.actions != null) {
        alert.actions.forEach((String key, Function value) {
          actions.add(MaterialButton(
              onPressed: value,
              child: Text(
                key,
                style: TextStyle(color: Theme.of(context).primaryColor),
              )));
        });
      }

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(alert.title),
              content: Text(alert.content),
              actions: actions);
        },
      );
      return !alert.failed;
    } else
      return true;
  }
}
