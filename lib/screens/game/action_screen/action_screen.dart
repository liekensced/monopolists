import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:plutopoly/engine/data/info.dart';
import 'package:plutopoly/screens/game/zoom_map.dart';
import 'package:plutopoly/widgets/end_of_list.dart';
import 'package:plutopoly/widgets/my_card.dart';

import '../../../bloc/ad_bloc.dart';
import '../../../bloc/game_listener.dart';
import '../../../bloc/main_bloc.dart';
import '../../../bloc/ui_bloc.dart';
import '../../../engine/data/main_data.dart';
import '../../../engine/data/map.dart';
import '../../../engine/data/player.dart';
import '../../../engine/data/ui_actions.dart';
import '../../../engine/kernel/main.dart';
import '../../../engine/ui/alert.dart';
import '../../../engine/ui/game_navigator.dart';
import '../../../widgets/animated_count.dart';
import '../../../widgets/slide_fab.dart';
import '../../carousel/map_carousel.dart';
import '../deal_screen.dart';
import '../idle_screen.dart';
import '../move_screen.dart';
import 'action_cards.dart';
import 'bottom_sheet.dart';
import 'holding_cards.dart';

class ActionScreen extends StatefulWidget {
  ActionScreen() {
    MainBloc.dealOpen = false;
  }

  @override
  _ActionScreenState createState() => _ActionScreenState();
}

class _ActionScreenState extends State<ActionScreen> {
  ScrollController controller;
  PageController actionPageController;
  @override
  void initState() {
    actionPageController = PageController(initialPage: 1, keepPage: true);

    super.initState();
  }

  bool first = true;
  @override
  void dispose() {
    actionPageController.dispose();
    controller.dispose();
    super.dispose();
  }

  int pageIndex = 1;

  @override
  Widget build(BuildContext context) {
    if (Game.data.ui.ended) {
      Future.delayed(Duration.zero, () => GameNavigator.navigate(context));
    }
    if (Game.ui.screenState == Screen.move && !Game.ui.idle) {
      //for action screen
      pageIndex = 1;
      actionPageController.jumpToPage(pageIndex);

      return MoveScreen();
    }
    double fraction = 200 / MediaQuery.of(context).size.width;
    PageController pageController = PageController(
      initialPage: Game.data.player.position,
      viewportFraction: fraction,
    );
    bool idle = Game.ui.idle || Game.ui.screenState == Screen.idle;
    controller = ScrollController(
        initialScrollOffset: idle ? UIBloc.scrollOffset ?? 0 : 0);
    Future.delayed(Duration.zero, () {
      if (idle && first) {
        first = false;

        controller.jumpTo(UIBloc.scrollOffset);
      }
    });

    Screen screenState = Game.ui.screenState;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ActionFab(
        controller: controller,
        onPressed: () {
          first = true;
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (i) {
          if (i == 3) {
            showModalBottomSheet(
                context: context,
                builder: (c) {
                  return BottomSheet(
                      onClosing: () {},
                      builder: (c) {
                        return Column(children: [
                          Container(
                            child: Center(child: Text("Action screen")),
                            height: 50,
                          ),
                          ListTile(title: Text("ds")),
                        ]);
                      });
                });
          } else {
            if (i == 2) {
              controller.jumpTo(450);
            }
            actionPageController.jumpToPage(i);
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.list), title: Text("Holdings")),
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text("Actions")),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_on), title: Text("Gridview"))
          // BottomNavigationBarItem(
          //     icon: FaIcon(FontAwesomeIcons.compass), title: Text("Open item"))
        ],
      ),
      body: FractionallySizedBox(
        heightFactor: 1,
        child: NestedScrollView(
          controller: controller,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: GameListener(
                    builder: (c, _, __) => Text(Game.data.player.name)),
                leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    showSettingsSheet(context, pageController);
                  },
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.location_searching),
                    onPressed: () {
                      if (pageController.hasClients) {
                        pageController.animateToPage(Game.data.player.position,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOutCubic);
                      }
                    },
                  ),
                  Center(
                      child: Card(
                          child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GameListener(
                      builder: (BuildContext context, _, __) {
                        try {
                          if (screenState != Game.ui.screenState) {
                            Future.delayed(
                                Duration.zero, () => setState(() {}));
                          }
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
                              count: ((UIBloc.gamePlayer.money.toInt())),
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
                expandedHeight:
                    max(min(MediaQuery.of(context).size.height / 2, 450), 300),
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: EdgeInsets.only(top: 50),
                    alignment: Alignment.center,
                    child: Container(
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
              )
            ];
          },
          body: Stack(
            children: [
              PageView(
                onPageChanged: (int indx) {
                  pageIndex = indx;
                  setState(() {});
                },
                controller: actionPageController,
                physics:
                    idle ? NeverScrollableScrollPhysics() : PageScrollPhysics(),
                children: <Widget>[
                  HoldingCards(),
                  idle
                      ? GameListener(
                          builder: (c, __, ___) =>
                              IdleScreen(pageController, controller))
                      : GameListener(
                          builder: (BuildContext context, _, __) {
                            return ActionCards();
                          },
                        ),
                  ListView(
                    children: [
                      ZoomMap(),
                      EndOfList(),
                    ],
                  )
                ],
              ),
              Theme(
                  child: GameListener(builder: (context, snapshot, _) {
                    return Notification();
                  }),
                  data: ThemeData.light())
            ],
          ),
        ),
      ),
    );
  }
}

