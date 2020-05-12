import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plutopoly/engine/data/ui_actions.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/kernel/main.dart';

class DiceSelect extends StatefulWidget {
  const DiceSelect({Key key}) : super(key: key);

  @override
  _DiceSelectState createState() => _DiceSelectState();
}

class _DiceSelectState extends State<DiceSelect> {
  bool started = false;
  List<int> dices = [-1, -1];
  @override
  Widget build(BuildContext context) {
    Box box = Hive.box(MainBloc.PREFBOX);
    if (box.get("boolRandomDices") == null && !MainBloc.online) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FaIcon(FontAwesomeIcons.angleDoubleUp),
          Container(
            height: 5,
          ),
          Text("Swipe up to select dice mode")
        ],
      );
    }
    if ((box.get("boolRandomDices", defaultValue: true) || MainBloc.online) &&
        !started) {
      return Center(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Container(
            margin: const EdgeInsets.all(20.0),
            child: FaIcon(
              FontAwesomeIcons.dice,
              size: 50,
            ),
          ),
          onTapDown: (_) {
            started = true;
            Future.delayed(
              Duration(milliseconds: 200),
              () {
                dices[0] = Random().nextInt(6) + 1;
                dices[1] = Random().nextInt(6) + 1;
                setState(() {});
                randomDice(box);
              },
            );
            setState(() {});
          },
        ),
      );
    }
    return AbsorbPointer(
      absorbing: started,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Center(child: dice(context, 0)),
          Container(height: 5),
          Center(child: dice(context, 1)),
          Container(
            height: 50,
          )
        ],
      ),
    );
  }

  Future<dynamic> randomDice(Box box) {
    return Future.delayed(
      Duration(milliseconds: 300),
      () {
        dices[0] = Random().nextInt(6) + 1;
        dices[1] = Random().nextInt(6) + 1;
        setState(() {});
        if (Random().nextInt(4) == 1) {
          Future.delayed(Duration(milliseconds: 400), () {
            box.put("intDice0", dices[0]);
            box.put("intDice1", dices[1]);
          });
        } else {
          randomDice(box);
        }
      },
    );
  }

  Widget dice(BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        buildIcon(FontAwesomeIcons.diceOne, context, index, 1),
        buildIcon(FontAwesomeIcons.diceTwo, context, index, 2),
        buildIcon(FontAwesomeIcons.diceThree, context, index, 3),
        buildIcon(FontAwesomeIcons.diceFour, context, index, 4),
        buildIcon(FontAwesomeIcons.diceFive, context, index, 5),
        buildIcon(FontAwesomeIcons.diceSix, context, index, 6),
      ],
    );
  }

  Widget buildIcon(IconData icon, BuildContext context, int index, int value) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(MainBloc.PREFBOX).listenable(),
        builder: (context, Box box, _) {
          Color color = Colors.white;
          if (box.get("intDice$index") == value || dices[index] == value) {
            color = Theme.of(context).accentColor;
          }

          return InkWell(
            onTap: () {
              if (Game.ui.screenState != Screen.move) return;
              box.put("intDice$index", value);
            },
            child: FaIcon(
              icon,
              color: color,
              size: min(MediaQuery.of(context).size.width / 7,
                  MediaQuery.of(context).size.height / 7),
            ),
          );
        });
  }
}
