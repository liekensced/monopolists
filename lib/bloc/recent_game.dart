import 'package:hive/hive.dart';

part 'recent_game.g.dart';

@HiveType(typeId: 13)
class RecentGame extends HiveObject {
  @HiveField(0)
  String pin = "";
  @HiveField(1)
  String name = "";
  @HiveField(2)
  String owner = "";
  RecentGame();
}
