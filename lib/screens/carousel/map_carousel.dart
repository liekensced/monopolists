import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../engine/data/map.dart';
import '../../engine/kernel/main.dart';
import 'jail_card.dart';
import 'land_card.dart';
import 'players_indicator.dart';
import 'start_card.dart';

class MapCarousel extends StatelessWidget {
  final PageController controller;

  const MapCarousel({Key key, @required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Widget> listItems = [];
    for (int i = 0; i < Game.data.gmap.length; i++) {
      listItems.add(buildCard(Game.data.gmap[i], context, i));
    }

    return PageView.builder(
      scrollDirection: Axis.horizontal,
      controller: controller,
      itemBuilder: (context, index) => listItems[index % listItems.length],
    );
  }

  Widget buildCard(Tile tile, BuildContext context, int index) {
    switch (tile.type) {
      case TileType.land:
        return LandCard(
          tile: tile,
        );
      case TileType.start:
        return StartCard(tile: tile);
        break;
      case TileType.jail:
        return JailCard(tile: tile);
        break;
      case TileType.tax:
        return Card(
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(height: 20),
                      FaIcon(FontAwesomeIcons.handHoldingUsd,
                          color: Colors.orange, size: 50),
                      Container(height: 20),
                      Text("£" + tile.price.toString())
                    ],
                  ))),
              Expanded(
                child: PlayerIndicators(tile: tile),
              ),
            ],
          ),
        );
      case TileType.police:
        return Card(
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Center(
                      child: FaIcon(FontAwesomeIcons.handPaper,
                          color: Colors.blue, size: 50))),
              Expanded(
                child: PlayerIndicators(tile: tile),
              ),
            ],
          ),
        );
      case TileType.parking:
        return Card(
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(height: 20),
                      FaIcon(FontAwesomeIcons.mugHot,
                          color: Colors.brown, size: 50),
                      Container(height: 20),
                      Text(
                        "£" + Game.data.pot.floor().toString() + " ",
                        style: TextStyle(color: Colors.green),
                      )
                    ],
                  ))),
              Expanded(
                child: PlayerIndicators(tile: tile),
              ),
            ],
          ),
        );
      case TileType.company:
        return Card(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Center(
                    child: tile.idIndex == 1
                        ? FaIcon(
                            FontAwesomeIcons.bolt,
                            size: 50,
                            color: Colors.orange,
                          )
                        : FaIcon(FontAwesomeIcons.faucet,
                            size: 50, color: Colors.blue)),
              ),
              Expanded(
                child: PlayerIndicators(tile: tile),
              ),
            ],
          ),
        );
      case TileType.chest:
        return Card(
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Center(
                      child: FaIcon(
                    FontAwesomeIcons.solidGem,
                    size: 50,
                    color: Colors.cyan,
                  ))),
              Expanded(
                child: PlayerIndicators(tile: tile),
              ),
            ],
          ),
        );
      case TileType.chance:
        return Card(
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Center(
                      child: FaIcon(
                    FontAwesomeIcons.question,
                    size: 50,
                    color: Colors.red,
                  ))),
              Expanded(
                child: PlayerIndicators(tile: tile),
              ),
            ],
          ),
        );
      case TileType.trainstation:
        return Card(
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 2, child: Center(child: Icon(Icons.train, size: 50))),
              Expanded(
                child: PlayerIndicators(tile: tile),
              ),
            ],
          ),
        );
        break;
      default:
        return Card(
          child: PlayerIndicators(
            tile: tile,
          ),
        );
    }
  }
}
