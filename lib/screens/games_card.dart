import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../bloc/main_bloc.dart';
import '../engine/data/main.dart';
import '../engine/kernel/main.dart';
import '../engine/ui/game_navigator.dart';

class GamesCard extends StatefulWidget {
  const GamesCard({
    Key key,
  }) : super(key: key);

  @override
  _GamesCardState createState() => _GamesCardState();
}

class _GamesCardState extends State<GamesCard>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: Text(
              "Open Games:",
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.start,
            ),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 200),
            curve: Curves.decelerate,
            vsync: this,
            child: ValueListenableBuilder(
                valueListenable: Hive.box(MainBloc.GAMESBOX).listenable(),
                builder: (context, Box box, __) {
                  List<GameData> games = box.values.toList().cast<GameData>();
                  if (games.length == 0)
                    return Container(
                        height: 80,
                        child: Center(child: Text("No open games")));
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: games.length,
                    separatorBuilder: (context, _) {
                      return Divider();
                    },
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Game.loadGame(games[index]);
                          GameNavigator.navigate(context, loadGame: true);
                        },
                        child: ListTile(
                          title: Text(games[index].settings?.name ?? "Unknown"),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              box.deleteAt(index);
                            },
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
