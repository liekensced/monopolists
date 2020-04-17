import 'package:flutter/material.dart';
import '../engine/data/map.dart';

class OwnerText extends StatelessWidget {
  final Tile tile;

  const OwnerText({Key key, @required this.tile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (tile.owner == null) return Container();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
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
    );
  }
}
