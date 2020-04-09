import 'package:hive/hive.dart';

import '../data/extensions.dart';
import 'map.dart';
import 'player.dart';
import 'settings.dart';
import 'ui_actions.dart';

part 'main.g.dart';

@HiveType(typeId: 0)
class GameData extends HiveObject {
  @HiveField(0)
  bool running;
  @HiveField(1)
  List<Player> players = [];
  @HiveField(2)
  int currentPlayer = 0;
  @HiveField(3)
  int turn = 0;
  @HiveField(4)
  List<int> currentDices = [1, -1];
  @HiveField(5)
  int doublesThrown = 0;
  @HiveField(6)
  double pot = 0;
  @HiveField(7)
  List<Tile> gmap = defaultMap;
  @HiveField(8)
  Settings settings = Settings();
  @HiveField(9)
  List<Extension> extensions = [];
  @HiveField(10)
  UIActionsData ui = UIActionsData();
  @HiveField(11)
  bool rentPayed = false;

  Player get player {
    return players[currentPlayer];
  }
}
