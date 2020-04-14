import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zoom_widget/zoom_widget.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/data/map.dart';
import '../../engine/data/player.dart';
import '../../engine/kernel/main.dart';
import '../carousel/map_carousel.dart';

class IdleScreen extends StatelessWidget {
  final PageController carrouselController;
  IdleScreen(this.carrouselController);
  @override
  Widget build(BuildContext context) {
    double fraction = 200 / MediaQuery.of(context).size.width;
    PageController playersController =
        PageController(viewportFraction: fraction);
    List<Widget> listItems = [];
    Game.data.players.forEach((Player p) {
      listItems.add(Card(
          child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: Text(
              p.name,
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.start,
            ),
          ),
          Text("Money: " + p.money.floor().toString()),
          Text("Properties: " + p.properties.length.toString()),
        ],
      )));
    });

    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Container(
          height: 10,
        ),
        Container(
          height: 150,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: playersController,
            itemCount: listItems.length,
            itemBuilder: (context, index) => listItems[index],
          ),
        ),
        Card(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(child: Text("You are idle...")),
        )),
        GameListener(builder: (context, __, _) {
          List<Tile> gmap = Game.data.gmap;
          List<Widget> gridChildren = [];
          MainBloc.mapConfiguration.configuration.forEach((int tileIndex) {
            if (0 > tileIndex) {
              gridChildren.add(Container());
              return;
            }
            if (tileIndex <= gmap.length - 1) {
              Tile tile = gmap[tileIndex];
              gridChildren.add(Theme(
                data: Theme.of(context).copyWith(
                    cardTheme: CardTheme(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  color: Colors.white,
                  shape: Border.all(color: Colors.black, width: 1),
                )),
                child: InkWell(
                  onTap: () {
                    MainBloc.posOveride = tile.index;
                    carrouselController.animateToPage(tile.index,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOutCubic);
                  },
                  child: buildCard(tile, context, tileIndex),
                ),
              ));
            }
          });

          List<DropdownMenuItem> mapConfItems = [];
          Hive.box(MainBloc.MAPCONFBOX).toMap().forEach((key, _) {
            mapConfItems.add(DropdownMenuItem(
              child: Text(key),
              value: key,
            ));
          });

          double size = min(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height);
          int width = MainBloc.mapConfiguration.width;
          return ValueListenableBuilder(
              valueListenable: Hive.box(MainBloc.PREFBOX).listenable(),
              builder: (context, Box box, _) {
                return Card(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: size,
                        height:
                            (gridChildren.length / pow(width.toDouble(), 2)) *
                                size,
                        child: Zoom(
                          onScaleUpdate: (d, dd) {
                            print(d);
                          },
                          canvasColor: Theme.of(context).canvasColor,
                          enableScroll: true,
                          width: width.toDouble() * 250,
                          height:
                              (gridChildren.length / width.toDouble()) * 250,
                          backgroundColor: Colors.black,
                          child: GridView.count(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: width,
                            children: gridChildren,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text("Map configuration:"),
                        trailing: DropdownButton(
                            value: Hive.box(MainBloc.PREFBOX)
                                .get("mapConfiguration"),
                            items: mapConfItems,
                            onChanged: (val) {
                              Hive.box(MainBloc.PREFBOX)
                                  .put("mapConfiguration", val);
                            }),
                      )
                    ],
                  ),
                );
              });
        }),
      ],
    );
  }
}
