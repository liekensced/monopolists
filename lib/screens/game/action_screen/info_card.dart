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
          ValueListenableBuilder(
            valueListenable: MainBloc.listen(),
            builder: (BuildContext context, _, __) {
              if (Game.data.player.info.length < 1) return Container();
              List<Info> info = Game.data.player.info.last;
              return ListView.separated(
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
