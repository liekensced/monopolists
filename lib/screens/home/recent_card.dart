import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/engine/ui/alert.dart';
import 'package:plutopoly/engine/ui/game_navigator.dart';
import 'package:plutopoly/widgets/my_card.dart';

class RecentCard extends StatelessWidget {
  final Box box;
  const RecentCard({
    Key key,
    @required this.box,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> recents = [];
    MainBloc.getRecent().asMap().forEach((int index, String gameId) {
      recents.add(InkWell(
        onTap: () async {
          Alert alert = await MainBloc.joinOnline(gameId);
          if (Alert.handle(() => alert, context)) {
            GameNavigator.navigate(context, loadGame: true);
          }
        },
        child: ListTile(
          title: Text(gameId),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => removeFromBox(index),
          ),
        ),
      ));
      recents.add(Divider());
    });
    if (recents.isEmpty) {
      recents.add(Container(
        height: 80,
        child: Center(
          child: Text("No recent keys"),
        ),
      ));
    }

    if (recents.length > 1) {
      recents.removeLast();
    }

    return MyCard(title: "Recent Keys", children: recents);
  }

  void removeFromBox(int index) {
    List<String> recent = Hive.box(MainBloc.METABOX)
        .get("listRecent", defaultValue: []).cast<String>();
    recent.removeAt(index);
    Hive.box(MainBloc.METABOX).put("listRecent", recent);
  }
}
