import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../bloc/main_bloc.dart';
import '../engine/data/player.dart';
import '../engine/kernel/main.dart';
import '../engine/ui/alert.dart';
import '../engine/ui/game_navigator.dart';
import 'games_card.dart';
import 'start/players.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: Stack(
        children: <Widget>[
          FractionallySizedBox(
            heightFactor: 1,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 400.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Text("Monopolists Extended",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            )),
                        background: Padding(
                          padding: const EdgeInsets.all(75.0),
                          child: Center(
                            child: Container(
                              child: Image.asset(
                                "assets/logo.png",
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                        )),
                  ),
                ];
              },
              body: ValueListenableBuilder(
                  valueListenable: Hive.box(MainBloc.METABOX).listenable(),
                  builder: (BuildContext context, Box box, __) {
                    if (box.get("boolOnline", defaultValue: false)) {
                      if (MainBloc.gameId != null)
                        return ListView(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "You are still connected",
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(20),
                                    child: RaisedButton(
                                      textColor: Colors.white,
                                      color: Theme.of(context).primaryColor,
                                      child: Container(
                                          width: double.infinity,
                                          child: Text(
                                            "Rejoin game",
                                            textAlign: TextAlign.center,
                                          )),
                                      onPressed: () async {
                                        Alert alert = await MainBloc.joinOnline(
                                            MainBloc.gameId);
                                        if (Alert.handle(
                                            () => alert, context)) {
                                          GameNavigator.navigate(context);
                                        }
                                        GameNavigator.navigate(context);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                    }
                    return ListView(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Theme.of(context).primaryColor,
                            child: Container(
                                width: double.infinity,
                                child: Text(
                                  "Start new local game",
                                  textAlign: TextAlign.center,
                                )),
                            onPressed: () {
                              Game.newGame();
                              GameNavigator.navigate(context);
                            },
                          ),
                        ),
                        GamesCard(),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Theme.of(context).primaryColor,
                            child: Container(
                                width: double.infinity,
                                child: Text(
                                  "Start online game",
                                  textAlign: TextAlign.center,
                                )),
                            onPressed: () async {
                              Alert alert = await MainBloc.newOnlineGame();
                              if (Alert.handle(() => alert, context)) {
                                GameNavigator.navigate(context);
                              }
                            },
                          ),
                        ),
                        JoinOnlineCard(),
                        Card(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Account",
                                  style: Theme.of(context).textTheme.headline3,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              ValueListenableBuilder(
                                valueListenable:
                                    Hive.box(MainBloc.PREFBOX).listenable(),
                                builder: (BuildContext context, _, __) {
                                  Player player = MainBloc.player;
                                  return ListTile(
                                    title: Text(
                                        player.name ?? "Please change name"),
                                    trailing: CircleColor(
                                      color: Color(player.color),
                                      circleSize: 20,
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: RaisedButton(
                                  textColor: Colors.white,
                                  color: Theme.of(context).primaryColor,
                                  child: Container(
                                      width: double.infinity,
                                      child: Text(
                                        "Change player",
                                        textAlign: TextAlign.center,
                                      )),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AddPlayerDialog(
                                            prefPlayer: true);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              ValueListenableBuilder(
                valueListenable: Hive.box(MainBloc.METABOX).listenable(),
                builder: (BuildContext context, Box box, _) {
                  if (!box.get("boolOnline", defaultValue: false))
                    return Container();
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: FloatingActionButton.extended(
                          onPressed: () {
                            MainBloc.cancelOnline();
                          },
                          label: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Cancel game connection",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class JoinOnlineCard extends StatefulWidget {
  const JoinOnlineCard({
    Key key,
  }) : super(key: key);

  @override
  _JoinOnlineCardState createState() => _JoinOnlineCardState();
}

class _JoinOnlineCardState extends State<JoinOnlineCard> {
  String gamePin = "";

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: Text(
              "Join game",
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.start,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (val) {
                gamePin = val;
                // if (mounted) setState(() {});
              },
              decoration: InputDecoration(labelText: "Enter game pin"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: RaisedButton(
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                child: Container(
                    width: double.infinity,
                    child: Text(
                      "Join",
                      textAlign: TextAlign.center,
                    )),
                onPressed: () async {
                  //"hYN1GZlPy0b0WZ0uc714"
                  Alert alert = await MainBloc.joinOnline(gamePin);
                  if (Alert.handle(() => alert, context)) {
                    GameNavigator.navigate(context);
                  }
                }),
          ),
        ],
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Spacer(),
          ListTile(
            title: Text("Hide system overlays"),
            trailing: Switch(
              value: Hive.box(MainBloc.PREFBOX)
                  .get("boolOverlays", defaultValue: true),
              onChanged: (value) {
                Hive.box(MainBloc.PREFBOX).put(
                    "boolOverlays",
                    !Hive.box(MainBloc.PREFBOX)
                        .get("boolOverlays", defaultValue: true));
                if (!MainBloc.hideOverlays) {
                  SystemChrome.setEnabledSystemUIOverlays([
                    SystemUiOverlay.bottom,
                    SystemUiOverlay.bottom,
                  ]);
                  SystemChrome.restoreSystemUIOverlays();
                } else {
                  SystemChrome.setEnabledSystemUIOverlays([]);
                  SystemChrome.restoreSystemUIOverlays();
                }
              },
            ),
          ),
          ListTile(
            title: Text("Dark mode"),
            trailing: Switch(
              value: Hive.box(MainBloc.PREFBOX)
                  .get("boolDark", defaultValue: false),
              onChanged: (value) {
                MainBloc.toggleDarkMode();
              },
            ),
          ),
          Container(
            height: 50,
            child: Center(
              child: Text("Filorux"),
            ),
          )
        ],
      ),
    );
  }
}
