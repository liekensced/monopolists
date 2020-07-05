import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/helpers/icon_helper.dart';
import 'package:plutopoly/helpers/money_helper.dart';

import '../../engine/data/map.dart';
import '../../engine/kernel/main.dart';
import '../../widgets/owner_text.dart';
import 'jail_card.dart';
import 'land_card.dart';
import 'players_indicator.dart';
import 'start_card.dart';

class MapCarousel extends StatefulWidget {
  final PageController controller;
  final bool zoom;

  const MapCarousel({Key key, @required this.controller, this.zoom: false})
      : super(key: key);

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
    Future.delayed(Duration.zero, () {
      bool track = MainBloc.prefbox.get("boolTrack", defaultValue: true);
      if (!track) return;
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

    final int length = Game.data.gmap.length;

    return PageView.builder(
      scrollDirection: Axis.horizontal,
      controller: widget.controller,
      itemBuilder: (context, index) =>
          buildCard(Game.data.gmap[index % length]),
    );
  }
}

Widget buildCard(Tile tile, {zoom: false}) {
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
                      mon(tile.price.abs()),
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
                    Container(
                      height: 100,
                      width: 100,
                      child: GameIcon("coffee"),
                    ),
                    Spacer(),
                    Text(
                      mon(Game.data.pot) + " ",
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
          children: [
            Expanded(
                flex: 2,
                child: Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        height: 100,
                        width: 100,
                        child: GameIcon(
                          "gem",
                          color: tile.color ?? Colors.white.value,
                        )),
                    tile.name == null
                        ? Container()
                        : Text(
                            tile.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )
                  ],
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
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: GameIcon(
                        "question",
                        color: tile.color ?? Colors.white.value,
                      ),
                    ),
                    tile.name == null
                        ? Container()
                        : Text(
                            tile.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )
                  ],
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
