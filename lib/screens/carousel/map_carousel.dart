import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (UIBloc.posOveride != null)
        widget.controller.jumpToPage(UIBloc.posOveride);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listItems = [];
    for (int i = 0; i < Game.data.gmap.length; i++) {
      listItems.add(buildCard(Game.data.gmap[i]));
    }

    return PageView.builder(
      scrollDirection: Axis.horizontal,
      controller: widget.controller,
      itemBuilder: (context, index) => listItems[index % listItems.length],
    );
  }
}

Widget buildCard(Tile tile) {
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
                    Spacer(),
                    FaIcon(FontAwesomeIcons.handHoldingUsd,
                        color: Colors.orange, size: 50),
                    Spacer(),
                    Text(
                      "£" + tile.price.toString(),
                      style: TextStyle(color: Colors.black),
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
                    Spacer(),
                    FaIcon(FontAwesomeIcons.mugHot,
                        color: Colors.brown, size: 50),
                    Spacer(),
                    Text(
                      "£" + Game.data.pot.floor().toString() + " ",
                      style: TextStyle(color: Colors.green),
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
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    tile.idIndex == 1
                        ? FaIcon(
                            FontAwesomeIcons.bolt,
                            size: 50,
                            color: Colors.orange,
                          )
                        : FaIcon(FontAwesomeIcons.faucet,
                            size: 50, color: Colors.blue),
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
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.train,
                      size: 50,
                      color: Colors.black,
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
        child: PlayerIndicators(
          tile: tile,
        ),
      );
  }
}
