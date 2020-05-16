import 'package:flutter/material.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/engine/kernel/main.dart';
import 'package:plutopoly/engine/ui/alert.dart';
import 'package:plutopoly/engine/ui/game_navigator.dart';

class StartOnlineButton extends StatelessWidget {
  const StartOnlineButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: RaisedButton(
        textColor: Colors.white,
        color: Theme.of(context).primaryColor,
        child: Container(
            width: double.infinity,
            child: Text(
              "Start online game",
              textAlign: TextAlign.center,
            )),
        onPressed: () async {
          bool cancel = false;

          showDialog(
            context: context,
            builder: (context) {
              cancelConnection() {
                if (MainBloc.waiter != null) {
                  MainBloc.waiter.cancel();
                }
                MainBloc.cancelOnline();
                cancel = true;
              }

              Future.delayed(Duration(seconds: 10), () {
                if (cancel) return;
                if ((MainBloc.waiter?.isPaused ?? true)) {
                  if (Game.data == null) {
                    cancelConnection();
                    UIBloc.alerts.add(Alert("Couldn't create game",
                        "Check your internet connection."));
                    MainBloc.prefbox.put("update", true);
                  }
                }
              });

              return AlertDialog(
                  title: Text("Creating game"),
                  content: Container(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  actions: [
                    MaterialButton(
                        onPressed: () {
                          cancelConnection();
                          UIBloc.navigatorKey.currentState.pop();
                        },
                        child: Text(
                          "close",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ))
                  ]);
            },
          );

          Alert alert = await MainBloc.newOnlineGame();
          if (cancel) return;
          Navigator.pop(context);
          if (Alert.handle(() => alert, context)) {
            GameNavigator.navigate(
              context,
            );
          }
        },
      ),
    );
  }
}
