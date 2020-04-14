import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/kernel/main.dart';
import '../../engine/ui/game_navigator.dart';
import '../carousel/map_carousel.dart';
import 'dice_select.dart';

class MoveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double fraction = 200 / MediaQuery.of(context).size.width;
    PageController pageController = PageController(
        initialPage: Game.data.player.position, viewportFraction: fraction);
    return Scaffold(
        backgroundColor: Colors.teal,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragEnd: (_) {
            moveModalBottomSheet(context);
          },
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 50),
                  child: Text(Game.data.player.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 45, color: Colors.white)),
                ),
                GameListener(
                  builder: (context, __, _) {
                    return LimitedBox(
                      maxHeight: 300,
                      child: Theme(
                        data: ThemeData.light(),
                        child: MapCarousel(
                          controller: pageController,
                        ),
                      ),
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: Hive.box(MainBloc.PREFBOX).listenable(),
                  builder: (BuildContext context, Box box, Widget _) {
                    if (MainBloc.randomDices) {
                      if (box.containsKey("intDice0") &&
                          box.containsKey("intDice1")) {
                        Game.move(box.get("intDice0"), box.get("intDice1"));

                        int pos = Game.data.player.position;

                        int mapLength = Game.data.gmap.length;
                        pageController.animateToPage(
                          (pageController.page ?? 0) > pos
                              ? pos + mapLength
                              : pos,
                          duration: Duration(
                              milliseconds: Game.ui.moveAnimationMillis),
                          curve: Curves.decelerate,
                        );
                        Future.delayed(
                            Duration(
                                milliseconds:
                                    Game.ui.moveAnimationMillis + 500), () {
                          box.delete("intDice0");
                          box.delete("intDice1");
                          navigate(context);
                        });
                      }
                    }

                    return ValueListenableBuilder(
                        valueListenable:
                            Hive.box(MainBloc.GAMESBOX).listenable(),
                        builder: (context, _, __) {
                          return Expanded(
                            child: DiceSelect(),
                          );
                        });
                  },
                ),
              ],
            ),
          ),
        ));
  }

  navigate(BuildContext context) {
    GameNavigator.navigate(context);
  }
}

void moveModalBottomSheet(BuildContext context) {
  if (MainBloc.online) return;
  Box box = Hive.box(MainBloc.PREFBOX);
  box.delete("intDice0");
  box.delete("intDice1");
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0))),
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: FaIcon(FontAwesomeIcons.solidHandPointer),
                  title: Text('Select dices'),
                  onTap: () {
                    Hive.box(MainBloc.PREFBOX).put("boolRandomDices", false);
                    Navigator.pop(context);
                  }),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.dice),
                title: Text('Randomly pick dices'),
                onTap: () {
                  Hive.box(MainBloc.PREFBOX).put("boolRandomDices", true);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      });
}
