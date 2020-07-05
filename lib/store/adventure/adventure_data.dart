import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:plutopoly/bloc/main_bloc.dart';

import '../default_presets.dart';
import '../preset.dart';

part 'adventure_data.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 21)
class AdventureLand extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String description;
  @HiveField(2)
  List<Level> levels;

  String id(Level level) =>
      "default/" + name + "/" + levels.indexOf(level).toString();

  AdventureLand({
    @required this.name,
    @required this.description,
    @required this.levels,
  });

  factory AdventureLand.fromJson(Map<String, dynamic> json) =>
      _$AdventureLandFromJson(json);
  Map<String, dynamic> toJson() => _$AdventureLandToJson(this);
}

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 22)
class Level extends HiveObject {
  @HiveField(1)
  String presetName;

  @HiveField(2)
  int turnsNeeded;

  @HiveField(3)
  Preset presetCache;

  Preset get preset => presetCache ?? PresetHelper.findPreset(presetName);

  String id(AdventureLand land) => land.id(this);

  Level({
    this.turnsNeeded: 15,
    this.presetCache,
    this.presetName,
  });

  factory Level.fromJson(Map<String, dynamic> json) => _$LevelFromJson(json);
  Map<String, dynamic> toJson() => _$LevelToJson(this);
}

List<AdventureLand> classicAdventure = [
  AdventureLand(
      name: "Classic isles",
      description:
          "Welcome to the classic isles. This island is to oldest place known to humans and the birthplace of plutopoly.",
      levels: [
        Level(
          presetCache: Preset.classic()
            ..description = "The first level."
            ..title = "Standard classic",
        ),
        Level(
          presetCache: Preset.classic()
            ..description = "The first level."
            ..title = "Standard classic",
        ),
      ]),
  AdventureLand(
      name: "Classic isles",
      description:
          "Welcome to the classic isles. This island is to oldest place known to humans and the birthplace of plutopoly.",
      levels: [
        Level(
          presetCache: Preset.classic()
            ..description = "The first level."
            ..title = "Standard classic",
        ),
      ]),
  AdventureLand(
      name: "Classic isles",
      description:
          "Welcome to the classic isles. This island is to oldest place known to humans and the birthplace of plutopoly.",
      levels: [
        Level(
          presetCache: Preset.classic()
            ..description = "The first level."
            ..title = "Standard classic",
        ),
      ]),
  AdventureLand(
      name: "Classic isles",
      description:
          "Welcome to the classic isles. This island is to oldest place known to humans and the birthplace of plutocracy.",
      levels: [
        Level(
          presetCache: Preset.classic()
            ..description = "The first level."
            ..title = "Standard classic",
        ),
        Level(
          presetCache: Preset.classic()
            ..description = "The second level."
            ..title = "Standard classic",
        ),
      ])
];

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 23)
class LevelProgress extends HiveObject {
  @HiveField(0)
  int stars = 0;
  @HiveField(1)
  int best = null;

  LevelProgress();

  factory LevelProgress.get(String id) {
    return Hive.box(MainBloc.ACCOUNTBOX)
        .get("levels/" + id, defaultValue: LevelProgress());
  }

  factory LevelProgress.fromJson(Map<String, dynamic> json) =>
      _$LevelProgressFromJson(json);
  Map<String, dynamic> toJson() => _$LevelProgressToJson(this);
}
