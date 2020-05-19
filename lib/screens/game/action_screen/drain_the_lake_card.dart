import 'package:flutter/material.dart';
import 'package:plutopoly/engine/extensions/lake_drain_extension.dart';
import 'package:plutopoly/engine/kernel/main.dart';
import 'package:plutopoly/engine/ui/alert.dart';
import 'package:plutopoly/widgets/my_card.dart';

class DrainTheLakeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: "Drain the lake",
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "You can drain a lake for a large amount of money. This will add 2 properties to the map that you will own and can upgrade.",
          ),
        ),
        Tooltip(
          message: "Available from turn 15",
          child: RaisedButton(
            onPressed: LakeDrain.canDrain
                ? () {
                    Alert.handle(LakeDrain.drain, context);
                  }
                : null,
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: Text("Drain for £${Game.data.settings.dtlPrice}"),
          ),
        )
      ],
    );
  }
}
