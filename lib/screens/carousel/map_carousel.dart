import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/helpers/icon_helper.dart';
import 'package:plutopoly/helpers/money_helper.dart';
import 'package:plutopoly/screens/game/zoom_map.dart';

import '../../engine/data/map.dart';
import '../../engine/kernel/main.dart';
import '../../widgets/owner_text.dart';
import 'jail_card.dart';
import 'land_card.dart';
import 'players_indicator.dart';
import 'start_card.dart';

class MapCarousel extends StatefulWidget {
  final PageController controller;
  final ScrollController scrollController;

  final bool zoom;
  final bool grid;
  const MapCarousel(
      {Key key,
      @required this.controller,
      this.zoom: false,
      this.grid: true,
      this.scrollController})
      : super(key: key);

  @override
  _MapCarouselState createState() => _MapCarouselState();
}

class _MapCarouselState extends State<MapCarousel> {
  int lastPosition;
  ScrollController scrollController;

  void initState() {
    scrollController = widget.scrollController ?? ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      bool track = MainBloc.prefbox.get("boolTrack", defaultValue: true);
      if (!track) return;
      lastPosition ??= Game.data.player.position;
      if (lastPosition != Game.data.player.position) {
        if (Game.data.ui.shouldMove && widget.controller.hasClients) {
          widget.controller.jumpToPage(Game.data.player.position);
          scrollController?.jumpTo(getPixels(context));
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
          if (scrollController.hasClients) {
            scrollController.animateTo(getPixels(context),
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOutCubic);
          }
        }
        lastPosition = Game.data.player.position;
      }
    });

    final int length = Game.data.gmap.length;

    if (widget.grid)
      return Container(
        height: 500,
        child: SingleChildScrollView(
          controller: scrollController,
          child: ZoomMap(
            full: false,
          ),
        ),
      );

    return PageView.builder(
      scrollDirection: Axis.horizontal,
      controller: widget.controller,
      itemBuilder: (context, index) =>
          buildCard(Game.data.gmap[index % length]),
    );
  }
}

Widget buildCard(Tile tile, {zoom: false}) {
  if (tile == null) return Container();
  switch (tile.type) {
    case TileType.land:
      return LandCard(
        zoom: zoom,
        tile: tile,
      );
    case TileType.start:
      return StartCard(
        tile: tile,
        zoom: zoom,
      );
      break;
    case TileType.jail:
      return JailCard(
        tile: tile,
        zoom: zoom,
      );
      break;
    case TileType.tax:
      return Card(
        color: Color(tile.getBackgroundColor()),
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
                        size: zoom ? 30 : 50),
                    Spacer(),
                    Text(
                      mon(tile.price.abs()),
                      style: TextStyle(
                          color: Colors.white, fontSize: zoom ? 14 : 27),
                    )
                  ],
                ))),
            Expanded(
              child: PlayerIndicators(
                tile: tile,
                zoom: zoom,
              ),
            ),
          ],
        ),
      );
    case TileType.police:
      return Card(
        color: Color(tile.getBackgroundColor()),
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Center(
                    child: FaIcon(FontAwesomeIcons.handPaper,
                        color: Color(tile.color ?? Colors.white.value),
                        size: zoom ? 30 : 50))),
            Expanded(
              child: PlayerIndicators(
                tile: tile,
                zoom: zoom,
              ),
            ),
          ],
        ),
      );
    case TileType.parking:
      return Card(
        color: Color(tile.getBackgroundColor()),
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
                      height: zoom ? 50 : 100,
                      width: zoom ? 50 : 100,
                      child: GameIcon(
                        "coffee",
                      ),
                    ),
                    Spacer(),
                    Text(
                      mon(Game.data.pot) + " ",
                      style: TextStyle(
                          color: Colors.green, fontSize: zoom ? 12 : 25),
                    ),
                    Spacer(),
                  ],
                ))),
            Expanded(
              child: PlayerIndicators(
                tile: tile,
                zoom: zoom,
              ),
            ),
          ],
        ),
      );
    case TileType.company:
      return Card(
        color: Color(tile.getBackgroundColor()),
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
                            size: zoom ? 25 : 50,
                            color: Color(tile.color ?? Colors.orange.value),
                          )
                        : FaIcon(FontAwesomeIcons.faucet,
                            size: zoom ? 25 : 50,
                            color: Color(tile.color ?? Colors.blue.value)),
                    OwnerText(
                      tile: tile,
                      zoom: zoom,
                    ),
                  ],
                )),
            Expanded(
              child: PlayerIndicators(
                tile: tile,
                zoom: zoom,
              ),
            ),
          ],
        ),
      );
    case TileType.chest:
      return Card(
        color: Color(tile.getBackgroundColor()),
        child: Column(
          children: [
            Expanded(
                flex: 2,
                child: Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        height: zoom ? 50 : 100,
                        width: zoom ? 50 : 100,
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
              child: PlayerIndicators(
                tile: tile,
                zoom: zoom,
              ),
            ),
          ],
        ),
      );
    case TileType.chance:
      return Card(
        color: Color(tile.getBackgroundColor()),
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: zoom ? 50 : 100,
                      width: zoom ? 50 : 100,
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
              child: PlayerIndicators(
                tile: tile,
                zoom: zoom,
              ),
            ),
          ],
        ),
      );
    case TileType.trainstation:
      return Card(
        color: Color(tile.getBackgroundColor()),
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.train,
                      size: zoom ? 25 : 50,
                      color: Color(tile.color ?? Colors.black.value),
                    ),
                    OwnerText(
                      tile: tile,
                      zoom: zoom,
                    ),
                  ],
                )),
            Expanded(
              child: PlayerIndicators(
                tile: tile,
                zoom: zoom,
              ),
            ),
          ],
        ),
      );
      break;
    case TileType.action:
      return Card(
        color: Color(tile.getBackgroundColor()),
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Spacer(),
                    if (tile.iconData != null)
                      Icon(
                        mapToIconData(tile.iconData
                            .map((key, value) => MapEntry(key, value))),
                        size: 50,
                        color: Color(tile.color ?? Colors.black.value),
                      ),
                    Spacer(),
                    Text(
                      tile.name ?? "",
                      style: TextStyle(
                          color: Colors.white, fontSize: zoom ? 14 : 27),
                    )
                  ],
                ))),
            Expanded(
              child: PlayerIndicators(
                tile: tile,
                zoom: zoom,
              ),
            ),
          ],
        ),
      );
      break;
  }
  return Card(
    color: Color(tile.backgroundColor ?? Colors.white.value),
    child: PlayerIndicators(
      tile: tile,
      zoom: zoom,
    ),
  );
}

double getPixels(BuildContext context) {
  int confWidth = UIBloc.mapConfiguration.width;
  double heightPerRow =
      min(MediaQuery.of(context).size.width, UIBloc.maxWidth) /
          confWidth *
          (4 / 3);
  return heightPerRow * (Game.data.player.position / confWidth).floor();
}
