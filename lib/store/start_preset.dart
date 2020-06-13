import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/engine/data/player.dart';
import 'package:plutopoly/store/default_presets.dart';
import 'package:plutopoly/store/preset.dart';
import 'package:plutopoly/store/preset_studio.dart';
import 'package:plutopoly/widgets/my_card.dart';

class StartPresetScreen extends StatefulWidget {
  @override
  _StartPresetScreenState createState() => _StartPresetScreenState();
}

class _StartPresetScreenState extends State<StartPresetScreen> {
  String name = "test";
  String projectname;
  String template = "classic";
  String prefix;
  String suffix;
  List<Preset> presets;
  TextEditingController textEditingController;
  @override
  void initState() {
    prefix = prefixs[Random().nextInt(prefixs.length)];
    DateTime now = DateTime.now();
    suffix = now.month.toString() + now.day.toString();
    PresetHelper.localPresets.then((value) async {
      setState(() {
        presets = value;
      });
    });
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Player player = MainBloc.player;
    String pName =
        projectname ?? prefix + suffix + "." + player.name + "." + name;
    while (PresetHelper.findPreset(pName) != null) {
      pName += "+";
    }
    textEditingController.value = TextEditingValue(text: pName);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: FaIcon(
          FontAwesomeIcons.rocket,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return PresetStudio(
                preset: PresetHelper.newPreset(
              Preset(
                  title: name,
                  projectName: pName,
                  version: "0.0.1",
                  author: player.name,
                  template: template),
            ));
          }));
        },
      ),
      appBar: AppBar(
        title: Text("Start new preset"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            MyCard(
              title: "New preset",
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (String val) => setState(() => name = val),
                    decoration:
                        InputDecoration(labelText: "name", hintText: "test"),
                  ),
                ),
                ListTile(
                  title: Text("Select template"),
                  trailing: presets == null
                      ? CircularProgressIndicator()
                      : DropdownButton(
                          value: template,
                          items: [
                            DropdownMenuItem(
                              child: Text("classic"),
                              value: "classic",
                            ),
                            for (Preset preset in presets)
                              DropdownMenuItem(
                                child: Text(preset.title),
                                value: preset.projectName,
                              )
                          ],
                          onChanged: (selectedPreset) =>
                              setState(() => template = selectedPreset)),
                ),
              ],
            ),
            MyCard(
              title: "Advanced",
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: textEditingController,
                    onSubmitted: (val) => setState(() => projectname = val),
                    decoration: InputDecoration(
                        labelText: "project name",
                        helperMaxLines: 3,
                        helperText:
                            "Unique name used to identify this preset. Could be used as a filename."),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

const List<String> prefixs = [
  "web.",
  "com.",
  "net.",
  "app.",
  "map.",
  "dev.",
  "io."
];
