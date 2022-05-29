import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/ai/ai_type.dart';
import '../../engine/kernel/main.dart';
import '../../helpers/progress_helper.dart';
import '../default_presets.dart';
import '../preset.dart';
import 'levels/classic_adventure_lands.dart';

part 'adventure_data.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 24)
class AdventureData extends HiveObject {
  @HiveField(0)
  List<AdventureLand> lands;
  @HiveField(1)
  String name;
  @HiveField(2)
  String description;

  AdventureData({
    this.lands,
    this.name,
    this.description,
  });
  factory AdventureData.get(String id) {
    return defaultAdventures[id];
  }

  factory AdventureData.fromJson(Map<String, dynamic> json) =>
      _$AdventureDataFromJson(json);
  Map<String, dynamic> toJson() => _$AdventureDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 21)
class AdventureLand extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final List<Level> levels;
  @HiveField(3)
  final bool open;
  @HiveField(4)
  final String parent;

  String get landPath =>
      "adventures/$parent/" +
      defaultAdventures[parent]
          .lands
          .indexWhere((element) => element == this)
          .toString() +
      "/";

  bool isOpen() {
    if (open == true) return true;
    return Hive.box(MainBloc.ACCOUNTBOX).get(landPath, defaultValue: false);
  }

  factory AdventureLand.get(String levelId) {
    List<String> path = levelId.split("/");
    return defaultAdventures[path[1]].lands[int.tryParse(path[2]) ?? 0];
  }

  void unLock() {
    Box box = Hive.box(MainBloc.ACCOUNTBOX);
    if (box.get(landPath) != true) {
      OverlaySupportEntry entry = showSimpleNotification(
        Text(
          "You unlocked $name!",
          style: TextStyle(color: Colors.white),
        ),
        autoDismiss: false,
        slideDismiss: true,
        subtitle: Text(
          "Take a look on the adventure map",
          style: TextStyle(color: Colors.white),
        ),
        leading: Icon(
          Icons.map,
          color: Colors.white,
        ),
      );
      Future.delayed(Duration(seconds: 12), () {
        entry?.dismiss(animate: true);
      });
    }
    box.put(landPath, true);
  }

  String levelID(Level level) => landPath + levels.indexOf(level).toString();

  AdventureLand({
    @required this.name,
    @required this.description,
    @required this.levels,
    @required this.parent,
    this.open: false,
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

  String id(AdventureLand land) => land.levelID(this);

  Level({
    this.turnsNeeded: 15,
    this.presetCache,
    this.presetName,
  });
  Level.adventure({
    this.turnsNeeded: 30,
    @required this.presetCache,
    @required String title,
    @required String description,
    @required int index,
    Function() onFinished,
    Function() onLaunch,
  }) {
    presetCache.title = title;
    presetCache.description = description;
    presetCache.data?.onLaunch = onLaunch;
    presetCache.data?.settings?.maxTurnes =
        min(100, presetCache.data.settings.maxTurnes);
    if (onFinished == null) {
      presetCache.data?.onFinished = () => defaultOnFinished(index);
    } else {
      presetCache.data?.onFinished = onFinished;
    }
  }

  void unlockNextLand(AdventureData adventureData, int index) {
    if (adventureData.lands.length != index - 1) {
      adventureData.lands[index + 1].unLock();
    }
  }

  defaultOnFinished(int landIndex) {
    AdventureLand land = classicAdventureLands[landIndex];

    if (Game.data.ui.winner.ai.type == AIType.player) {
      LevelProgress progress = LevelProgress.get(id(land));
      print(id(land));
      print(progress);
      progress.best = max(progress.best ?? 0, Game.data.turn);

      int newStars = Game.data.turn <= turnsNeeded ? 2 : 1;
      ProgressHelper.stars += min(0, newStars - progress.stars);
      progress.stars = max(progress.stars, newStars);

      progress.save();

      AdventureData adventureData = AdventureData.get(land.parent);
      if (land.levels.last == this) {
        unlockNextLand(adventureData, landIndex);
      } else {
        int index = land.levels.indexOf(this);
        if (index >= 2) {
          unlockNextLand(adventureData, landIndex);
        }
        LevelProgress.get(land.levels[index + 1].id(land))
          ..open = true
          ..save();
      }
    }
  }

  factory Level.fromJson(Map<String, dynamic> json) => _$LevelFromJson(json);
  Map<String, dynamic> toJson() => _$LevelToJson(this);
}

Map<String, AdventureData> defaultAdventures = {
  "default": AdventureData(lands: classicAdventureLands)
};

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 23)
class LevelProgress extends HiveObject {
  @HiveField(0)
  int stars = 0;
  @HiveField(1)
  int best;
  @HiveField(2)
  bool unlocked = false;
  @HiveField(3)
  bool open = false;

  bool isOpen(AdventureLand land, Level level) {
    if (open) return true;
    if (land.isOpen() && land.levels.first == level) {
      return true;
    }
    return false;
  }

  LevelProgress();

  factory LevelProgress.get(String id) {
    LevelProgress levelProgress = Hive.box(MainBloc.ACCOUNTBOX)
        .get("levels/" + id, defaultValue: LevelProgress());
    if (!levelProgress.isInBox) {
      Hive.box(MainBloc.ACCOUNTBOX).put("levels/" + id, levelProgress);
    }
    return levelProgress;
  }

  factory LevelProgress.fromJson(Map<String, dynamic> json) =>
      _$LevelProgressFromJson(json);
  Map<String, dynamic> toJson() => _$LevelProgressToJson(this);

  @override
  String toString() {
    return 'LevelProgress(stars: $stars, best: $best, unlocked: $unlocked, open: $open)';
  }
}
