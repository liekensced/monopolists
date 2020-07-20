import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'game_action.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 25)
class GameAction extends HiveObject {
  @HiveField(0)
  String title = "";
  @HiveField(1)
  String command;
  @HiveField(2)
  String cost;
  @HiveField(3)
  String alert;
  @HiveField(4)
  int color;
  @HiveField(5)
  bool allowNext = true;

  GameAction();

  factory GameAction.fromJson(Map<String, dynamic> json) =>
      _$GameActionFromJson(json);
  Map<String, dynamic> toJson() => _$GameActionToJson(this);
}
