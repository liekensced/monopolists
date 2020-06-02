import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:hive/hive.dart';
import 'package:plutopoly/helpers/main_helper.dart';

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
        expanded
            ? ListTile(
                title: Text("Primary color"),
                subtitle: Text("The primary color of this app"),
                trailing: CircleColor(
                  color: MainHelper.primaryColor,
                  circleSize: 40,
                  onColorChoose: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        Color newColor = Colors.teal;
                        return AlertDialog(
                            title: Text("Select primary color"),
                            content: MaterialColorPicker(
                              selectedColor: Colors.teal,
                              onColorChange: (Color c) {
                                newColor = c;
                              },
                            ),
                            actions: [
                              MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "cancel",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  )),
                              MaterialButton(
                                  onPressed: () {
                                    if (newColor == null) return;
                                    MainBloc.prefbox
                                        .put("primaryColor", newColor.value);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "select",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  )),
                            ]);
                      },
                    );
                  },
                ),
              )
            : Container(),
        expanded
            ? ListTile(
                title: Text("Accent color"),
                subtitle: Text("The accent color of this app"),
                trailing: CircleColor(
                  color: MainHelper.accentColor,
                  circleSize: 40,
                  onColorChoose: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        Color newColor = Colors.cyan;
                        return AlertDialog(
                            title: Text("Select accent color"),
                            content: MaterialColorPicker(
                              selectedColor: Colors.cyan,
                              onColorChange: (Color c) {
                                newColor = c;
                              },
                            ),
                            actions: [
                              MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "cancel",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  )),
                              MaterialButton(
                                  onPressed: () {
                                    if (newColor == null) return;
                                    MainBloc.prefbox
                                        .put("accentColor", newColor.value);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "select",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  )),
                            ]);
                      },
                    );
                  },
                ),
              )
            : Container(),
      ],
    );
  }
}
