import 'package:flutter/material.dart';
import 'package:plutopoly/helpers/money_helper.dart';
import 'package:plutopoly/widgets/owner_text.dart';

import '../../engine/data/map.dart';
import 'players_indicator.dart';

class LandCard extends StatelessWidget {
  final Tile tile;
  final bool zoom;
  const LandCard({
    Key key,
    this.zoom = false,
    @required this.tile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(tile.backgroundColor ?? Colors.white.value),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color:
                    Color(tile.color ?? Theme.of(context).primaryColor.value),
                boxShadow: zoom
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
              ),
              child: Container(
                alignment: Alignment.bottomCenter,
                padding:
                    EdgeInsets.only(bottom: zoom ? 5 : 10, right: 5, left: 5),
                child: Text(
                  tile.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: zoom ? 10 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
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
                        margin: EdgeInsets.all(zoom ? 6 : 12),
                        color: Colors.red,
                        padding: EdgeInsets.all(zoom ? 1 : 3),
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(zoom ? 1 : 2),
                          child: Container(
                            padding: EdgeInsets.all(zoom ? 3 : 6),
                            color: Colors.red,
                            child: Text(
                              "For Sale",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: zoom ? 10 : 20),
                            ),
                          ),
                        ),
                      )
                    : OwnerText(
                        tile: tile,
                        zoom: zoom,
                      ),
                Expanded(
                    child: Center(
                  child: Text(
                    "${mon(tile.owner == null ? tile.price : tile.currentRent)}",
                    style: TextStyle(
                        color: tile.owner == null ? Colors.green : Colors.red,
                        fontSize: zoom ? 7 : 14,
                        fontWeight: FontWeight.bold),
                  ),
                )),
                Expanded(
                  child: Align(
                    child: PlayerIndicators(
                      zoom: zoom,
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
