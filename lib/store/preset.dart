import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:plutopoly/bloc/main_bloc.dart';

import 'package:plutopoly/engine/data/main_data.dart';
import 'package:plutopoly/engine/data/tip.dart';

import 'default_presets_data.dart';

part 'preset.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 17)
class Preset extends HiveObject {
  @HiveField(0)
  String title = "";
  @HiveField(1)
  String description = "";
  @HiveField(2)
  String author = "";
  @HiveField(3)
  String projectName = "";
  @HiveField(4)
  String version = "1.0.0";
  @HiveField(5)
  GameData dataCache;
  @HiveField(6)
  List<Info> infoCards = [];
  @HiveField(7)
  int primaryColor;
  @HiveField(8)
  int accentColor;
  @HiveField(9)
  String template;

  @JsonKey(ignore: true)
  String place = "";

  Preset.classic() {
    projectName = "classic";
    title = "classic";
    description = "classic";
    author = "filorux";
    version = "1.0.0";
  }

  GameData get data {
    return search(projectName) ?? search(template);
  }

  GameData search(String searchName) {
    if (dataCache != null) {
      if (place == "" || place == null) {
        place = "cache";
      }
      return dataCache;
    }
    if (searchName == "classic" || searchName == "default") {
      place = "default";
      dataCache = GameData();
      return dataCache;
    }
    if (presetsData.containsKey(searchName)) {
      place = "default";
      dataCache = GameData.fromJson(presetsData[searchName]);
      return dataCache;
    }
    if (Hive.box(MainBloc.PRESETGAMESBOX).containsKey(searchName)) {
      place = "local";
      dataCache = Hive.box(MainBloc.PRESETGAMESBOX).get(searchName);
      return dataCache;
    }
    print("===\nCouldn't find data\n===");
    return null;
  }

  Preset({
    this.projectName,
    this.title,
    this.description,
    this.author,
    this.version,
    this.template,
    this.dataCache,
  });

  factory Preset.fromJson(Map json) => _$PresetFromJson(json);
  Map<String, dynamic> toJson() => _$PresetToJson(this);
}
