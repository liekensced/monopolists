import 'package:flutter/material.dart';
import 'package:plutopoly/screens/games_card.dart';
import 'package:plutopoly/screens/home/start_online.dart';

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
  @override
  void initState() {
    showSettings = widget.preset.data.running == null;
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
                    Game.newGame(await widget.preset.data
                      ..running = showSettings ? null : false);

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
              EndOfList()
            ],
          ),
        ),
      ),
    );
  }
}
