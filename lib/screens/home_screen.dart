import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:monopolists/engine/ui/game_navigator.dart';

import '../bloc/main_bloc.dart';
import '../engine/kernel/main.dart';
import 'games_card.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              Spacer(),
              ListTile(
                title: Text("Dark mode"),
                trailing: Switch(
                  value: Hive.box(MainBloc.PREFBOX)
                      .get("boolDark", defaultValue: false),
                  onChanged: (value) {
                    MainBloc.toggleDarkMode();
                  },
                ),
              )
            ],
          ),
        ),
        body: FractionallySizedBox(
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
            body: ListView(
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
              ],
            ),
          ),
        ));
  }
}
