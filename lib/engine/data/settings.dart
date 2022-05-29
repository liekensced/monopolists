import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable()
@HiveType(typeId: 4)
class Settings {
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
  @JsonKey(defaultValue: 5)
  int interest = 5;
  @JsonKey(defaultValue: 2000)
  @HiveField(8)
  int dtlPrice = 2000;
  @JsonKey(defaultValue: 0)
  @HiveField(9)
  int startProperties = 0;
  @HiveField(10)
  @JsonKey(defaultValue: true)
  bool transportPassGo = true;
  @JsonKey(defaultValue: false)
  @HiveField(11)
  bool allowDiceSelect = false;
  @JsonKey(defaultValue: false)
  @HiveField(12)
  bool allowPriceChanges = false;
  @JsonKey(defaultValue: true)
  @HiveField(13)
  bool generateNames = true;
  @HiveField(14)
  bool receiveProperties = true;
  @HiveField(15)
  bool receiveRentInJail = true;
  @HiveField(16)
  bool doubleBonus = false;
  @HiveField(17)
  @JsonKey(defaultValue: DiceType.two)
  DiceType diceType = DiceType.two;

  Settings();

  factory Settings.fromJson(Map json) => _$SettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}

@HiveType(typeId: 26)
enum DiceType {
  @HiveField(0)
  one,
  @HiveField(1)
  two,
  @HiveField(2)
  three,
  @HiveField(3)
  random,
  @HiveField(4)
  choose
}
