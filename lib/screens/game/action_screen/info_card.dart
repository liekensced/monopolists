import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/engine/data/player.dart';
import '../../../engine/extensions/bank/bank.dart';

import '../../../bloc/main_bloc.dart';
import '../../../engine/data/info.dart';
import '../../../engine/kernel/main.dart';
import '../../../widgets/my_card.dart';

class InfoCard extends StatelessWidget {
  final Player iplayer;
  final bool short;

  const InfoCard({Key key, this.iplayer, this.short: true}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Player player = iplayer;
    if (iplayer == null) player = Game.data.player;
    return MyCard(
      title: "Info",
      children: <Widget>[
        GameListener(
          builder: (BuildContext context, _, __) {
            //check it exists

            List<UpdateInfo> info = [];
            if (player.info.containsKey(Game.data.turn - 1)) {
              info.addAll(player.info[Game.data.turn - 1]);
            }
            if (player.info.containsKey(Game.data.turn - 2)) {
              info.addAll(player.info[Game.data.turn - 2]);
            }
            if (!short) {
              if (player.info.containsKey(Game.data.turn - 3)) {
                info.addAll(player.info[Game.data.turn - 3]);
              }
              if (player.info.containsKey(Game.data.turn - 4)) {
                info.addAll(player.info[Game.data.turn - 4]);
              }
            }
            if (info.isEmpty)
              return Container(
                height: 80,
                child: Center(
                  child: Text("No information\n"),
                ),
              );
            return ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: info.length,
              separatorBuilder: (c, _) {
                return Divider();
              },
              itemBuilder: (BuildContext context, int i) {
                return ListTile(
                  leading: getLeading(info[i].leading),
                  title: Text(info[i].title),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

Widget getLeading(String leading) {
  switch (leading) {
    case "rent":
      return Icon(Icons.home);
      break;
    case "bank":
      return Bank.icon();
    case "time":
      return FaIcon(FontAwesomeIcons.solidClock);
    default:
      return Icon(Icons.info);
  }
}
