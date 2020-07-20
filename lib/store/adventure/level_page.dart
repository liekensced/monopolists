import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../bloc/main_bloc.dart';
import '../../bloc/ui_bloc.dart';
import '../../engine/data/main_data.dart';
import '../../engine/data/tip.dart';
import '../../screens/extension_screen.dart';
import '../../screens/home/adventure_page.dart';
import '../../screens/start/info_screen.dart';
import '../../widgets/end_of_list.dart';
import '../../widgets/my_card.dart';
import '../preset.dart';
import '../preset_screen.dart';
import 'adventure_data.dart';

class LevelPage extends StatelessWidget {
  final Level level;
  final AdventureLand land;
  final LevelProgress progress;

  const LevelPage(
      {Key key,
      @required this.level,
      @required this.land,
      @required this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Preset preset = level.preset;
    String levelId = level.id(land);

    GameData openedGame = Hive.box(MainBloc.GAMESBOX)
        .values
        .toList()
        .whereType<GameData>()
        .toList()
        .firstWhere((element) => element.levelId == levelId,
            orElse: () => null);
    bool gameOpen = openedGame != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(preset.title),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: UIBloc.maxWidth),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Center(
                                  child: Icon(
                            Icons.map,
                            size: 50,
                          ))),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    preset.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(color: Colors.white),
                                    textAlign: TextAlign.start,
                                  ),
                                  Container(height: 4),
                                  Text(preset.description ?? "no description")
                                ],
                              ),
                            ),
                            flex: 3,
                          ),
                        ],
                      ),
                      Divider(),
                      ListTile(
                        title: Text("Launch in hard mode"),
                        trailing: Tooltip(
                          message: "Coming soon",
                          child: Switch(
                            onChanged: null,
                            value: false,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            gameOpen ? "Continue game" : "Start new game",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    onPressed: () {
                      openLevel(gameOpen, openedGame, preset, levelId, context);
                    },
                  ),
                ),
                MyCard(
                  title: 'Stats',
                  children: [
                    Stars(level: level, land: land),
                    ListTile(
                      title: Text("Best time:"),
                      trailing: Text(progress.best.toString()),
                    ),
                    ListTile(
                      title: Text("Turns needed for 2 stars"),
                      subtitle: Text(
                          "If you win in these turns you get an extra star"),
                      trailing: Text(level.turnsNeeded.toString()),
                    ),
                  ],
                ),
                Column(
                  children: [
                    for (Info info in preset.infoCards)
                      GeneralInfoCard(info: info)
                  ],
                ),
                ExtensionsList(
                  extensions: preset.data.extensions,
                ),
                PresetInfoCard(
                  preset: preset,
                ),
                FeedbackCrad(preset: preset),
                EndOfList()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeedbackCrad extends StatelessWidget {
  const FeedbackCrad({
    Key key,
    @required this.preset,
  }) : super(key: key);

  final Preset preset;

  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: "Feedback",
      smallTitle: true,
      children: [
        ListTile(
          onTap: () {
            launchUrl(String body) {
              Navigator.pop(context);

              UIBloc.launchUrl(
                context,
                "mailto:filoruxonline+plutopoly@gmail.com?subject=Level ${preset.projectName} v${preset.version} feedback&body=Plutopoly version ${MainBloc.version} ${kIsWeb ? "web" : "android"}. <br />This level is $body",
              );
              AwesomeDialog(
                      dialogType: DialogType.SUCCES,
                      context: context,
                      body: Text("Thanks for your feedback!"))
                  .show();
            }

            showBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("This level is"),
                      )),
                      ListTile(
                        title: Text("too long"),
                        onTap: () => launchUrl("too long"),
                      ),
                      ListTile(
                        title: Text("too hard"),
                        onTap: () => launchUrl("too hard"),
                      ),
                      ListTile(
                        title: Text("boring"),
                        onTap: () => launchUrl("boring"),
                      ),
                      ListTile(
                        title: Text("nice"),
                        onTap: () => launchUrl("nice"),
                      )
                    ],
                  );
                });
          },
          title: Text("Send feedback about this level."),
          trailing: Icon(Icons.feedback),
        )
      ],
    );
  }
}
