import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

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

  GameData get data {
    if (dataCache != null) return dataCache;

    if (presetsData.containsKey(projectName)) {
      return GameData.fromJson(presetsData[projectName]);
    }
    return null;
  }

  Preset({
    this.projectName,
    this.title,
    this.description,
    this.author,
    this.version,
    this.dataCache,
  });

  factory Preset.fromJson(Map json) => _$PresetFromJson(json);
  Map<String, dynamic> toJson() => _$PresetToJson(this);
}
