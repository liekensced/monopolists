import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plutopoly/bloc/game_listener.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/engine/data/ui_actions.dart';
import 'package:plutopoly/screens/game/action_screen/action_screen.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/kernel/main.dart';
import '../carousel/map_carousel.dart';
import 'dice_select.dart';

class MoveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double fraction = 200 / MediaQuery.of(context).size.width;
    PageController pageController = PageController(
        initialPage: Game.data.player.position, viewportFraction: fraction);
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragEnd: (_) {
            moveModalBottomSheet(context);
          },
          child: SafeArea(
            child: Stack(
              children: [
                Column(
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
                      valueListenable: Hive.box(MainBloc.MOVEBOX).listenable(),
                      builder: (BuildContext context, Box box, Widget _) {
                        if (box.containsKey("intDice0") &&
                            box.containsKey("intDice1")) {
                          int dice1 = box.get("intDice0");
                          int dice2 = box.get("intDice1");
                          Game.move(
                            dice1,
                            dice2,
                            shouldSave: false,
                          );

                          int pos = Game.data.player.position;

                          int mapLength = Game.data.gmap.length;
                          Future.delayed(Duration.zero, () {
                            pageController.animateToPage(
                              (pageController.page ?? 0) > pos
                                  ? pos + mapLength
                                  : pos,
                              duration: Duration(
                                  milliseconds: Game.ui.moveAnimationMillis),
                              curve: Curves.decelerate,
                            );
                          });
                          Future.delayed(
                              Duration(
                                  milliseconds:
                                      Game.ui.moveAnimationMillis + 500), () {
                            box.delete("intDice0");
                            box.delete("intDice1");
                            UIBloc.changeScreen(Screen.active);
                            Game.save();
                          });
                        }

                        return GameListener(builder: (context, _, __) {
                          return Expanded(
                            child: DiceSelect(),
                          );
                        });
                      },
                    ),
                    Theme(
                        child: GameListener(builder: (context, snapshot, _) {
                          return NotificationHandler();
                        }),
                        data: ThemeData.light())
                  ],
                ),
                DoublePopup(),
              ],
            ),
          ),
        ));
  }
}

void moveModalBottomSheet(BuildContext context) {
  if (MainBloc.online) return;
  Box box = Hive.box(MainBloc.MOVEBOX);
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
                    box.put("boolRandomDices", false);
                    Navigator.pop(context);
                  }),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.dice),
                title: Text('Randomly pick dices'),
                onTap: () {
                  box.put("boolRandomDices", true);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      });
}

class DoublePopup extends StatefulWidget {
  DoublePopup();
  @override
  _DoublePopupState createState() => _DoublePopupState();
}

class _DoublePopupState extends State<DoublePopup>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(MainBloc.MOVEBOX).listenable(),
      builder: (context, box, __) {
        bool show = false;
        if (box.containsKey("intDice0") && box.containsKey("intDice1")) {
          int dice1 = box.get("intDice0");
          int dice2 = box.get("intDice1");
          show = dice2 == dice1;
        }
        !Game.data.ui.shouldMove;
        return Center(
          child: AnimatedSize(
            vsync: this,
            curve: Curves.easeInOutCubic,
            duration: Duration(milliseconds: 200),
            child: FractionallySizedBox(
              heightFactor: show ? 0.9 : 0,
              widthFactor: show ? 0.9 : 0,
              child: Image.asset("assets/double.png"),
            ),
          ),
        );
      },
    );
  }
}
