import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'info.g.dart';

@JsonSerializable()
@HiveType(typeId: 7)
class UpdateInfo {
  @HiveField(0)
  String title = "";
  @HiveField(1)
  String leading = "i";
  @HiveField(2)
  String subtitle = "";
  @HiveField(3)
  String trailing = "";
  @HiveField(4)
  bool show = false;
  @HiveField(5)
  int color;

  UpdateInfo(
      {this.title,
      this.leading: "i",
      this.subtitle,
      this.trailing,
      this.show,
      this.color});

  factory UpdateInfo.fromJson(Map json) => _$UpdateInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateInfoToJson(this);
}
