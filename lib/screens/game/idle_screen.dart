import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zoom_widget/zoom_widget.dart';

import '../../bloc/main_bloc.dart';
import '../../bloc/ui_bloc.dart';
import '../../engine/data/map.dart';
import '../../engine/data/player.dart';
import '../../engine/kernel/main.dart';
import '../../engine/ui/game_navigator.dart';
import '../../widgets/ad.dart';
import '../../widgets/eager_inkwell.dart';
import '../../widgets/end_of_list.dart';
import '../../widgets/my_card.dart';
import '../../widgets/online_extensions_card.dart';
import '../carousel/map_carousel.dart';
import 'action_screen/info_card.dart';
import 'action_screen/loan_card.dart';
import 'action_screen/stock_card.dart';
import 'property_page.dart';

class IdleScreen extends StatelessWidget {
  final PageController carrouselController;
  IdleScreen(this.carrouselController);

  final NativeAdmobController _admobController = NativeAdmobController();

  void changePos(int index) {
    UIBloc.posOveride = index;
    if (carrouselController.hasClients) {
      carrouselController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    double fraction = 300 / MediaQuery.of(context).size.width;
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

    return ValueListenableBuilder(
        valueListenable: Hive.box(MainBloc.METABOX).listenable(),
        builder: (context, snapshot, _) {
          return ListView(
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
                  : Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        width: UIBloc.maxWidth,
                        child: Center(
                          child: RaisedButton(
                            onPressed: () {
                              GameNavigator.navigate(context);
                            },
                            child: Text(
                              "Your turn",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
              ADView(
                controller: _admobController,
              ),
              Builder(builder: (context) {
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
                        data: Theme.of(context).copyWith(
                            cardTheme: CardTheme(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          color: Colors.white,
                          shape: Border.all(color: Colors.black, width: 0.5),
                        )),
                        child: EagerInkWell(
                          onTap: () {
                            if (tile.buyable) {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return PropertyPage(property: tile);
                              }));
                            } else {
                              changePos(tile.mapIndex);
                            }
                          },
                          child: buildCard(tile),
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
                int width = UIBloc.mapConfiguration.width;
                return MyCard(
                  maxWidth: 900,
                  children: <Widget>[
                    Container(
                      width: size,
                      height: (gridChildren.length / pow(width.toDouble(), 2)) *
                          size *
                          (4 / 3),
                      child:
                          BoardZoom(width: width, gridChildren: gridChildren),
                    ),
                    ListTile(
                      title: Text("Map configuration:"),
                      trailing: DropdownButton(
                          value: Hive.box(MainBloc.METABOX)
                              .get("mapConfiguration"),
                          items: mapConfItems,
                          onChanged: (val) {
                            Hive.box(MainBloc.METABOX)
                                .put("mapConfiguration", val);
                          }),
                    )
                  ],
                );
              }),
              InfoCard(
                iplayer: UIBloc.gamePlayer,
                short: false,
              ),
              StockCard(),
              LoanCard(),
              OnlineExtensionsCard(),
              ADView(large: true, controller: _admobController),
              EndOfList()
            ],
          );
        });
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
      initZoom: 0,
      canvasColor: Theme.of(context).canvasColor,
      enableScroll: true,
      width: (width.toDouble() * 250),
      height: (gridChildren.length / width.toDouble()) * 250 * (4 / 3),
      backgroundColor: Colors.black,
      child: buildGrid(),
    );
  }

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
