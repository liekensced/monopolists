import 'package:flutter/material.dart';
import 'package:plutopoly/bloc/game_listener.dart';

import '../../engine/data/player.dart';
import '../../engine/kernel/main.dart';
import '../../widgets/animated_count.dart';
import '../start/players.dart';

class MoneyCard extends StatelessWidget {
  const MoneyCard({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Player player = Game.data.player;
    int color = player.color;
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.1, 0.9],
              colors: [
                Color(color),
                ColorHelper().getAccent(color),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Plutopolist",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        )),
                    Text(player.name,
                        style: TextStyle(color: Colors.white, fontSize: 20))
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      if (Game.data.placeCurrencyInFront ?? true)
                        Text(Game.data.currency ?? "£",
                            style:
                                TextStyle(color: Colors.white, fontSize: 50)),
                      GameListener(
                        builder: (BuildContext context, _, __) {
                          return AnimatedCount(
                              count: player.money.round(),
                              duration: Duration(milliseconds: 1000),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 50));
                        },
                      ),
                      if (!(Game.data.placeCurrencyInFront ?? true))
                        Text(Game.data.currency ?? "£",
                            style:
                                TextStyle(color: Colors.white, fontSize: 50)),
                      Spacer(),
                      buildText()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildText() {
    try {
      if (Game.data.turn <= 1) return Container();
      double lastMoney = Game.data.player.moneyHistory[Game.data.turn - 1];
      double percentChange =
          ((Game.data.player.money - lastMoney) / lastMoney) * 100;
      if (percentChange.isInfinite || percentChange.isNaN) percentChange = 0;
      bool p = percentChange >= 0;
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            percentChange.floor().toString() + (p ? "% ▲" : "% ▼"),
            style: TextStyle(color: p ? Colors.green : Colors.red),
          ),
        ),
      );
    } catch (e) {
      return Container();
    }
  }
}
