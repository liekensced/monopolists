import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../engine/data/map.dart';
import 'players_indicator.dart';

class StartCard extends StatelessWidget {
  final Tile tile;
  final bool zoom;
  const StartCard({
    Key key,
    @required this.zoom,
    @required this.tile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(tile.backgroundColor ?? Colors.white.value),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.all(zoom ? 5 : 10),
              child: Text("Start",
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(color: Colors.black, fontSize: zoom ? 15 : 40)),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: FaIcon(
              FontAwesomeIcons.arrowRight,
              size: zoom ? 20 : 40,
              color: Colors.black,
            ),
          ),
          PlayerIndicators(
            tile: tile,
            zoom: zoom,
          )
        ],
      ),
    );
  }
}
