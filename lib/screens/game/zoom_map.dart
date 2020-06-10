import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoom_widget/zoom_widget.dart';

import '../../bloc/main_bloc.dart';
import '../../bloc/ui_bloc.dart';
import '../../engine/data/map.dart';
import '../../engine/kernel/main.dart';
import '../../widgets/eager_inkwell.dart';
import '../../widgets/my_card.dart';
import '../carousel/map_carousel.dart';
import 'property_page.dart';

class ZoomMap extends StatelessWidget {
  final PageController carrouselController;
  final bool studio;

  const ZoomMap({Key key, this.carrouselController, this.studio: false})
      : super(key: key);
  void changePos(int index) {
    if (carrouselController == null) return;
    if (carrouselController.hasClients) {
      carrouselController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Tile> gmap = Game.data.gmap;
    List<Widget> gridChildren = [];
    UIBloc.mapConfiguration.configuration.forEach((int tileIndex) {
      if (0 > tileIndex) {
        gridChildren.add(Container());
        return;
      }
      if (tileIndex <= gmap.length - 1) {
        Tile tile = gmap[tileIndex];
        gridChildren.add(
          Theme(
            data: tile.tableColor != null
                ? Theme.of(context).copyWith(
                    cardTheme: CardTheme(
                      color: Color(tile.backgroundColor ?? Colors.white.value),
                      margin: const EdgeInsets.all(20),
                    ),
                    canvasColor: Colors.white,
                  )
                : Theme.of(context).copyWith(
                    cardTheme: CardTheme(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    color: Color(tile.backgroundColor ?? Colors.white.value),
                    shape: Border.all(color: Colors.black, width: 0.5),
                  )),
            child: EagerInkWell(
              onTap: () {
                if (tile.buyable) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return PropertyPage(property: tile);
                  }));
                } else {
                  changePos(tile.mapIndex);
                }
              },
              child: Container(
                color: Color(tile.tableColor ?? 0),
                child: buildCard(tile, zoom: true),
              ),
            ),
          ),
        );
      }
    });

    List<DropdownMenuItem> mapConfItems = [];
    Hive.box(MainBloc.MAPCONFBOX).toMap().forEach((key, _) {
      mapConfItems.add(DropdownMenuItem(
        child: Text(key),
        value: key,
      ));
    });

    double size = MediaQuery.of(context).size.width;
    int width = UIBloc.mapConfiguration.width;
    double heigth = size *
        (4 / 3) *
        ((((gridChildren.length / width.toDouble()).ceil() /
            width.toDouble())));
    if (UIBloc.isWide(context)) {
      heigth = min(MediaQuery.of(context).size.height, heigth);
    }
    return Padding(
      padding: UIBloc.isWide(context)
          ? const EdgeInsets.symmetric(horizontal: 20.0)
          : const EdgeInsets.all(0),
      child: MyCard(
        maxWidth: 1500,
        children: <Widget>[
          Container(
            width: size,
            height: heigth,
            child: BoardZoom(
                width: width, gridChildren: gridChildren, heigth: heigth),
          ),
          ListTile(
            title: Text("Map configuration:"),
            trailing: DropdownButton(
                value: Hive.box(MainBloc.METABOX).get("mapConfiguration"),
                items: mapConfItems,
                onChanged: (val) {
                  Hive.box(MainBloc.METABOX).put("mapConfiguration", val);
                }),
          )
        ],
      ),
    );
  }
}

class BoardZoom extends StatelessWidget {
  const BoardZoom({
    Key key,
    @required this.width,
    @required this.gridChildren,
    @required this.heigth,
  }) : super(key: key);
  final double heigth;

  final int width;
  final List<Widget> gridChildren;

  @override
  Widget build(BuildContext context) {
    return Zoom(
      initZoom: 0,
      canvasColor: Colors.white,
      enableScroll: true,
      width: (width.toDouble() * 250),
      height: (rows * 250 * (4 / 3)),
      backgroundColor: Colors.black,
      child: buildGrid(),
    );
  }

  int get rows => ((gridChildren.length / width.toDouble()).ceil());

  GridView buildGrid() {
    return GridView.count(
      padding: EdgeInsets.zero,
      childAspectRatio: 3 / 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: width,
      children: gridChildren,
    );
  }
}