import 'package:flutter/material.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/extensions/setting.dart';
import '../../engine/kernel/main.dart';
import '../../widgets/my_card.dart';
import '../../widgets/setting_tile.dart';

class ExtraCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: "Extra",
      children: [
        ListTile(
          title: Text("Generate names"),
          subtitle: Text("Generate names for the land tiles"),
          trailing: buildGenerateTrailing(context),
        ),
        ListTile(
          title: Text("Shuffle tiles"),
          subtitle: Text("This will shuffle the tiles in a random order."),
          trailing: RaisedButton(
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            child: Text("Shuffle"),
            onPressed: () {
              if (Game.data?.gmap != null) {
                Game.data.gmap.shuffle();

                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Shuffeld map!"),
                ));
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Couldn't shuffle map"),
                ));
              }
            },
          ),
        ),
        SettingTile(
          setting: Setting<int>(
              title: "Starting properties",
              subtitle: "Amount of properties every player starts with.",
              onChanged: (dynamic val) =>
                  Game.data.settings.startProperties = val,
              value: () => Game.data.settings.startProperties),
        )
      ],
    );
  }

  Widget buildGenerateTrailing(BuildContext context) {
    if (!(Game.data.running ?? false)) {
      if (Game.data.gmap[0].description == null ||
          Game.data.gmap[0].description == "") {
        return Switch(
          value: Game.data.settings.generateNames ?? false,
          onChanged: (bool val) {
            Game.data.settings.generateNames = val;
            Game.save(only: [SaveData.settings.toString()]);
          },
        );
      } else {
        return Tooltip(
          message: "Names detected. Generate names when running.",
          child: Switch(
            value: false,
            onChanged: null,
          ),
        );
      }
    } else {
      return RaisedButton(
        textColor: Colors.white,
        color: Theme.of(context).primaryColor,
        child: Text("Generate"),
        onPressed: () {
          if (Game.data?.gmap != null) {
            Game.generateNames();

            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Generated names"),
            ));
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Couldn't generated names"),
            ));
          }
        },
      );
    }
  }
}
