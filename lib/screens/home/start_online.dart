import 'package:flutter/material.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/engine/kernel/main.dart';
import 'package:plutopoly/engine/ui/alert.dart';
import 'package:plutopoly/engine/ui/game_navigator.dart';
import 'package:plutopoly/store/preset.dart';

class StartOnlineButton extends StatelessWidget {
  final Preset preset;

  const StartOnlineButton({
    Key key,
    this.preset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: UIBloc.maxWidth),
        padding: EdgeInsets.all(20),
        child: RaisedButton(
          textColor: Colors.white,
          color: Theme.of(context).primaryColor,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    title: Text("Start online game"),
                    content: Text(
                        "Are you sure you want to start an online game? If you're playing alone you should start a local game."),
                    actions: [
                      MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "cancel",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )),
                      MaterialButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            bool cancel = false;

                            showDialog(
                              barrierDismissible: false,
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
                                      UIBloc.alerts.add(Alert(
                                          "Couldn't create game",
                                          "Check your internet connection."));
                                      MainBloc.prefbox.put("update", true);
                                    }
                                  }
                                });

                                return AlertDialog(
                                    title: Text("Creating game"),
                                    content: Container(
                                      height: 100,
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    ),
                                    actions: [
                                      MaterialButton(
                                          onPressed: () {
                                            cancelConnection();
                                            UIBloc.navigatorKey.currentState
                                                .pop();
                                          },
                                          child: Text(
                                            "close",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ))
                                    ]);
                              },
                            );

                            Alert alert =
                                await MainBloc.newOnlineGame(preset?.data);
                            if (cancel) return;
                            UIBloc.navigatorKey.currentState.pop();

                            if (Alert.handle(() => alert, context)) {
                              GameNavigator.navigate(
                                context,
                              );
                            }
                          },
                          child: Text(
                            "yes",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ))
                    ]);
              },
            );
          },
          child: Center(
            child: Text(
              "Start online game",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
