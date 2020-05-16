import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plutopoly/engine/ai/ai_type.dart';
import 'package:plutopoly/engine/data/ui_actions.dart';
import 'package:plutopoly/screens/game/action_screen/action_screen.dart';
import 'package:zoom_widget/zoom_widget.dart';

import '../../bloc/main_bloc.dart';
import '../../bloc/ui_bloc.dart';
import '../../engine/data/map.dart';
import '../../engine/data/player.dart';
import '../../engine/kernel/main.dart';
import '../../widgets/ad.dart';
import '../../widgets/eager_inkwell.dart';
import '../../widgets/end_of_list.dart';
import '../../widgets/my_card.dart';
import '../../widgets/online_extensions_card.dart';
import '../carousel/map_carousel.dart';
import 'action_screen/info_card.dart';
import 'action_screen/loan_card.dart';
import 'action_screen/stock_card.dart';
import 'idle_settings.dart';
import 'property_page.dart';

class IdleScreen extends StatelessWidget {
  final PageController carrouselController;
  IdleScreen(this.carrouselController);

  final NativeAdmobController _admobController =
      kIsWeb ? null : NativeAdmobController();

  void changePos(int index) {
    UIBloc.posOveride = index;
    if (carrouselController.hasClients) {
      carrouselController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
    }
  }

  String getText(Player p) {
    int dealer = Game.data.dealData?.dealer;
    if (dealer != null) {
      if (Game.data.player == p) {
        return "Dealing with " + Game.data.players[dealer].name;
      }
      if (p.index == dealer) {
        return "Dealing with " + Game.data.player.name;
      }
    }
    if (Game.data.player == p) {
      switch (Game.data.ui.screenState) {
        case Screen.idle:
          return "On idle screen";
          break;
        case Screen.move:
          return "Rolling dices";
          break;
        case Screen.active:
          if (p.jailed) {
            return "Jailed";
          }
          List<int> dices = Game.data.currentDices;
          if ((dices[0] ?? -1) > 0 && (dices[1] ?? -1) > 0) {
            return "Threw ${dices[0]} and ${dices[1]}";
          }
          break;
      }
    }
    if (p.ai.type == AIType.normal) {
      return "Bot";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    double fraction = 300 / MediaQuery.of(context).size.width;
    PageController playersController =
        PageController(viewportFraction: fraction);
    List<Widget> listItems = [];
    Game.data.players.forEach((Player p) {
      listItems.add(InkWell(
        splashColor: Theme.of(context).primaryColor,
        onTap: () {
          changePos(p.position);
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: MyCard(
            listen: true,
            title: p.name,
            smallTitle: true,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          scrollable: true,
                          title: Text(p.name + " holdings:"),
                          content: Container(
                            width: min(MediaQuery.of(context).size.width * 0.9,
                                UIBloc.maxWidth),
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: HoldingCards(
                              properties: p.properties,
                            ),
                          ),
                          actions: [
                            MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "close",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ))
                          ]);
                    },
                  );
                },
                child: ListTile(
                  title: Text("Money: " + p.money.floor().toString()),
                  subtitle:
                      Text("Properties: " + p.properties.length.toString()),
                  trailing: Icon(
                    Icons.visibility,
                  ),
                ),
              ),
              Text(
                getText(p),
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ],
          ),
        ),
      ));
    });

    return ValueListenableBuilder(
        valueListenable: Hive.box(MainBloc.METABOX).listenable(),
        builder: (context, snapshot, _) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(height: 10),
              Container(
                height: 200,
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
              buildIdleActionCard(context),
              Container(
                constraints: BoxConstraints(maxWidth: UIBloc.maxWidth),
                child: ADView(
                  controller: _admobController,
                ),
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
              IdleSettings(),
              OnlineExtensionsCard(),
              ADView(large: true, controller: _admobController),
              EndOfList()
            ],
          );
        });
  }

  Widget buildIdleActionCard(BuildContext context) {
    if (!Game.ui.idle) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          width: UIBloc.maxWidth,
          child: Center(
            child: RaisedButton(
              onPressed: () {
                UIBloc.changeScreen(Screen.move);
                Game.save(only: ["ui"]);
              },
              child: Text(
                "Your turn",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }
    if (UIBloc.gamePlayer.properties.contains(Game.data.player.position) &&
        Game.data.ui.screenState == Screen.active) {
      return MyCard(
        children: [
          ListTile(
            title: Text(Game.data.player.name + " is on your property."),
            trailing: Game.data.rentPayed
                ? Text(
                    "rent payed",
                    style: TextStyle(color: Colors.red),
                  )
                : RaisedButton(
                    child: Text("Forgive rent"),
                    color: Colors.red,
                    textColor: Colors.white,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              title: Text("Forgive rent"),
                              content: Text(
                                  "Are you sure you want to forgive the rent. You will not receive any money."),
                              actions: [
                                MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "close",
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    )),
                                MaterialButton(
                                    onPressed: () {
                                      Game.data.rentPayed = true;
                                      Game.save(only: ["rentPayed"]);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "yes",
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ))
                              ]);
                        },
                      );
                    },
                  ),
          )
        ],
      );
    }
    return MyCard(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(child: Text("You are idle...")),
        )
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
