import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../../../engine/data/map.dart';
import '../../../engine/data/player.dart';
import '../../../engine/extensions/transportation.dart';
import '../../../engine/kernel/main.dart';
import '../../../engine/ui/alert.dart';
import '../../../helpers/money_helper.dart';
import '../../../widgets/my_card.dart';

class MoveCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Player owner = Game.data.tile.owner;
    List<Tile> trains = owner.transtationTiles;
    List<Widget> children = [];

    trains.forEach((Tile tile) {
      if (tile == Game.data.tile) return;
      bool isOwner = owner == Game.data.player;
      children.add(ListTile(
        title: Text("Move to ${tile.name}"),
        subtitle: Text("Position: ${tile.mapIndex}"),
        trailing: RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text(
              isOwner ? "move" : "Pay ${mon(tile.transportationPrice ?? 0)}"),
          onPressed: Game.data.transported || (!isOwner && !Game.data.rentPayed)
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
