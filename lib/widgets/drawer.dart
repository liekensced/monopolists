import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:plutopoly/screens/online_extension_page.dart';

import '../bloc/main_bloc.dart';
import '../bloc/ui_bloc.dart';
import '../screens/home/landing_page.dart';

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
              Navigator.pushNamed(context, "/stocktest");
            },
            child: ListTile(
              title: Text("Stock simulator"),
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
              title: Text("Info"),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return OnlineExtensionPage();
              }));
            },
            child: ListTile(
              title: Text("Online Extensions"),
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
              value: UIBloc.darkMode,
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
