import 'dart:math';

import 'package:flutter/material.dart';
import 'package:plutopoly/bloc/game_listener.dart';
import 'package:plutopoly/engine/data/player.dart';
import 'package:plutopoly/helpers/icon_helper.dart';

import '../../../engine/data/update_info.dart';
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
            int length = player.info.length;
            List<UpdateInfo> info = player.info
                .sublist(max(length - (short ? 5 : 10), 0))
                .reversed
                .toList();

            if (info.isEmpty)
              return Container(
                height: 80,
                child: Center(
                  child: Text("No information\n"),
                ),
              );
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: info.length,
              itemBuilder: (BuildContext context, int i) {
                if (info[i].title == null) return Container();
                if (info[i].subtitle == null) {
                  return ListTile(
                    leading: GameIcon(info[i].leading),
                    title: Text(
                      info[i].title ?? "",
                    ),
                    trailing: Text(
                      info[i].trailing ?? "",
                    ),
                  );
                }
                return ListTile(
                  leading: GameIcon(info[i].leading),
                  title: Text(
                    info[i].title ?? "",
                  ),
                  subtitle: Text(info[i].subtitle ?? ""),
                  trailing: Text(
                    info[i].trailing ?? "",
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
