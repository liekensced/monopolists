import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/engine/ai/ai_type.dart';
import 'package:plutopoly/engine/kernel/main.dart';
import 'package:plutopoly/widgets/my_card.dart';

class IdleSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyCard(
      listen: true,
      title: "settings",
      children: [
        ListTile(
          title: Text("Change color"),
          trailing: CircleColor(
            color: Color(UIBloc.gamePlayer.color),
            circleSize: 30,
            onColorChoose: () {
              showDialog(
                context: context,
                builder: (context) {
                  Color newColor = Colors.red;
                  return AlertDialog(
                      title: Text("Pick a color"),
                      content: MaterialColorPicker(
                        onColorChange: (Color val) {
                          newColor = val;
                        },
                      ),
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
                            onPressed: () {
                              UIBloc.gamePlayer.color = newColor.value;
                              Game.save(only: [SaveData.players.toString()]);
                              Navigator.pop(context);
                            },
                            child: Text(
                              "save",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ))
                      ]);
                },
              );
            },
          ),
        ),
        ListTile(
          title: Text("Let a bot play for you"),
          subtitle: Text("A bot will take your place from the next turn."),
          trailing: Switch(
            value: UIBloc.gamePlayer.ai.type == AIType.normal,
            onChanged: (bool val) {
              if (!Game.data.ui.idle) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: Text("Failed"),
                        content:
                            Text("You have to be idle to change this setting."),
                        actions: [
                          MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "close",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ))
                        ]);
                  },
                );
                return;
              }
              if (Game.data.ui.amountRealPlayers <= 1) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: Text("Failed"),
                        content: Text("There has to be at least 1 real player"),
                        actions: [
                          MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "close",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ))
                        ]);
                  },
                );
                return;
              }

              if (UIBloc.gamePlayer.ai.type == AIType.player) {
                UIBloc.gamePlayer.ai.type = AIType.normal;
              } else {
                UIBloc.gamePlayer.ai.type = AIType.player;
              }
              Game.save(force: true);
            },
          ),
        )
      ],
    );
  }
}
