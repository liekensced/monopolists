import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plutopoly/helpers/progress_helper.dart';
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
              padding: EdgeInsets.all(2),
              child: Column(
                children: [
                  Expanded(
                      child: Center(
                    child: Text("Plutopoly extended boardgame"),
                  )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ProgressListTile(),
                  ),
                ],
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
                  ),
                  children: [
                    ListTile(
                      title: Text("Open website"),
                      subtitle: Text(
                          "Visit our website for extra information, news and more"),
                      trailing: Icon(Icons.open_in_new),
                      onTap: () async {
                        String url = MainBloc.website;
                        UIBloc.launchUrl(context, url);
                      },
                    )
                  ]);
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
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
                    SystemUiOverlay.bottom,
                    SystemUiOverlay.bottom,
                  ]);
                  SystemChrome.restoreSystemUIOverlays();
                } else {
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
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

class ProgressListTile extends StatelessWidget {
  final bool leading;
  const ProgressListTile({
    Key key,
    this.leading: true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(MainBloc.ACCOUNTBOX).listenable(),
        builder: (context, __, _) {
          return ListTile(
            leading: leading
                ? CircleColor(
                    elevation: 0,
                    color: Color(MainBloc.player?.color ?? Colors.white.value),
                    circleSize: 40)
                : Container(
                    width: 0,
                  ),
            title: Text(
              MainBloc.player?.name ?? "unknown",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              ProgressHelper.level.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            subtitle: LinearProgressIndicator(
              value: ProgressHelper.levelProgress,
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary),
            ),
          );
        });
  }
}
