import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable()
@HiveType(typeId: 4)
class Settings extends HiveObject {
  @HiveField(0)
  String name = "";
  @HiveField(1)
  bool remotelyBuild = false;
  @HiveField(2)
  int goBonus = 200;
  @HiveField(3)
  int maxTurnes = 99999;
  @HiveField(4)
  bool mustAuction = false;
  @HiveField(5)
  int startingMoney = 1500;
  @HiveField(6)
  bool dontBuyFirstRound = false;

  Settings();

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}
