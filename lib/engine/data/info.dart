import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'info.g.dart';

@JsonSerializable()
@HiveType(typeId: 7)
class Info extends HiveObject {
  @HiveField(0)
  String title = "";
  @HiveField(1)
  String leading = "i";
  Info({this.title, this.leading: "i"});

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);
  Map<String, dynamic> toJson() => _$InfoToJson(this);
}
