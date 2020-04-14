import 'package:flutter/material.dart';

import '../../engine/data/map.dart';
import 'players_indicator.dart';

class LandCard extends StatelessWidget {
  final Tile tile;
  const LandCard({
    Key key,
    @required this.tile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(tile.color),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Container(
                width: 250,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  tile.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: <Widget>[
                tile.owner == null
                    ? Container(
                        margin: EdgeInsets.all(12),
                        color: Colors.red,
                        padding: EdgeInsets.all(3),
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(2),
                          child: Container(
                            padding: EdgeInsets.all(6),
                            color: Colors.red,
                            child: Text(
                              "For Sale",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Expanded(
                    child: Center(
                  child: Text("£" + tile.price.toString()),
                )),
                Expanded(
                  child: Align(
                    child: PlayerIndicators(
                      tile: tile,
                    ),
                    alignment: Alignment.bottomLeft,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
