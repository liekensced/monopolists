import 'package:flutter/material.dart';
import 'package:plutopoly/widgets/houses.dart';
import '../engine/data/map.dart';

class OwnerText extends StatelessWidget {
  final Tile tile;
  final bool zoom;

  const OwnerText({Key key, @required this.tile, this.zoom: false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (tile.owner == null) return Container();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(zoom ? 4 : 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: zoom ? 15 : 40,
                child: Houses(amount: tile.level),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Owner: ",
                    style:
                        TextStyle(color: Colors.black, fontSize: zoom ? 9 : 18),
                  ),
                  Text(tile.owner.name,
                      style: TextStyle(
                          color: Color(tile.owner.color),
                          fontWeight: FontWeight.bold,
                          fontSize: zoom ? 10 : 20)),
                ],
              ),
              Container(height: 2),
              tile.mortaged
                  ? Text(
                      "(mortaged)",
                      style: TextStyle(
                          color: Colors.grey, fontSize: zoom ? 7 : 14),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}
