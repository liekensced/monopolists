import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:plutopoly/engine/data/map.dart';
import 'package:plutopoly/engine/data/player.dart';
import 'package:plutopoly/engine/extensions/transportation.dart';
import 'package:plutopoly/engine/kernel/main.dart';
import 'package:plutopoly/engine/ui/alert.dart';
import 'package:plutopoly/helpers/money_helper.dart';
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
              : "Pay ${mon(tile.transportationPrice ?? 0)}"),
          onPressed: Game.data.transported
              ? null
              : () {
                  if (Alert.handle(
                      () => TransportationBloc.move(tile), context)) {
                    AwesomeDialog(
                      dialogType: DialogType.SUCCES,
                      title: "Transported",
                      desc: "You moved to ${tile.mapIndex}",
                      context: context,
                      animType: AnimType.LEFTSLIDE,
                      headerAnimationLoop: false,
                    ).show();
                  }
                  ;
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
