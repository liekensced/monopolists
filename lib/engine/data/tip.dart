import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tip.g.dart';

@HiveType(typeId: 19)
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

@JsonSerializable(includeIfNull: false)
@HiveType(typeId: 18)
class Info {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String content;
  @HiveField(2)
  final InfoType type;

  const Info(this.title, this.content, this.type);
  factory Info.fromJson(Map json) => _$InfoFromJson(json);
  Map<String, dynamic> toJson() => _$InfoToJson(this);
}
