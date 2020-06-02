import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../../bloc/main_bloc.dart';
import '../../bloc/recent.dart';
import '../../bloc/recent_bloc.dart';
import '../../bloc/ui_bloc.dart';
import '../../engine/kernel/main.dart';
import '../../engine/ui/alert.dart';
import '../../engine/ui/game_navigator.dart';
import '../../widgets/my_card.dart';

class RecentCard extends StatelessWidget {
  final Box box;
  final bool active;
  const RecentCard({Key key, @required this.box, this.active: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> recents = [];
    RecentBloc.getRecent().forEach((String key, Recent recentGame) {
      if (active && (recentGame.idle ?? true)) return;
      recents.add(InkWell(
        onTap: () {
          joinOnline(context, key);
        },
        child: ListTile(
          leading: Container(
            height: 40,
            width: 40,
            child: Center(
              child: Text(
                recentGame.turn?.toString() ?? "unknown",
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
          title: Text(recentGame.name ?? "unknown"),
          subtitle: Text(key),
          trailing: IconButton(
            icon: Icon(Icons.build),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: Text("Recent Game"),
                      content: Container(
                        constraints: BoxConstraints(maxWidth: UIBloc.maxWidth),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text("Owner"),
                              subtitle: Text(recentGame.owner ?? "unknown"),
                            ),
                            ListTile(
                              title: Text("Name"),
                              subtitle: Text(recentGame.name ?? "unknown"),
                            ),
                            ListTile(
                              title: Text("Turn"),
                              subtitle: Text(
                                  recentGame.turn?.toString() ?? "unknown"),
                            ),
                            ListTile(
                              title: Text("key"),
                              subtitle: Text(recentGame.key ?? "unknown"),
                              trailing: IconButton(
                                icon: Icon(Icons.content_copy),
                                onPressed: () async {
                                  try {
                                    await Clipboard.setData(ClipboardData(
                                        text: recentGame.key ?? "error"));
                                  } catch (e) {
                                    Alert.handle(
                                        () => Alert("Clipboard failed",
                                            "Did you give acces to use the clipboard?"),
                                        context);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        MaterialButton(
                            onPressed: () {
                              recentGame.delete();

                              Navigator.pop(context);
                            },
                            child: Text("remove",
                                style: TextStyle(
                                  color: Colors.red,
                                ))),
                        MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "close",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            )),
                      ]);
                },
              );
            },
          ),
        ),
      ));
      recents.add(Divider());
    });
    if (recents.isEmpty) {
      if (active) {
        return Container();
      }
      recents.add(Container(
        height: 80,
        child: Center(
          child: Text("No recent keys"),
        ),
      ));
    }

    if (recents.length > 1) {
      recents.removeLast();
    }

    return MyCard(
      color: active ? Colors.redAccent : Theme.of(context).cardColor,
      title: active ? "Your turn!" : "Recent Keys",
      children: recents,
    );
  }

  static joinOnline(BuildContext context, [String key]) async {
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
              UIBloc.alerts.add(Alert(
                  "Couldn't join game", "Check your internet connection."));
              MainBloc.prefbox.put("update", true);
            }
          }
        });

        return AlertDialog(
            title: Text("Joining game"),
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
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ))
            ]);
      },
    );
    Alert alert;
    if (key == null) {
      alert = await MainBloc.newOnlineGame();
    } else {
      alert = await MainBloc.joinOnline(key);
    }
    if (cancel) return;
    Navigator.pop(context);
    if (alert != null) cancel = true;
    if (Alert.handle(() => alert, context)) {
      GameNavigator.navigate(context, loadGame: true);
    }
  }
}
