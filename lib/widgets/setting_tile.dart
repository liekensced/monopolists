import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/bloc/game_listener.dart';
import 'package:plutopoly/engine/data/extensions.dart';
import 'package:plutopoly/engine/extensions/setting.dart';
import 'package:plutopoly/engine/kernel/main.dart';

class SettingTile extends StatefulWidget {
  final Setting setting;
  final Extension ext;

  const SettingTile({Key key, @required this.setting, this.ext})
      : super(key: key);
  @override
  _SettingTileState createState() => _SettingTileState();
}

class _SettingTileState extends State<SettingTile> {
  Setting get setting => widget.setting;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(setting.title),
      subtitle: Text(setting.subtitle),
      trailing: buildTrailing(),
    );
  }

  Widget buildTrailing() {
    if (Game.data == null)
      return Container(
        width: 0,
      );
    if (widget.ext != null) {
      if (!Game.data.extensions.contains(widget.ext)) {
        return Container(
          width: 0,
        );
      }
    }
    if (setting.value is bool Function()) {
      return GameListener(builder: (c, _, __) {
        bool val = setting.value() as bool;
        return Switch(value: val, onChanged: setting.onChanged);
      });
    }

    if (setting.value is int Function()) {
      return IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                String value = "";
                return AlertDialog(
                    title: Text("Change value"),
                    content: TextField(
                        onChanged: (String val) {
                          value = val;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: setting.value().toString())),
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
                            int number = int.tryParse(value);
                            if (number != null) {
                              setting.onChanged(number);
                            }
                            Navigator.pop(context);
                          },
                          child: Text(
                            "change",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )),
                    ]);
              },
            );
          });
    }

    return Tooltip(
        child: FaIcon(FontAwesomeIcons.questionCircle),
        message: "Unknown type: " + setting.value.runtimeType.toString());
  }
}

class ValueSettingTile extends StatefulWidget {
  final ValueSetting setting;
  final Extension ext;

  const ValueSettingTile({Key key, @required this.setting, this.ext})
      : super(key: key);
  @override
  _ValueSettingTileState createState() => _ValueSettingTileState();
}

class _ValueSettingTileState extends State<ValueSettingTile> {
  ValueSetting get setting => widget.setting;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(setting.title),
      subtitle: Text(setting.subtitle),
      trailing: buildTrailing(),
    );
  }

  Widget buildTrailing() {
    if (Game.data == null)
      return Container(
        width: 0,
      );
    if (widget.ext != null) {
      if (!Game.data.extensions.contains(widget.ext)) {
        return Container(
          width: 0,
        );
      }
    }
    if (setting.value is bool) {
      return GameListener(builder: (c, _, __) {
        bool val = setting.value as bool;
        return Switch(
            value: val,
            onChanged: (bool val) {
              setting.onChanged(val);
              Game.save();
            });
      });
    }

    if (setting.value is int) {
      return IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                String value = "";
                return AlertDialog(
                    title: Text("Change value"),
                    content: TextField(
                        onChanged: (String val) {
                          value = val;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: setting.value.toString())),
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
                            int number = int.tryParse(value);
                            if (number != null) {
                              setting.onChanged(number);
                            }
                            Navigator.pop(context);
                            Game.save();
                          },
                          child: Text(
                            "change",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )),
                    ]);
              },
            );
          });
    }

    if (setting.value is String) {
      return IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                String value = "";
                return AlertDialog(
                    title: Text("Change value"),
                    content: TextField(
                        onChanged: (String val) {
                          value = val;
                        },
                        decoration: InputDecoration(hintText: setting.value)),
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
                            setting.onChanged(value);

                            Navigator.pop(context);
                            Game.save();
                          },
                          child: Text(
                            "change",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )),
                    ]);
              },
            );
          });
    }

    return Tooltip(
        child: FaIcon(FontAwesomeIcons.questionCircle),
        message: "Unknown type: " + setting.value.runtimeType.toString());
  }
}
