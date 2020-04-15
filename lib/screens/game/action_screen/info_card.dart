import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../engine/kernel/extensions/bank.dart';

import '../../../bloc/main_bloc.dart';
import '../../../engine/data/info.dart';
import '../../../engine/kernel/main.dart';
import '../../../widgets/my_card.dart';

class InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: "Info",
      children: <Widget>[
        GameListener(
          builder: (BuildContext context, _, __) {
            //check it exists

            List<UpdateInfo> info = [];
            if (Game.data.player.info.containsKey(Game.data.turn - 1)) {
              info.addAll(Game.data.player.info[Game.data.turn - 1]);
            }
            if (Game.data.player.info.containsKey(Game.data.turn - 2)) {
              info.addAll(Game.data.player.info[Game.data.turn - 2]);
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
