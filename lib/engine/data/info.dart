import 'package:hive/hive.dart';

part 'info.g.dart';

@HiveType(typeId: 7)
class Info extends HiveObject {
  @HiveField(0)
  String title = "";
  @HiveField(1)
  String leading = "i";
  Info({this.title, this.leading: "i"});
}
