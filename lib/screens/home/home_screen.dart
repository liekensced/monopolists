import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'recent_card.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/kernel/main.dart';
import '../../engine/ui/alert.dart';
import '../../engine/ui/game_navigator.dart';
import '../../widgets/drawer.dart';
import '../games_card.dart';
import 'account_card.dart';
import 'join_online_card.dart';
import 'offline_page.dart';

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
                          title: Text("Plutopoly extended boardgame",
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
                body: Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 700),
                    child: ValueListenableBuilder(
                        valueListenable:
                            Hive.box(MainBloc.METABOX).listenable(),
                        builder: (BuildContext context, Box box, __) {
                          if (box.get("boolOnline", defaultValue: false)) {
                            if (MainBloc.gameId != null) return OfflinePage();
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
                                    MainBloc.cancelOnline();
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
                                    Alert alert =
                                        await MainBloc.newOnlineGame();
                                    if (Alert.handle(() => alert, context)) {
                                      GameNavigator.navigate(
                                        context,
                                      );
                                    }
                                  },
                                ),
                              ),
                              JoinOnlineCard(),
                              ValueListenableBuilder(
                                  valueListenable:
                                      Hive.box(MainBloc.METABOX).listenable(),
                                  builder: (context, Box box, _) {
                                    return RecentCard(box: box);
                                  }),
                              AccountCard()
                            ],
                          );
                        }),
                  ),
                )),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              ValueListenableBuilder(
                valueListenable: Hive.box(MainBloc.METABOX).listenable(),
                builder: (BuildContext context, Box box, _) {
                  if (box.get("boolOnline",
                      defaultValue: false)) if (MainBloc.gameId != null) {
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
                  }
                  return Container();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
