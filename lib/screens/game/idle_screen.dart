import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plutopoly/bloc/ad_bloc.dart';

import '../../bloc/main_bloc.dart';
import '../../bloc/ui_bloc.dart';
import '../../engine/ai/ai_type.dart';
import '../../engine/data/player.dart';
import '../../engine/data/ui_actions.dart';
import '../../engine/kernel/main.dart';
import '../../widgets/ad.dart';
import '../../widgets/end_of_list.dart';
import '../../widgets/my_card.dart';
import '../../widgets/online_extensions_card.dart';
import 'action_screen/action_screen.dart';
import 'action_screen/info_card.dart';
import 'action_screen/loan_card.dart';
import 'action_screen/stock_card.dart';
import 'idle_settings.dart';
import 'zoom_map.dart';

class IdleScreen extends StatelessWidget {
  final PageController carrouselController;
  IdleScreen(this.carrouselController);

  final NativeAdmobController _admobController = AdBloc.idleAdController;

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
        case Screen.parlement:
          return "parlement";
          break;
      }
    }
    if (p.ai.type == AIType.normal) {
      return "Bot";
    }
    return "";
  }

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
                              only: true,
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
              Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: UIBloc.maxWidth),
                  child: ADView(
                    controller: _admobController,
                  ),
                ),
              ),
              ZoomMap(
                carrouselController: carrouselController,
              ),
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
