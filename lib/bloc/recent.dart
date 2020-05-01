import 'package:hive/hive.dart';

part 'recent.g.dart';

@HiveType(typeId: 14)
class Recent extends HiveObject {
  @HiveField(0)
  String pin;

  @HiveField(1)
  String name;

  @HiveField(3)
  String owner;

  @HiveField(4)
  int turn;

  @HiveField(5)
  bool idle;

  Recent(this.name, this.owner, this.turn, this.idle);
}
