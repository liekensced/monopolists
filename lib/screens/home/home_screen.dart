import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plutopoly/screens/home/adventure_screen.dart';
import 'package:plutopoly/screens/store/store_list.dart';
import 'package:plutopoly/store/store_page.dart';

import '../../bloc/main_bloc.dart';
import '../../bloc/ui_bloc.dart';
import '../../engine/kernel/main.dart';
import '../../widgets/ad.dart';
import '../../widgets/ad_message.dart';
import '../../widgets/drawer.dart';
import '../../widgets/end_of_list.dart';
import '../../widgets/my_card.dart';
import '../../widgets/settings_card.dart';
import '../games_card.dart';
import '../start/info_screen.dart';
import '../start/start_game.dart';
import '../version_screen.dart';
import 'account_card.dart';
import 'join_online_card.dart';
import 'landing_page.dart';
import 'offline_page.dart';
import 'recent_card.dart';
import 'start_online.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final NativeAdmobController _adController =
      kIsWeb ? null : NativeAdmobController();
  PageController pageController;
  @override
  void initState() {
    pageController = PageController(initialPage: 1);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration.zero, () {
        UIBloc.showAlerts(context);
      });
    });
    super.initState();
  }

  int currentPage = 1;

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
      floatingActionButton: ColorActionButton(),
      drawer: MyDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (int page) {
          currentPage = page;
          pageController.jumpToPage(page);
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text("Adventure")),
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(icon: Icon(Icons.shop), title: Text("Store")),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (int newPage) {
          currentPage = newPage;
          setState(() {});
        },
        children: [
          AdventureScreen(),
          Stack(
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 75.0),
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
                                        Hive.box(MainBloc.RECENTBOX)
                                            .listenable(),
                                    builder: (context, Box box, _) {
                                      return RecentCard(
                                        box: box,
                                        active: true,
                                      );
                                    }),
                                Center(
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: UIBloc.maxWidth),
                                    padding: EdgeInsets.all(20),
                                    child: RaisedButton(
                                      color: Theme.of(context).primaryColor,
                                      child: Container(
                                          width: UIBloc.maxWidth,
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
                                      onPressed: () {
                                        MainBloc.cancelOnline();
                                        Game.newGame();
                                        Navigator.push(context,
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return StartGameScreen();
                                        }));
                                      },
                                    ),
                                  ),
                                ),
                                GamesCard(),
                                StartOnlineButton(),
                                JoinOnlineCard(),
                                ADView(
                                  controller: _adController,
                                ),
                                ValueListenableBuilder(
                                    valueListenable:
                                        Hive.box(MainBloc.RECENTBOX)
                                            .listenable(),
                                    builder: (context, Box box, _) {
                                      return RecentCard(box: box);
                                    }),
                                IconDivider(
                                  icon: Icon(
                                    Icons.store,
                                    size: 40,
                                  ),
                                ),
                                StoreList(),
                                IconDivider(
                                  icon: Icon(
                                    Icons.settings,
                                    size: 40,
                                  ),
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
                                  show: kIsWeb,
                                  title: "Android app",
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          UIBloc.launchUrl(context,
                                              "https://play.google.com/store/apps/details?id=web.filorux.plutopoly");
                                        },
                                        child: ListTile(
                                          title: Text("Download android app"),
                                          subtitle: Text(
                                              "Download the android app for Faster performance and less bugs!"),
                                          trailing: Icon(Icons.open_in_new),
                                          onTap: () async {
                                            String url = MainBloc.website;
                                            UIBloc.launchUrl(context, url);
                                          },
                                        ))
                                  ],
                                ),
                                ADView(
                                  large: true,
                                  controller: _adController,
                                ),
                                Image.asset("assets/wide.png"),
                                EndOfList()
                              ],
                            );
                          }),
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
                                heroTag: "Cancel game connection",
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
          StorePage()
        ],
      ),
    );
  }
}

class ColorActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).primaryColor.value != Colors.teal.value ||
        Theme.of(context).accentColor.value != Colors.cyan.value) {
      return Tooltip(
        message: "Reset colors",
        child: FloatingActionButton(
          child: Icon(Icons.colorize, color: Colors.white),
          onPressed: UIBloc.resetColors,
        ),
      );
    }
    return Container();
  }
}
