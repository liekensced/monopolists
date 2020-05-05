import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../engine/data/map.dart';
import 'players_indicator.dart';

class StartCard extends StatelessWidget {
  final Tile tile;
  const StartCard({
    Key key,
    @required this.tile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text("Start",
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(color: Colors.black)),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: FaIcon(
              FontAwesomeIcons.arrowRight,
              size: 40,
              color: Colors.black,
            ),
          ),
          PlayerIndicators(
            tile: tile,
          )
        ],
      ),
    );
  }
}