class Notification extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  int length;
  @override
  Widget build(BuildContext context) {
    if (length == null) {
      length = UIBloc.gamePlayer.info.length;
    }
    UIBloc.gamePlayer.info.asMap().forEach((index, UpdateInfo info) {
      if (index > length - 1) {
        if (info.show ?? false) {
          Future.delayed(Duration.zero, () {
            Scaffold.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.fixed,
              elevation: 0,
              backgroundColor: Colors.transparent,
              content: Container(
                child: MyCard(
                  shrinkwrap: true,
                  color: Colors.green,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        info.title ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(color: Colors.white),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        info.subtitle ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(color: Colors.white),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.bottomRight,
                      child: Text(
                        info.trailing ?? "",
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      ),
                    )
                  ],
                ),
              ),
            ));
          });
        }
      }
    });
    length = UIBloc.gamePlayer.info.length;
    return Container();
  }
}

class ActionFab extends StatelessWidget {
  final Function onPressed;
  const ActionFab(
      {Key key, @required this.controller, @required this.onPressed})
      : super(key: key);
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    bool idle = Game.ui.idle || Game.ui.screenState == Screen.idle;
    return GameListener(
      builder: (BuildContext context, _, __) {
        if (idle) {
          if (Game.ui.idle) {
            return Container();
          }
          return SlideFab(
            hide: Game.ui.idle,
            title: "Your turn",
            onTap: () {
              try {
                UIBloc.scrollOffset = controller.offset + 100;
                onPressed();
              } catch (e) {}
              UIBloc.changeScreen(Screen.move);
              Game.save(only: ["ui"]);
            },
          );
        }

        return Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: FloatingActionButton(
              onPressed: () {
                if (continueCheck(1, context)) {
                  if (Alert.handle(() => Game.next(changeS: true), context)) {
                    if (!kIsWeb)
                      AdBloc.idleAdController = NativeAdmobController();
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
                                      color: Theme.of(context).primaryColor),
                                )),
                            MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Alert.handle(
                                      () => Game.next(changeS: true), context);
                                },
                                child: Text(
                                  "continue",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
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

    if (Game.data.player.hasAllUnmortaged(currentTile.idPrefix)) {
      if (currentTile.level < 5 &&
          (Game.data.player.money + 200) > currentTile.price) return false;
    }
  }
  return true;
}
