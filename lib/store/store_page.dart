import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plutopoly/helpers/file_helper.dart';
import 'package:plutopoly/helpers/progress_helper.dart';
import 'package:plutopoly/screens/store/rewards_list.dart';
import 'package:plutopoly/store/preset_studio.dart';
import 'package:plutopoly/widgets/animated_count.dart';

import '../bloc/main_bloc.dart';
import '../screens/store/store_list.dart';
import '../widgets/end_of_list.dart';
import '../widgets/my_card.dart';
import 'default_presets.dart';
import 'preset.dart';
import 'start_preset.dart';

class StorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Store page"),
        actions: [
          Center(
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValueListenableBuilder(
                valueListenable: Hive.box(MainBloc.ACCOUNTBOX).listenable(),
                builder: (BuildContext context, _, __) {
                  return Row(
                    children: <Widget>[
                      AnimatedCount(
                        count: ProgressHelper.tickets,
                        duration: Duration(seconds: 1),
                      ),
                      Container(
                        height: 0,
                        width: 5,
                      ),
                      Icon(
                        Icons.local_activity,
                        size: 20,
                      )
                    ],
                  );
                },
              ),
            )),
          ),
          Container(
            width: 5,
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: Text(
              "Maps",
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.start,
            ),
          ),
          StoreList(),
          Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: Text(
              "Rewards",
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.start,
            ),
          ),
          StoreRewardsList(),
          Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Local maps",
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.start,
                ),
                IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () async {
                    String path = await FileHelper.presetsDir;
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            title: Text("Local presets"),
                            content: Text(
                                "Plutopoly looks in the presets map:\n$path\nIf you make a preset with the studio, the final preset will end up in this map. You can share that file and if others put it in there presets folder, they'll be able to play your map. If you start a online game, others do not need to install the map first."),
                            actions: [
                              MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "close",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ))
                            ]);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          kIsWeb
              ? Container(
                  height: 100,
                  child: Center(
                      child: Text(
                          "Download the android app to install unique maps!")),
                )
              : FutureBuilder<List<Preset>>(
                  future: FileHelper.getPresets(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.error != null) {
                        return Container(
                          height: 220,
                          child: Center(
                            child: Text("Failed to open files:\n" +
                                snapshot.error.toString()),
                          ),
                        );
                      } else {
                        return StoreList(
                          inPresets: snapshot.data ?? [],
                        );
                      }
                    } else {
                      return Container(
                        height: 220,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  }),
          Container(
            height: 50,
          ),
          ValueListenableBuilder(
            valueListenable: MainBloc.presetsBox.listenable(),
            builder: (context, _, __) => StudioCard(),
          ),
          EndOfList(),
        ],
      ),
    );
  }
}

class StudioCard extends StatelessWidget {
  const StudioCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> childs = [];
    Map<String, Preset> presets =
        MainBloc.presetsBox.toMap().cast<String, Preset>();
    presets.forEach((key, value) {
      childs.add(
        ListTile(
          onTap: () {
            PresetHelper.newPreset(value);
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return PresetStudio(preset: value);
            }));
          },
          title: Text(value.title),
          subtitle: Text(value.projectName),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              value.delete();
            },
          ),
        ),
      );
      childs.add(Divider());
    });
    if (childs.isEmpty) {
      childs.add(
        Container(
          height: 80,
          child: Center(
            child: Text("No open projects."),
          ),
        ),
      );
    } else {
      childs.removeLast();
    }
    return MyCard(
      title: "Studio (beta)",
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Create (or edit) your own unique maps!",
              textAlign: TextAlign.start,
            ),
          ),
        ),
        ...childs,
        Container(
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            child: Text("Start new project"),
            onPressed: () {
              if (kIsWeb) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: Text("Download android app"),
                        content: Text(
                            "To use this you need to download the android app. Note you can join a unique game!"),
                        actions: [
                          MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "close",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ))
                        ]);
                  },
                );
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return StartPresetScreen();
                }));
              }
            },
          ),
        ),
      ],
    );
  }
}
