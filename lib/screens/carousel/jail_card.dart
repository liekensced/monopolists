import 'package:flutter/material.dart';

import '../../engine/data/map.dart';
import 'players_indicator.dart';

class JailCard extends StatelessWidget {
  final Tile tile;
  const JailCard({
    Key key,
    @required this.tile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.orange,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "PRISON",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  Container(
                    height: 10,
                  ),
                  PlayerIndicators(
                    tile: tile,
                    jailed: true,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: PlayerIndicators(
              tile: tile,
            ),
          )
        ],
      ),
    );
  }
}
