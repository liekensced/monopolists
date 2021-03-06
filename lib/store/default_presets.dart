import 'package:flutter/material.dart';
import 'package:plutopoly/store/default_presets/snakes_and_ladders.dart';
import 'package:plutopoly/store/default_presets_data.dart';

import '../bloc/main_bloc.dart';
import '../bloc/preset_bloc.dart';
import '../engine/data/main_data.dart';
import '../engine/data/tip.dart';
import '../engine/kernel/main.dart';
import '../helpers/file_helper.dart';
import 'preset.dart';

class PresetHelper {
  static Preset findPreset(String projectName) {
    if (projectName == null || projectName == "") return Preset.classic();

    Preset localPreset = defaultPresets.firstWhere(
        (element) => element.projectName == projectName,
        orElse: () => null);

    if (localPreset != null) return localPreset;
    localPreset = MainBloc.presetsBox.get(projectName);
    if (localPreset != null) return localPreset;
    return null;
  }

  static Preset newPreset(Preset _preset) {
    GameData gameData = GameData.fromJson(_preset.data.toJson());
    gameData.preset = _preset.projectName;
    _preset.dataCache = gameData;
    MainBloc.presetsBox.put(_preset.projectName, _preset);
    MainBloc.presetGamesBox.put(_preset.projectName, gameData);
    MainBloc.cancelOnline();
    MainBloc.studio = true;
    Game.data = gameData;
    PresetBloc.preset = _preset;
    return _preset;
  }

  static Future<List<Preset>> get localPresets async {
    return [...defaultPresets, ...(await FileHelper.getPresets() ?? [])]
        .where((element) => element.data != null)
        .toList()
        .cast<Preset>();
  }

  static List<Preset> defaultPresets = [
    Preset(
      projectName: "default.trainstations",
    )
      ..title = "The new frontier"
      ..author = "filorux"
      ..description =
          "Invest in an urban industrial city or a miner's outpost. Monopolize the coal and transportation industry and bankrupt your foes."
      ..primaryColor = Colors.deepOrange[800].value
      ..accentColor = Colors.deepOrangeAccent.value
      ..infoCards = [
        Info(
          "Train transportation",
          "There are a lot of trainstations. You can move between them, but you don't pass go.",
          InfoType.rule,
        ),
        Info(
          "10 houses",
          "The outposts can have up to 10 houses. The rent has changed a lot. Tap on a property to see the rent.",
          InfoType.rule,
        ),
        Info(
          "Rent changes",
          "Check the rent of properties by tapping on a property. ",
          InfoType.tip,
        ),
        Info(
          "Bot transportation",
          "Bots won't use your trainstations to move. The transportation price is unnecessary offline.",
          InfoType.alert,
        ),
      ]
      ..version = "1.0.2",
    Preset.fromJson(snakesAndLaddersData),
    Preset.fromJson(aiExample),
  ];
}
