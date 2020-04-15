import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plutopoly/engine/ui/game_navigator.dart';
import 'package:plutopoly/widgets/eager_inkwell.dart';
import 'package:plutopoly/widgets/my_card.dart';
import 'package:zoom_widget/zoom_widget.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/data/map.dart';
import '../../engine/data/player.dart';
import '../../engine/kernel/main.dart';
import '../carousel/map_carousel.dart';

class IdleScreen extends StatelessWidget {
  final PageController carrouselController;
  IdleScreen(this.carrouselController);

  void changePos(int index) {
    MainBloc.posOveride = index;
    if (carrouselController.hasClients) {
      carrouselController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    double fraction = 400 / MediaQuery.of(context).size.width;
    PageController playersController =
        PageController(viewportFraction: fraction);
    List<Widget> listItems = [];
    Game.data.players.forEach((Player p) {
      listItems.add(MyCard(
        onTap: () => changePos(p.position),
        listen: true,
        title: p.name,
        smallTitle: true,
        children: [
          Text("Money: " + p.money.floor().toString()),
          Text("Properties: " + p.properties.length.toString()),
        ],
      ));
    });

    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Container(
          height: 150,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: playersController,
            itemCount: listItems.length,
            itemBuilder: (context, index) => listItems[index],
          ),
        ),
        Container(
          height: 5,
        ),
        Game.ui.idle
            ? MyCard(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(child: Text("You are idle...")),
                  )
                ],
              )
            : RaisedButton(
                child: Container(
                  width: double.maxFinite,
                  child: Text(
                    "Your turn",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  GameNavigator.navigate(context);
                },
              ),
        Builder(builder: (context) {
          List<Tile> gmap = Game.data.gmap;
          List<Widget> gridChildren = [];
          MainBloc.mapConfiguration.configuration.forEach((int tileIndex) {
            if (0 > tileIndex) {
              gridChildren.add(Container());
              return;
            }
            if (tileIndex <= gmap.length - 1) {
              Tile tile = gmap[tileIndex];
              gridChildren.add(
                Theme(
                  data: Theme.of(context).copyWith(
                      cardTheme: CardTheme(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    color: Colors.white,
                    shape: Border.all(color: Colors.black, width: 1),
                  )),
                  child: EagerInkWell(
                    onTap: () {
                      changePos(tile.index);
                    },
                    child: buildCard(tile, context, tileIndex),
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

          double size = min(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height);
          int width = MainBloc.mapConfiguration.width;
          return ValueListenableBuilder(
              valueListenable: Hive.box(MainBloc.PREFBOX).listenable(),
              builder: (context, Box box, _) {
                return MyCard(
                  maxWidth: 900,
                  children: <Widget>[
                    Container(
                      width: size,
                      height: (gridChildren.length / pow(width.toDouble(), 2)) *
                          size,
                      child:
                          BoardZoom(width: width, gridChildren: gridChildren),
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
                );
              });
        }),
      ],
    );
  }
}

class BoardZoom extends StatelessWidget {
  const BoardZoom({
    Key key,
    @required this.width,
    @required this.gridChildren,
  }) : super(key: key);

  final int width;
  final List<Widget> gridChildren;

  @override
  Widget build(BuildContext context) {
    return Zoom(
      onScaleUpdate: (d, dd) {
        print(d);
      },
      initZoom: 0,
      canvasColor: Theme.of(context).canvasColor,
      enableScroll: true,
      width: (width.toDouble() * 250),
      height: (gridChildren.length / width.toDouble()) * 250,
      backgroundColor: Colors.black,
      child: buildGrid(),
    );
  }

  GridView buildGrid() {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: width,
      children: gridChildren,
    );
  }
}
