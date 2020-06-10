import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:plutopoly/bloc/game_listener.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/bloc/preset_bloc.dart';
import 'package:plutopoly/engine/data/tip.dart';
import 'package:plutopoly/engine/extensions/setting.dart';
import 'package:plutopoly/screens/start/info_screen.dart';
import 'package:plutopoly/store/preset.dart';
import 'package:plutopoly/widgets/my_card.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plutopoly/widgets/setting_tile.dart';

class PresetSettings extends StatelessWidget {
  Preset get preset => PresetBloc.preset;

  const PresetSettings({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Preset Settings"),
        ),
        body: ValueListenableBuilder(
          valueListenable: Hive.box(MainBloc.PRESETSBOX).listenable(),
          builder: (context, _, __) => ListView(
            children: [
              MyCard(
                listen: true,
                title: "settings",
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: preset.title,
                      onFieldSubmitted: (String val) {
                        preset.title = val;
                        preset.save();
                      },
                      decoration: InputDecoration(
                        labelText: "name",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: preset.version,
                      onFieldSubmitted: (String val) {
                        preset.version = val;
                        preset.save();
                      },
                      decoration: InputDecoration(
                        labelText: "version",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: preset.author,
                      onFieldSubmitted: (String val) {
                        preset.author = val;
                        preset.save();
                      },
                      decoration: InputDecoration(
                        labelText: "author",
                      ),
                    ),
                  ),
                ],
              ),
              ThemeCard(),
              MyCard(
                listen: true,
                title: "Info cards",
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("Tap on a info card to edit."),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text("Add info card"),
                      onPressed: () async {
                        dynamic val = await showDialog(
                          context: context,
                          builder: (context) {
                            return CreateInfoCardDialog();
                          },
                        );
                        if (val is Info) {
                          preset.infoCards.add(val);
                          preset.save();
                        }
                      },
                    ),
                  ),
                ],
              ),
              GameListener(
                builder: (context, __, _) => Column(
                  children: [
                    for (Info info in preset.infoCards)
                      InkWell(
                        onTap: () async {
                          dynamic val = await showDialog(
                            context: context,
                            builder: (context) {
                              return CreateInfoCardDialog(
                                info: info,
                              );
                            },
                          );
                          if (val is Info) {
                            preset.infoCards[preset.infoCards.indexOf(info)] =
                                val;
                            preset.save();
                          }
                          if (val == true) {
                            preset.infoCards.remove(info);
                            preset.save();
                          }
                        },
                        child: GeneralInfoCard(info: info),
                      )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class CreateInfoCardDialog extends StatefulWidget {
  final Info info;

  const CreateInfoCardDialog({Key key, this.info}) : super(key: key);
  @override
  _CreateInfoCardDialogState createState() => _CreateInfoCardDialogState();
}

class _CreateInfoCardDialogState extends State<CreateInfoCardDialog> {
  String title;
  InfoType type = InfoType.rule;
  String content;
  @override
  void initState() {
    title = widget.info?.title;
    content = widget.info?.content;
    type = widget.info?.type ?? InfoType.rule;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text("Add info card"),
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: title,
              onChanged: (String val) {
                title = val;
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: "title",
              ),
              autofocus: true,
            ),
          ),
          ListTile(
            title: Text("Select template"),
            trailing: DropdownButton(
                value: type,
                items: [
                  for (InfoType type in InfoType.values)
                    DropdownMenuItem(
                      child: Text(type.toString().split(".").last),
                      value: type,
                    )
                ],
                onChanged: (selectedType) =>
                    setState(() => type = selectedType)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: content,
              onChanged: (String val) {
                content = val;
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: "content",
              ),
            ),
          ),
        ],
      ),
      actions: [
        MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "close",
              style: TextStyle(color: Theme.of(context).primaryColor),
            )),
        MaterialButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(
              "delete",
              style: TextStyle(color: Colors.red),
            )),
        MaterialButton(
            onPressed: () {
              Navigator.pop(context,
                  Info(title ?? "title", content ?? "", type ?? InfoType.rule));
            },
            child: Text(
              "save",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ))
      ],
    );
  }
}

class ThemeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: "Theme",
      listen: true,
      children: [
        ValueSettingTile(
            setting: ValueSetting<Color>(
          title: "Primary color",
          subtitle: "The primary color of the app",
          onChanged: (dynamic val) {
            PresetBloc.preset.primaryColor = val?.value;
            PresetBloc.preset.save();
          },
          value: PresetBloc.preset.primaryColor == null
              ? null
              : Color(PresetBloc.preset.primaryColor),
        )),
        ValueSettingTile(
            setting: ValueSetting<Color>(
          title: "Accent color",
          subtitle: "The accent color of the app",
          onChanged: (dynamic val) {
            PresetBloc.preset.accentColor = val?.value;
            PresetBloc.preset.save();
          },
          value: PresetBloc.preset.accentColor == null
              ? null
              : Color(PresetBloc.preset.primaryColor),
        )),
      ],
    );
  }
}
