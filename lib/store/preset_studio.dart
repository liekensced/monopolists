import 'package:flutter/material.dart';
import 'package:plutopoly/bloc/game_listener.dart';
import 'package:plutopoly/engine/data/map.dart';
import 'package:plutopoly/engine/kernel/main.dart';
import 'package:plutopoly/screens/game/zoom_map.dart';
import 'package:plutopoly/store/preset_settings.dart';
import 'package:plutopoly/widgets/end_of_list.dart';

import '../screens/start/start_game.dart';
import '../widgets/my_card.dart';
import 'preset.dart';

class PresetStudio extends StatelessWidget {
  final Preset preset;

  const PresetStudio({Key key, @required this.preset}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FractionallySizedBox(
      heightFactor: 1,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text("Preset studio"),
              automaticallyImplyLeading: false,
              expandedHeight: 200,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: EdgeInsets.only(top: 50),
                  alignment: Alignment.center,
                  child: Container(
                    height: 300,
                    child: Theme(
                      data: ThemeData.light(),
                      child: Center(
                        child: Text(
                          preset.title,
                          style: TextStyle(fontSize: 50),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ];
        },
        body: ListView(
          children: [
            MyCard(
              title: "Settings",
              children: [
                ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return StartGameScreen(
                          studio: true,
                        );
                      }));
                    },
                    title: Text("Game Settings"),
                    subtitle: Text("Change the game settings"),
                    trailing: Icon(
                      Icons.open_in_new,
                    )),
                Divider(),
                ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return PresetSettings();
                      }));
                    },
                    title: Text("Preset settings"),
                    subtitle: Text("Title, info cards, theming"),
                    trailing: Icon(
                      Icons.settings,
                    )),
              ],
            ),
            GameListener(builder: (context, _, __) => ZoomMap()),
            MapListView(),
            EndOfList()
          ],
        ),
      ),
    ));
  }
}

class MapListView extends StatefulWidget {
  @override
  _MapListViewState createState() => _MapListViewState();
}

class _MapListViewState extends State<MapListView> {
  @override
  Widget build(BuildContext context) {
    return GameListener(
      builder: (context, _, __) => MyCard(
        listen: true,
        title: "Map (reordable)",
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 3 / 4,
            width: MediaQuery.of(context).size.height * 3 / 4,
            child: Align(
              alignment: Alignment.topLeft,
              child: ReorderableListView(
                children: [
                  for (Tile tile in Game.data.gmap)
                    ListTile(
                      key: Key(tile.id),
                      title: Text(tile.name ?? tile.id),
                      subtitle: Text(tile.id +
                          ", " +
                          tile.type.toString().split(".").last),
                    )
                ],
                onReorder: (oldIndex, newIndex) {
                  Tile cache = Game.data.gmap[oldIndex];
                  Game.data.gmap.removeAt(oldIndex);
                  if (newIndex > oldIndex) newIndex--;
                  if (newIndex > Game.data.gmap.length - 1) {
                    Game.data.gmap.add(cache);
                  } else {
                    Game.data.gmap.insert(newIndex, cache);
                  }
                  Game.save();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
