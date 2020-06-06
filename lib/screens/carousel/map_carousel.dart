import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../engine/data/map.dart';
import '../../engine/kernel/main.dart';
import '../../widgets/owner_text.dart';
import 'jail_card.dart';
import 'land_card.dart';
import 'players_indicator.dart';
import 'start_card.dart';

class MapCarousel extends StatefulWidget {
  final PageController controller;

  const MapCarousel({Key key, @required this.controller}) : super(key: key);

  @override
  _MapCarouselState createState() => _MapCarouselState();
}

class _MapCarouselState extends State<MapCarousel> {
  void initState() {
    super.initState();
  }

  int lastPosition;

  @override
  Widget build(BuildContext context) {
    List<Widget> listItems = [];
    for (int i = 0; i < Game.data.gmap.length; i++) {
      listItems.add(buildCard(Game.data.gmap[i]));
    }

    Future.delayed(Duration.zero, () {
      lastPosition ??= Game.data.player.position;
      if (lastPosition != Game.data.player.position) {
        if (Game.data.ui.shouldMove && widget.controller.hasClients) {
          widget.controller.jumpToPage(Game.data.player.position);
        } else {
          int position2 = Game.data.player.position;
          if (lastPosition > position2) {
            position2 += Game.data.gmap.length;
          }
          if (widget.controller.hasClients) {
            widget.controller.animateToPage(position2,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOutCubic);
          }
        }
        lastPosition = Game.data.player.position;
      }
    });

    return PageView.builder(
      scrollDirection: Axis.horizontal,
      controller: widget.controller,
      itemBuilder: (context, index) => listItems[index % listItems.length],
    );
  }
}

Widget buildCard(Tile tile, {zoom: false}) {
  switch (tile.type) {
    case TileType.land:
      return LandCard(
        tile: tile,
        zoom: zoom,
      );
    case TileType.start:
      return StartCard(tile: tile);
      break;
    case TileType.jail:
      return JailCard(tile: tile);
      break;
    case TileType.tax:
      return Card(
        color: Color(tile.backgroundColor ??
            (tile.price < 0 ? Colors.green.value : Colors.orange.value)),
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Spacer(),
                    FaIcon(FontAwesomeIcons.handHoldingUsd,
                        color: Color(tile.color ?? Colors.white.value),
                        size: 50),
                    Spacer(),
                    Text(
                      "£" + tile.price.abs().toString(),
                      style: TextStyle(color: Colors.white, fontSize: 27),
                    )
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
        color: Color(tile.backgroundColor ?? Colors.blue[900].value),
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Center(
                    child: FaIcon(FontAwesomeIcons.handPaper,
                        color: Color(tile.color ?? Colors.white.value),
                        size: 50))),
            Expanded(
              child: PlayerIndicators(tile: tile),
            ),
          ],
        ),
      );
    case TileType.parking:
      return Card(
        color: Color(tile.backgroundColor ?? Colors.white.value),
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Spacer(),
                    FaIcon(FontAwesomeIcons.mugHot,
                        color: Color(tile.color ?? Colors.brown.value),
                        size: 50),
                    Spacer(),
                    Text(
                      "£" + Game.data.pot.floor().toString() + " ",
                      style: TextStyle(color: Colors.green, fontSize: 25),
                    ),
                    Spacer(),
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
        color: Color(tile.backgroundColor ?? Colors.white.value),
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    tile.icon == "bolt"
                        ? FaIcon(
                            FontAwesomeIcons.bolt,
                            size: 50,
                            color: Color(tile.color ?? Colors.orange.value),
                          )
                        : FaIcon(FontAwesomeIcons.faucet,
                            size: 50,
                            color: Color(tile.color ?? Colors.blue.value)),
                    OwnerText(tile: tile),
                  ],
                )),
            Expanded(
              child: PlayerIndicators(tile: tile),
            ),
          ],
        ),
      );
    case TileType.chest:
      return Card(
        color: Color(tile.backgroundColor ?? Colors.cyan.value),
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Center(
                    child: FaIcon(
                  FontAwesomeIcons.solidGem,
                  size: 50,
                  color: Color(tile.color ?? Colors.white.value),
                ))),
            Expanded(
              child: PlayerIndicators(tile: tile),
            ),
          ],
        ),
      );
    case TileType.chance:
      return Card(
        color: Color(tile.backgroundColor ?? Colors.red.value),
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Center(
                    child: FaIcon(
                  FontAwesomeIcons.question,
                  size: 50,
                  color: Color(tile.color ?? Colors.white.value),
                ))),
            Expanded(
              child: PlayerIndicators(tile: tile),
            ),
          ],
        ),
      );
    case TileType.trainstation:
      return Card(
        color: Color(tile.backgroundColor ?? Colors.white.value),
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.train,
                      size: 50,
                      color: Color(tile.color ?? Colors.black.value),
                    ),
                    OwnerText(tile: tile),
                  ],
                )),
            Expanded(
              child: PlayerIndicators(tile: tile),
            ),
          ],
        ),
      );
      break;
    default:
      return Card(
        color: Color(tile.backgroundColor ?? Colors.white.value),
        child: PlayerIndicators(
          tile: tile,
        ),
      );
  }
}
