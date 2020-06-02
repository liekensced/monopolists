import 'package:flutter/material.dart';
import 'package:plutopoly/engine/data/map.dart';
import 'package:plutopoly/engine/data/player.dart';
import 'package:plutopoly/engine/extensions/transportation.dart';
import 'package:plutopoly/engine/kernel/main.dart';
import 'package:plutopoly/engine/ui/alert.dart';
import 'package:plutopoly/widgets/my_card.dart';

class MoveCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Player owner = Game.data.tile.owner;
    List<Tile> trains = owner.transtationTiles;
    List<Widget> children = [];

    trains.forEach((Tile tile) {
      if (tile == Game.data.tile) return;
      children.add(ListTile(
        title: Text("Move to ${tile.name}"),
        subtitle: Text("Position: ${tile.mapIndex}"),
        trailing: RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text(owner == Game.data.player
              ? "move"
              : "Pay £" + (Game.data.tile.transportationPrice ?? 0).toString()),
          onPressed: Game.data.transported
              ? null
              : () {
                  Alert.handle(() => TransportationBloc.move(tile), context);
                },
        ),
      ));
    });

    return MyCard(
      title: "move",
      children: children,
    );
  }
}
