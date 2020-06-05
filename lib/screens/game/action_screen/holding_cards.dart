import 'package:flutter/material.dart';

import '../../../bloc/game_listener.dart';
import '../../../bloc/main_bloc.dart';
import '../../../bloc/ui_bloc.dart';
import '../../../engine/kernel/main.dart';
import '../../../widgets/end_of_list.dart';
import 'property_card.dart';

class HoldingCards extends StatelessWidget {
  final List<String> properties;
  final bool only;
  const HoldingCards({
    Key key,
    this.only: false,
    this.properties,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameListener(
        builder: (c, _, __) => buildHoldingCards(context, properties));
  }

  Widget buildHoldingCards(BuildContext context, [List<String> properties]) {
    List<String> _properties = Game.data.player.properties;
    if (properties != null) {
      _properties = properties;
    } else {
      if (MainBloc.online) _properties = UIBloc.gamePlayer.properties;
    }
    if (_properties.isEmpty) {
      return Container(
        height: 100,
        child: Center(
            child: Card(
                child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text("You have no properties yet"),
        ))),
      );
    }
    if (only)
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _properties.length,
          itemBuilder: (context, index) {
            return Theme(
              data: Theme.of(context).copyWith(brightness: Brightness.light),
              child: GameListener(
                builder: (BuildContext context, _, __) {
                  return PropertyCard(
                      tile: Game.data.gmap.firstWhere(
                          (element) => element.id == _properties[index]));
                },
              ),
            );
          });
    return ListView(
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _properties.length,
            itemBuilder: (context, index) {
              return Theme(
                data: Theme.of(context).copyWith(brightness: Brightness.light),
                child: GameListener(
                  builder: (BuildContext context, _, __) {
                    return PropertyCard(
                        tile: Game.data.gmap.firstWhere(
                            (element) => element.id == _properties[index]));
                  },
                ),
              );
            }),
        EndOfList()
      ],
    );
  }
}
