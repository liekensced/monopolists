import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../bloc/game_listener.dart';
import '../bloc/main_bloc.dart';
import '../engine/data/map.dart';
import '../engine/extensions/setting.dart';
import '../engine/kernel/main.dart';
import '../engine/ui/alert.dart';
import '../screens/game/property_page.dart';
import '../screens/game/zoom_map.dart';
import '../screens/start/start_game.dart';
import '../widgets/end_of_list.dart';
import '../widgets/my_card.dart';
import '../widgets/setting_tile.dart';
import 'gmap_checker.dart';
import 'preset.dart';
import 'preset_settings.dart';

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
              title: Text("Preset studio Beta"),
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
            ValueListenableBuilder(
              valueListenable: MainBloc.metaBox.listenable(),
              builder: (context, _, __) =>
                  GameListener(builder: (context, _, __) => ZoomMap()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text("Add tile"),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ListView(
                          shrinkWrap: true,
                          children: [
                            Center(
                                child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text("Please select tile type"),
                            )),
                            for (TileType tileType in TileType.values)
                              ListTile(
                                onTap: () {
                                  end() {
                                    Navigator.pop(context);
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return PropertyPage(
                                        property: Game.data.gmap.last,
                                      );
                                    }));
                                    Game.save();
                                  }

                                  if (tileType == TileType.land) {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          List<Widget> childs = [];
                                          Game.streets.forEach((key, value) {
                                            childs.add(ListTile(
                                                onTap: () {
                                                  Game.data.gmap.add(
                                                      Tile.type(tileType, key));
                                                  Navigator.pop(context);
                                                  end();
                                                },
                                                title: Text("$key ($value)")));
                                          });
                                          return ListView(
                                            children: childs,
                                          );
                                        });
                                  } else {
                                    Game.data.gmap.add(Tile.type(tileType));
                                    end();
                                  }
                                },
                                title:
                                    Text(tileType.toString().split(".").last),
                              )
                          ],
                        );
                      });
                },
              ),
            ),
            MapHelperCard(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text("Run tests"),
                onPressed: () {
                  Alert.handle(
                      () =>
                          GmapChecker.call(Game.data.gmap) ??
                          Alert("Test succes", "The test didn't fail",
                              type: DialogType.SUCCES),
                      context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return PresetSettings();
                    }));
                  },
                  label: Text(
                    "Launch",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit map'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Alert.handle(
                  () => Alert("Map list view",
                      "To move a property, long press the tile and move it. \nTo delete a property, swipe the property.",
                      type: DialogType.INFO),
                  context);
            },
          )
        ],
      ),
      body: GameListener(
        builder: (context, _, __) => MyCard(
          listen: true,
          title: "Map (reordable)",
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 3 / 4,
              child: Align(
                alignment: Alignment.topLeft,
                child: ReorderableListView(
                  children: [
                    for (Tile tile in Game.data.gmap)
                      Dismissible(
                        background: Container(
                          color: Colors.red,
                          child: ListTile(
                            leading: Icon(Icons.delete),
                            trailing: Icon(Icons.delete),
                            title: Text("Delete"),
                          ),
                        ),
                        onDismissed: (_) {
                          Game.data.gmap.remove(tile);
                          Game.save();
                        },
                        key: Key(tile.id),
                        child: ListTile(
                          key: Key(tile.id),
                          title: Text(tile.name ?? tile.id),
                          trailing: Icon(Icons.reorder),
                          leading: buildLeading(tile),
                          subtitle: Text(tile.id +
                              ", " +
                              tile.type.toString().split(".").last),
                        ),
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
      ),
    );
  }

  Widget buildLeading(Tile tile) {
    if (tile.type == TileType.land) {
      return CircleColor(
        color: Color(tile.color),
        circleSize: 30,
      );
    }
    return Container(width: 0);
  }
}

class MapHelperCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: "Map helpers",
      children: [
        ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return MapListView();
              }));
            },
            title: Text("Reordable map list"),
            trailing: Icon(
              Icons.navigate_next,
            )),
        ListTile(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  List<Widget> childs = [];
                  Map<String, String> streets = Game.streets;
                  streets.forEach((key, value) {
                    childs.add(ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AddStreetScreen(
                                template: Game.data.gmap
                                    .firstWhere((prop) => prop.idPrefix == key),
                              );
                            },
                          );
                        },
                        title: Text("$key ($value)")));
                  });
                  return ListView(
                    children: [
                      Container(
                        child: Center(child: Text("Choose a template")),
                        height: 50,
                      ),
                      ...childs
                    ],
                  );
                });
          },
          title: Text("Add street"),
          trailing: Icon(Icons.view_carousel),
        )
      ],
    );
  }
}

class AddStreetScreen extends StatefulWidget {
  final Tile template;

  const AddStreetScreen({Key key, @required this.template}) : super(key: key);
  @override
  _AddStreetScreenState createState() => _AddStreetScreenState();
}

class _AddStreetScreenState extends State<AddStreetScreen> {
  String name = "";
  int amount = 3;
  Color color;
  @override
  void initState() {
    super.initState();
    color = Color(widget.template.color ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text("Create street"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              autofocus: true,
              onChanged: (String val) => setState(() {
                name = val;
                setState(() {});
              }),
              decoration: InputDecoration(
                  labelText: "Street name", hintText: "test town"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 2,
              maxLengthEnforced: true,
              onChanged: (String val) => setState(() {
                amount = int.tryParse(val) ?? amount;
                setState(() {});
              }),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                helperText: "Amount of properties",
                hintText: "3",
              ),
            ),
          ),
          ValueSettingTile(
              setting: ValueSetting<Color>(
                  title: "Street color",
                  value: color,
                  onChanged: (dynamic val) {
                    color = val;
                    setState(() {});
                  })),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Template: " + widget.template.name),
          ),
        ],
      ),
      actions: [
        MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "cancel",
              style: TextStyle(color: Theme.of(context).primaryColor),
            )),
        MaterialButton(
            onPressed: () {
              String id = name[0];
              List<String> ids = Game.idPrefixs();
              while (ids.contains(id)) {
                if (name.length > id.length) {
                  id += name[id.length];
                } else {
                  id += "+";
                }
              }
              Navigator.pop(context);
              for (int i = 1; i <= amount; i++) {
                Game.data.gmap
                    .add(Tile.type(TileType.land, widget.template.idPrefix)
                      ..name = "$name $i"
                      ..color = color.value
                      ..idPrefix = id);
              }
              Game.save();
            },
            child: Text(
              "add",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ))
      ],
    );
  }
}
