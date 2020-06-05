import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tip.g.dart';

@HiveType(typeId: 18)
enum InfoType {
  @HiveField(0)
  rule,
  @HiveField(1)
  alert,
  @HiveField(2)
  tip,
  @HiveField(3)
  setting,
}

@JsonSerializable()
@HiveType(typeId: 18)
class Info {
  @HiveField(0)
  String title = "";
  @HiveField(1)
  String content = "";
  @HiveField(2)
  InfoType type = InfoType.rule;

  Info(this.title, this.content, this.type);
  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);
  Map<String, dynamic> toJson() => _$InfoToJson(this);
}
