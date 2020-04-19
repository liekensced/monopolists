import 'package:flutter/material.dart';
import 'package:plutopoly/widgets/houses.dart';
import '../engine/data/map.dart';

class OwnerText extends StatelessWidget {
  final Tile tile;

  const OwnerText({Key key, @required this.tile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (tile.owner == null) return Container();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 40,
                child: Houses(amount: tile.level),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Owner: ",
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(tile.owner.name,
                      style: TextStyle(
                          color: Color(tile.owner.color),
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Container(height: 2),
              tile.mortaged
                  ? Text(
                      "(mortaged)",
                      style: TextStyle(color: Colors.grey),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}