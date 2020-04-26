import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/data/tip.dart';
import '../../engine/extensions/bank/bank.dart';
import '../../widgets/end_of_list.dart';
import '../../widgets/my_card.dart';
import '../start/info_screen.dart';
import 'account_card.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.navigate_next,
          color: Colors.white,
        ),
        onPressed: () {
          if (_tabController.index == 0) {
            _tabController.animateTo(1);
            setState(() {});
          } else {
            if (MainBloc.player.name == "null") {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: Text("Account setup"),
                      content: Text("Please change your account settings"),
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
              if (!Hive.box(MainBloc.PREFBOX)
                  .get("boolLanding", defaultValue: true)) {
                Navigator.pop(context);
              }
              Hive.box(MainBloc.PREFBOX).put("boolLanding", false);
            }
          }
        },
      ),
      body: Stack(
        children: <Widget>[
          FractionallySizedBox(
            heightFactor: 1,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 600.0,
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Welcome!",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      .copyWith(color: Colors.white),
                                ),
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  child: Image.asset(
                                    MainBloc.isWide(context)
                                        ? "assets/wide.png"
                                        : "assets/logo.png",
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                                Icon(Icons.arrow_downward)
                              ],
                            ),
                          ),
                        )),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      constraints: BoxConstraints(maxWidth: 700),
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          kIsWeb
                              ? MyCard(
                                  title: "To our web users",
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                          "This is a Progressive Web App (PWA), which means:"),
                                    ),
                                    ListTile(
                                      title: Text("All data is stored"),
                                      subtitle: Text(
                                          "All your settings won't be lost. You can even open this site offline!"),
                                      leading: Icon(Icons.storage),
                                    ),
                                    Divider(),
                                    ListTile(
                                      title: Text("Installable"),
                                      subtitle: Text(
                                          "Install the app (add to homescreen on mobile) and make it act like any other application."),
                                      leading: Icon(Icons.file_download),
                                    ),
                                    Divider(),
                                    ListTile(
                                      title: Text("Mouse scroll"),
                                      subtitle: Text(
                                          "To scroll on desktop you have to click and drag. Sorry for the inconvenience"),
                                      leading: Icon(Icons.expand_more),
                                    )
                                  ],
                                )
                              : Container(),
                          MyCard(
                            title: "Play Locally",
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.crop_square,
                                      size: 50,
                                    ),
                                    Container(width: 5),
                                    Icon(
                                      Icons.add,
                                      size: 50,
                                    ),
                                    Container(width: 5),
                                    Icon(
                                      Icons.phone_android,
                                      size: 50,
                                    )
                                  ],
                                ),
                              ),
                              Container(height: 10),
                              Text(
                                  "You can play with or without board and it will:"),
                              Container(height: 10),
                              ListTile(
                                title: Text("Remember everything"),
                                subtitle: Text(
                                    "It remembers evertything so you can contiue playing at a later time."),
                              ),
                              Divider(),
                              ListTile(
                                title: Text("Add start bonus"),
                                subtitle: Text("It can do tasks automatically"),
                              ),
                              Divider(),
                              ListTile(
                                title: Text("Add extensions!"),
                              )
                            ],
                          ),
                          MyCard(
                            title: "Play Online",
                            children: [
                              Container(height: 10),
                              Text(
                                  "You can easily play online with friends just:"),
                              Container(height: 10),
                              ListTile(
                                leading: Text(
                                  "1.",
                                  style: TextStyle(fontSize: 20),
                                ),
                                title: Text("Start a new online game"),
                                subtitle: Text(
                                    "and configure the game to your heart's content"),
                              ),
                              Divider(),
                              ListTile(
                                leading: Text(
                                  "2.",
                                  style: TextStyle(fontSize: 20),
                                ),
                                title: Text("Share the game pin"),
                                subtitle:
                                    Text("Share the pin with your friends"),
                              ),
                              Divider(),
                              ListTile(
                                leading: Text(
                                  "3.",
                                  style: TextStyle(fontSize: 20),
                                ),
                                title: Text("Start playing!"),
                              )
                            ],
                          ),
                          GeneralInfoCard(
                              info: Info(
                                  "Play daily",
                                  "You don't have to play in one sitting. You could play every day 5 rounds.",
                                  InfoType.tip)),
                          MyCard(
                            title: "Extensions",
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                    "You can add extensions to make your game more interesting, like:"),
                              ),
                              ListTile(
                                leading: Bank.icon(),
                                title: Text("Banking"),
                                subtitle: Text(
                                    "Adds loans and interests to the game."),
                              ),
                              ListTile(
                                leading: FaIcon(FontAwesomeIcons.chartLine),
                                title: Text("Stocks"),
                                subtitle:
                                    Text("Invest extra cash in the market."),
                              ),
                            ],
                          ),
                          Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Click bottom-right to continue"),
                          )),
                          EndOfList()
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        AccountCard(welcome: true),
                        Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Click bottom-right to continue"),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
