import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable()
@HiveType(typeId: 4)
class Settings extends HiveObject {
  @HiveField(0)
  String name = "";
  @HiveField(1)
  bool remotelyBuild = true;
  @HiveField(2)
  int goBonus = 200;
  @HiveField(3)
  int maxTurnes = 99999;
  @HiveField(4)
  bool mustAuction = false;
  @HiveField(5)
  int startingMoney = 1500;
  @HiveField(6)
  bool hackerScreen = false;
  @HiveField(7)
  @JsonKey(defaultValue: 10)
  int interest = 10;
  @JsonKey(defaultValue: 1500)
  @HiveField(8)
  int dtlPrice = 1500;
  @JsonKey(defaultValue: 0)
  @HiveField(9)
  int startProperties = 0;
  @HiveField(10)
  @JsonKey(defaultValue: true)
  bool transportPassGo = true;

  Settings();

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}
