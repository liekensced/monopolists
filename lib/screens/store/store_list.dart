import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/store/preset_screen.dart';

import '../../store/default_presets.dart';
import '../../store/preset.dart';

class StoreList extends StatelessWidget {
  final List<Preset> inPresets;

  const StoreList({Key key, this.inPresets}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Preset> presets = inPresets ?? PresetHelper.defaultPresets;
    if (presets.isEmpty) {
      return Container(
          height: 220,
          child: Center(
              child: Text(
            "No presets found\nBuild one with the preset studio or drop one in the plutopoly folder.",
            textAlign: TextAlign.center,
          )));
    }
    return Container(
      height: 220,
      child: PageView.builder(
        controller: PageController(
            viewportFraction: min(
                UIBloc.maxWidth * 0.8 / MediaQuery.of(context).size.width,
                0.8)),
        itemCount: presets.length,
        itemBuilder: (BuildContext context, int index) {
          Preset preset = presets[index];
          bool noData = preset.data == null;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: OpenContainer(
              closedColor: Theme.of(context).cardColor,
              openBuilder: (context, _) {
                return PresetScreen(
                  preset: preset,
                );
              },
              tappable: !noData,
              closedBuilder: (contect, f) => Column(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    preset.title,
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(preset.description ?? "no description"),
                ),
                Flexible(
                  child: Container(),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                      primaryColor: Color(preset.primaryColor ??
                          Theme.of(context).primaryColor.value), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(preset.accentColor ??
                          Theme.of(context).colorScheme.secondary.value))),
                  child: Builder(
                    builder: (context) => Align(
                      alignment: Alignment.bottomCenter,
                      child: Tooltip(
                        message: noData
                            ? "Couldn't find game data. Can't open preset."
                            : "Open preset screen",
                        child: MaterialButton(
                          textColor: Theme.of(context).primaryColor,
                          child: Text("Open game"),
                          onPressed: noData
                              ? null
                              : () async {
                                  f();
                                },
                        ),
                      ),
                    ),
                  ),
                )
              ]),
            ),
          );
        },
      ),
    );
  }
}
