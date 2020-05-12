import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plutopoly/screens/start/start_game.dart';
import '../../bloc/ui_bloc.dart';
import 'landing_page.dart';
import '../start/info_screen.dart';
import '../version_screen.dart';
import '../../widgets/ad.dart';
import '../../widgets/ad_message.dart';
import '../../widgets/end_of_list.dart';
import '../../widgets/my_card.dart';
import '../../widgets/settings_card.dart';
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
  final NativeAdmobController _adController = NativeAdmobController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration.zero, () {
        UIBloc.showAlerts(context);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Hive.box(MainBloc.PREFBOX).get("boolLanding", defaultValue: true)) {
      return LandingPage();
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

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
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                child: Image.asset(
                                  UIBloc.isWide(context)
                                      ? "assets/wide.png"
                                      : "assets/logo.png",
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
                    constraints: BoxConstraints(maxWidth: UIBloc.maxWidth),
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
                              ValueListenableBuilder(
                                  valueListenable:
                                      Hive.box(MainBloc.RECENTBOX).listenable(),
                                  builder: (context, Box box, _) {
                                    return RecentCard(
                                      box: box,
                                      active: true,
                                    );
                                  }),
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: OpenContainer(
                                  closedColor: Theme.of(context).primaryColor,
                                  openColor: Theme.of(context).canvasColor,
                                  closedBuilder: (_, f) => InkWell(
                                    child: Container(
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            "Start new local game",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                    onTap: () {
                                      MainBloc.cancelOnline();
                                      Game.newGame();
                                      f();
                                    },
                                  ),
                                  openBuilder: (_, __) {
                                    return StartGameScreen();
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
                                      Hive.box(MainBloc.RECENTBOX).listenable(),
                                  builder: (context, Box box, _) {
                                    return RecentCard(box: box);
                                  }),
                              IconDivider(
                                icon: Icon(
                                  Icons.settings,
                                  size: 40,
                                ),
                              ),
                              ADView(
                                controller: _adController,
                              ),
                              AccountCard(),
                              SettingsCard(),
                              VersionCard(),
                              IconDivider(
                                icon: Icon(
                                  Icons.whatshot,
                                  size: 40,
                                ),
                              ),
                              MyCard(
                                title: "Add ad",
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (kIsWeb) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                                title: Text("No ads on web"),
                                                content: Text(
                                                    "There are no daily ads on the web version."),
                                                actions: [
                                                  MaterialButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "close",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ))
                                                ]);
                                          },
                                        );
                                        return;
                                      }
                                      int amount = Hive.box(MainBloc.METABOX)
                                          .get("intAdDays", defaultValue: 0);
                                      Hive.box(MainBloc.METABOX)
                                          .put("intAdDays", amount + 1);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                          "Tap to add an ad to daily ads."),
                                    ),
                                  )
                                ],
                              ),
                              ADView(
                                large: true,
                                controller: _adController,
                              ),
                              EndOfList()
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
              ValueListenableBuilder(
                  valueListenable: MainBloc.metaBox.listenable(),
                  builder: (context, snapshot, _) {
                    return DailyAdsMessage();
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
