import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import 'package:plutopoly/engine/data/main_data.dart';

part 'preset.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 17)
class Preset extends HiveObject {
  @HiveField(0)
  String title = "";
  @HiveField(1)
  String description = "";
  @HiveField(2)
  String author;
  @HiveField(3)
  String projectName;
  @HiveField(4)
  String version;
  @HiveField(5)
  GameData data;

  Preset();

  factory Preset.fromJson(Map<String, dynamic> json) => _$PresetFromJson(json);
  Map<String, dynamic> toJson() => _$PresetToJson(this);
}
