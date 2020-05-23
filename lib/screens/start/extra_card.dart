import 'dart:math';

import 'package:flutter/material.dart';
import 'package:plutopoly/engine/data/map.dart';
import 'package:plutopoly/engine/extensions/setting.dart';
import 'package:plutopoly/engine/kernel/main.dart';
import 'package:plutopoly/widgets/my_card.dart';
import 'package:plutopoly/widgets/setting_tile.dart';

import '../../places.dart';

class ExtraCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: "Extra",
      children: [
        ListTile(
          title: Text("Generate names"),
          subtitle: Text("Generate names for the land tiles"),
          trailing: RaisedButton(
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            child: Text("Generate"),
            onPressed: () {
              if (Game.data?.gmap != null) {
                List<int> used = [];
                Game.data.gmap.forEach((Tile property) {
                  if (property.type != TileType.land) return;
                  int i = Random().nextInt(MAP_NAMES.length ~/ 2) * 2;
                  print(MAP_NAMES.length);
                  while (used.contains(i)) {
                    i = Random().nextInt(MAP_NAMES.length ~/ 2) * 2;
                  }
                  used.add(i);
                  property.name = MAP_NAMES[i];
                  property.description = MAP_NAMES[i + 1];
                });

                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Generated names"),
                ));
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Couldn't generated names"),
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
}
