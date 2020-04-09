import 'package:flutter/material.dart';
import 'package:monopolists/widgets/animated_count.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/data/player.dart';
import '../../engine/kernel/main.dart';
import '../start/players.dart';

class MoneyCard extends StatelessWidget {
  const MoneyCard({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Player player = Game.data.player;
    int color = player.color;
    return Container(
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
                Text("Monopolists",
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
                children: <Widget>[
                  Text("£",
                      style: TextStyle(color: Colors.white, fontSize: 50)),
                  ValueListenableBuilder(
                    valueListenable: MainBloc.listen(),
                    builder: (BuildContext context, _, __) {
                      return AnimatedCount(
                          count: player.money.round(),
                          duration: Duration(milliseconds: 1000),
                          style: TextStyle(color: Colors.white, fontSize: 50));
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
