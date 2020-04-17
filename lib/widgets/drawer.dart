import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../bloc/main_bloc.dart';

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
                  .get("boolDark", defaultValue: true),
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
