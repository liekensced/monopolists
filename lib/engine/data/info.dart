import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'info.g.dart';

@JsonSerializable()
@HiveType(typeId: 7)
class UpdateInfo extends HiveObject {
  @HiveField(0)
  String title = "";
  @HiveField(1)
  String leading = "i";
  UpdateInfo({this.title, this.leading: "i"});

  factory UpdateInfo.fromJson(Map<String, dynamic> json) =>
      _$UpdateInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateInfoToJson(this);
}
