import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../bloc/main_bloc.dart';
import '../bloc/ui_bloc.dart';
import '../screens/home/landing_page.dart';
import '../screens/testing/stock_testing_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.maxFinite,
            color: Theme.of(context).primaryColor,
            child: DrawerHeader(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "Plutopoly extended boardgame",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return StockTestingScreen();
              }));
            },
            child: ListTile(
              title: Text("Stock simulator"),
              trailing: Icon(Icons.open_in_new),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return LandingPage();
              }));
            },
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text("Info"),
              trailing: Icon(Icons.open_in_new),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {
              showAboutDialog(
                  context: context,
                  applicationName: "Plutopoly",
                  applicationVersion: MainBloc.version,
                  applicationIcon: Image.asset(
                    "assets/logo.png",
                    width: 40,
                    height: 40,
                  ));
            },
            child: ListTile(
              title: Text("About plutopoly"),
              trailing: Icon(Icons.open_in_new),
            ),
          ),
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
                if (!UIBloc.hideOverlays) {
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
                  .get("boolDark", defaultValue: true),
              onChanged: (value) {
                UIBloc.toggleDarkMode();
              },
            ),
          ),
          Container(
            height: 50,
            child: Center(
              child: Text("Filorux v" + MainBloc.version),
            ),
          )
        ],
      ),
    );
  }
}
