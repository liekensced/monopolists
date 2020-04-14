import 'package:flutter/material.dart';
import '../../../bloc/main_bloc.dart';
import '../../../engine/data/info.dart';
import '../../../engine/kernel/main.dart';

class InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: Text(
              "Info",
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.start,
            ),
          ),
          GameListener(
            builder: (BuildContext context, _, __) {
              //check it exists

              List<Info> info = [];
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
      ),
    );
  }
}

Widget getLeading(String leading) {
  switch (leading) {
    case "rent":
      return Icon(Icons.home);
      break;
    default:
      return Icon(Icons.info);
  }
}
