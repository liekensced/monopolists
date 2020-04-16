import 'package:flutter/material.dart';
import 'package:plutopoly/engine/kernel/main.dart';
import 'package:plutopoly/engine/ui/game_navigator.dart';
import 'package:plutopoly/widgets/my_card.dart';

class DefaultCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: "Default",
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            color: Colors.red[900],
            child: Container(
              margin: EdgeInsets.all(4),
              width: double.maxFinite,
              child: Center(child: Text("Default")),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: Text("Default"),
                      content: Text(
                          "Are you sure you want to default? You will not be able to continue playing."),
                      actions: [
                        MaterialButton(
                            onPressed: () {
                              Game.setup.defaultPlayer(Game.data.player);
                              Navigator.pop(context);
                              GameNavigator.navigate(context);
                            },
                            child: Text("default",
                                style: TextStyle(
                                  color: Colors.red,
                                ))),
                        MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "cancel",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            )),
                      ]);
                },
              );
            },
          ),
        )
      ],
    );
  }
}
