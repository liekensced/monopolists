import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../bloc/main_bloc.dart';
import '../bloc/ui_bloc.dart';
import 'my_card.dart';

class SettingsCard extends StatefulWidget {
  @override
  _SettingsCardState createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: "Settings",
      children: [
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
        expanded
            ? ListTile(
                title: Text("Max width"),
                subtitle: Text(UIBloc.maxWidth.toString()),
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        double width = 700;
                        return AlertDialog(
                            title: Text("Change max width"),
                            content: TextField(
                              decoration:
                                  InputDecoration(hintText: width.toString()),
                              onChanged: (String val) {
                                width = double.tryParse(val) ?? 700.0;
                              },
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: false),
                            ),
                            actions: [
                              MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "close",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  )),
                              MaterialButton(
                                  onPressed: () {
                                    UIBloc.maxWidth = width;
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "change",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ))
                            ]);
                      },
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
              )
            : FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text("more settings"),
                onPressed: () {
                  expanded = true;
                  setState(() {});
                },
              ),
        expanded
            ? ListTile(
                title: Text("Is wide screen"),
                subtitle: Text("Shows 2 collumns if true"),
                trailing: Switch(
                  value: UIBloc.isWide(context),
                  onChanged: (value) {
                    if (UIBloc.isWide(context)) {
                      MainBloc.prefbox.put("doubleWideWidth",
                          MediaQuery.of(context).size.width + 10);
                      return;
                    }
                    MainBloc.prefbox.put("doubleWideWidth",
                        MediaQuery.of(context).size.width - 10);
                  },
                ),
              )
            : Container(),
      ],
    );
  }
}
