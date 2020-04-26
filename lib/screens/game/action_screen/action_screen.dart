import 'package:flutter/material.dart';
import 'package:plutopoly/engine/data/extensions.dart';
import 'package:plutopoly/engine/data/main.dart';
import 'package:plutopoly/engine/data/map.dart';
import 'package:plutopoly/screens/game/action_screen/stock_card.dart';

import '../../../bloc/main_bloc.dart';
import '../../../engine/data/player.dart';
import '../../../engine/kernel/main.dart';
import '../../../engine/ui/alert.dart';
import '../../../engine/ui/game_navigator.dart';
import '../../../widgets/animated_count.dart';
import '../../../widgets/end_of_list.dart';
import '../../../widgets/slide_fab.dart';
import '../../actions.dart/actions.dart';
import '../../actions.dart/money_card.dart';
import '../../actions.dart/property_action_card.dart';
import '../../carousel/map_carousel.dart';
import '../deal_screen.dart';
import '../idle_screen.dart';
import 'bottom_sheet.dart';
import 'default_card.dart';
import 'info_card.dart';
import 'loan_card.dart';
import 'property_card.dart';

class ActionScreen extends StatelessWidget {
  ActionScreen() {
    MainBloc.dealOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    double fraction = 200 / MediaQuery.of(context).size.width;
    PageController pageController = PageController(
      initialPage: Game.data.player.position,
      viewportFraction: fraction,
    );
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ActionFab(),
        body: FractionallySizedBox(
          heightFactor: 1,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: Text(Game.data.player.name),
                  leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      showSettingsSheet(context, pageController);
                    },
                  ),
                  actions: [
                    Center(
                        child: Card(
                            child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GameListener(
                        builder: (BuildContext context, _, __) {
                          try {
                            if (Game.data.dealData.dealer != null) {
                              if (Game.data.players[Game.data.dealData.dealer]
                                          .code ==
                                      MainBloc.code &&
                                  MainBloc.online &&
                                  !MainBloc.dealOpen &&
                                  Game.ui.showDealScreen) {
                                Future.delayed(Duration.zero, () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return DealScreen(
                                      dealer: Game.data.dealData.dealer,
                                      visit: true,
                                    );
                                  }));
                                  ;
                                });
                              }
                            }
                          } catch (e) {
                            Game.data.dealData == GameData();
                          }

                          return Row(
                            children: <Widget>[
                              Text("£"),
                              AnimatedCount(
                                count: (MainBloc.online
                                    ? (Game.data.players
                                        .firstWhere((Player p) =>
                                            p.code == MainBloc.code)
                                        .money
                                        .toInt())
                                    : (Game.data.player.money.round())),
                                duration: Duration(seconds: 1),
                              ),
                            ],
                          );
                        },
                      ),
                    ))),
                    Container(
                      width: 5,
                    )
                  ],
                  automaticallyImplyLeading: false,
                  expandedHeight: 450.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.only(bottom: 10),
                          height: 300,
                          child: Theme(
                            data: ThemeData.light(),
                            child: GameListener(
                              builder: (_, __, ___) {
                                return MapCarousel(controller: pageController);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  bottom: TabBar(
                    tabs: [
                      Tab(child: Text("Holdings")),
                      Tab(child: Text("Actions"))
                    ],
                  ),
                )
              ];
            },
            body: TabBarView(
              physics: Game.ui.idle
                  ? NeverScrollableScrollPhysics()
                  : PageScrollPhysics(),
              children: <Widget>[
                GameListener(builder: (c, _, __) => buildHoldingCards(context)),
                Game.ui.idle
                    ? GameListener(
                        builder: (c, __, ___) => IdleScreen(pageController))
                    : GameListener(
                        builder: (BuildContext context, _, __) {
                          return buildActionCards(context, pageController);
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHoldingCards(BuildContext context) {
    List<int> _properties = Game.data.player.properties;
    if (MainBloc.online) _properties = MainBloc.gamePlayer.properties;
    if (_properties.isEmpty) {
      return Container(
        height: 100,
        child: Center(
            child: Card(
                child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text("You have no properties yet"),
        ))),
      );
    }
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _properties.length,
        itemBuilder: (context, index) {
          return Theme(
            data: Theme.of(context).copyWith(brightness: Brightness.light),
            child: GameListener(
              builder: (BuildContext context, _, __) {
                return PropertyCard(tile: Game.data.gmap[_properties[index]]);
              },
            ),
          );
        });
  }

  Widget buildActionCards(BuildContext context, PageController pageController) {
    List<Widget> actions = [
      PropertyActionCard(pageController: pageController),
      MoneyCard(),
      ActionsCard(),
      InfoCard(),
    ];

    if (Game.data.extensions.contains(Extension.bank)) {
      actions.add(LoanCard());
      if ((Game.data.player.loans ?? []).isNotEmpty) {
        actions.add(DebtCard());
      }
    }

    if (Game.data.extensions.contains(Extension.stock)) {
      actions.add(StockCard());
    }

    //END
    actions.add(DefaultCard());

    List<Widget> evenActions = [];

    List<Widget> oddActions = [];
    actions.asMap().forEach((index, w) {
      if (index.isEven)
        evenActions.add(w);
      else
        oddActions.add(w);
    });

    if (MainBloc.isWide(context)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: evenActions,
            ),
          ),
          Expanded(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: oddActions,
            ),
          )
        ],
      );
    }
    actions.add(EndOfList());
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: actions,
    );
  }
}

class ActionFab extends StatelessWidget {
  const ActionFab({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool wasIdle = false;
    return GameListener(
      builder: (BuildContext context, _, __) {
        if (Game.ui.idle || wasIdle) {
          wasIdle = true;
          return SlideFab(
            hide: Game.ui.idle,
            title: "Your turn",
            onTap: () {
              GameNavigator.navigate(context);
            },
          );
        }

        return Game.ui.idle
            ? Container()
            : Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      if (continueCheck(
                          DefaultTabController.of(context).index, context)) {
                        if (Alert.handle(Game.next, context)) {
                          GameNavigator.navigate(context);
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                title: Text("Continue"),
                                content: Text(
                                    "Are you sure you want to go to the next turn?"),
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
                                        Navigator.pop(context);
                                        if (Alert.handle(Game.next, context)) {
                                          GameNavigator.navigate(context);
                                        }
                                      },
                                      child: Text(
                                        "continue",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ))
                                ]);
                          },
                        );
                      }
                    },
                    child: Icon(
                      Icons.navigate_next,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
      },
    );
  }
}

bool continueCheck(int index, BuildContext c) {
  if (Game.nextCheck() != null) return true;
  if (index != 1) return false;
  Tile currentTile = Game.data.player.positionTile;
  if (currentTile.type == TileType.tax) return true;
  if (currentTile.price != null) {
    Player owner = Game.data.player.positionTile.owner;
    if (owner == null) {
      if (currentTile.price < Game.data.player.money) return false;
    }

    if (Game.data.player.hasAll(currentTile.idPrefix)) {
      if (currentTile.level < 5 &&
          (Game.data.player.money + 200) > currentTile.price) return false;
    }
  }
  return true;
}
