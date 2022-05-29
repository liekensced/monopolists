import 'package:flutter/material.dart';

import '../../engine/data/map.dart';
import 'players_indicator.dart';

class JailCard extends StatelessWidget {
  final Tile tile;
  final bool zoom;
  const JailCard({
    Key key,
    @required this.zoom,
    @required this.tile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(tile.backgroundColor ?? Colors.white.value),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              color: Color(tile.color ?? Colors.orange.value),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "PRISON",
                    style: TextStyle(
                        color: Colors.white, fontSize: zoom ? 20 : 40),
                  ),
                  Container(
                    height: 10,
                  ),
                  PlayerIndicators(
                    tile: tile,
                    jailed: true,
                    zoom: zoom,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: PlayerIndicators(
              tile: tile,
              zoom: zoom,
            ),
          )
        ],
      ),
    );
  }
}
