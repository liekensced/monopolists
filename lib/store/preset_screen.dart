import 'package:flutter/material.dart';
import 'package:plutopoly/engine/data/main_data.dart';
import 'package:plutopoly/screens/extension_screen.dart';
import 'package:plutopoly/screens/games_card.dart';
import 'package:plutopoly/screens/home/start_online.dart';
import 'package:plutopoly/widgets/my_card.dart';

import '../bloc/main_bloc.dart';
import '../bloc/ui_bloc.dart';
import '../engine/data/tip.dart';
import '../engine/kernel/main.dart';
import '../engine/ui/game_navigator.dart';
import '../screens/start/info_screen.dart';
import '../widgets/end_of_list.dart';
import 'preset.dart';

class PresetScreen extends StatefulWidget {
  final Preset preset;

  const PresetScreen({
    Key key,
    this.preset,
  }) : super(key: key);

  @override
  _PresetScreenState createState() => _PresetScreenState();
}

class _PresetScreenState extends State<PresetScreen> {
  bool showSettings = false;
  GameData gameData;
  @override
  void initState() {
    gameData = widget.preset.data;
    showSettings = gameData.running == null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.preset.title),
      ),
      body: Container(
        constraints: BoxConstraints(maxWidth: UIBloc.maxWidth),
        child: Center(
          child: ListView(
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
                                  widget.preset.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(color: Colors.white),
                                  textAlign: TextAlign.start,
                                ),
                                Container(height: 4),
                                Text(widget.preset.description)
                              ],
                            ),
                          ),
                          flex: 3,
                        ),
                      ],
                    ),
                    Divider(),
                    ListTile(
                      title: Text("Launch with settings"),
                      trailing: Switch(
                        onChanged: (bool val) {
                          showSettings = val;
                          setState(() {});
                        },
                        value: showSettings,
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
                          "Start new local game",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )),
                  onPressed: () async {
                    MainBloc.cancelOnline();
                    Game.newGame(
                        gameData..running = showSettings ? null : false);

                    GameNavigator.navigate(context, loadGame: true);
                  },
                ),
              ),
              GamesCard(preset: widget.preset.projectName),
              StartOnlineButton(preset: widget.preset),
              Column(
                children: [
                  for (Info info in widget.preset.infoCards)
                    GeneralInfoCard(info: info)
                ],
              ),
              ExtensionsList(
                extensions: gameData.extensions,
              ),
              PresetInfoCard(
                preset: widget.preset,
              ),
              EndOfList()
            ],
          ),
        ),
      ),
    );
  }
}

class PresetInfoCard extends StatelessWidget {
  final Preset preset;

  const PresetInfoCard({Key key, @required this.preset}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: "info",
      smallTitle: true,
      children: [
        ListTile(
          title: Text("Author"),
          subtitle: Text(preset.author),
        ),
        ListTile(
          title: Text("Version"),
          subtitle: Text(preset.version),
        ),
      ],
    );
  }
}
