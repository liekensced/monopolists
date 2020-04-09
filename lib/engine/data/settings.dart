import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 4)
class Settings extends HiveObject {
  @HiveField(0)
  String name = "";
  @HiveField(1)
  bool remotelyBuild = false;
  @HiveField(2)
  int goBonus = 200;
  @HiveField(3)
  int maxTurnes = 99999;
  @HiveField(4)
  bool mustAuction = false;
  @HiveField(5)
  bool allowOneDice = false;
  @HiveField(6)
  bool dontBuyFirstRound = false;
}
