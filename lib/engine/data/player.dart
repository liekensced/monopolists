import 'package:hive/hive.dart';
import 'package:monopolists/engine/data/map.dart';
import 'package:monopolists/engine/kernel/main.dart';

part 'player.g.dart';

@HiveType(typeId: 3)
class Player extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  double money;
  @HiveField(2)
  int position;
  @HiveField(3)
  int id;
  @HiveField(4)
  int color;
  @HiveField(5)
  List<int> properties = [];
  @HiveField(6)
  bool jailed = false;
  @HiveField(7)
  int jailTries = 0;
  @HiveField(8)
  int goojCards = 0;

  Tile get positionTile => Game.data.gmap[position];
  int get index => Game.data.players.indexOf(this);
  int get trainstations {
    int _trainsTations = 0;
    properties.forEach((int i) {
      Tile tile = Game.data.gmap[i];
      if (tile.type == TileType.trainstation) {
        _trainsTations++;
      }
    });
    return _trainsTations;
  }

  int get companies {
    int _companies = 0;
    properties.forEach((int i) {
      Tile tile = Game.data.gmap[i];
      if (tile.type == TileType.company) _companies++;
    });
    return _companies;
  }

  bool hasAll(String idPrefix) {
    bool hasAll = true;
    Game.data.gmap.asMap().forEach((int i, Tile tile) {
      if (tile.idPrefix == idPrefix && !properties.contains(i)) {
        hasAll = false;
        return;
      }
    });
    return hasAll;
  }

  Player(
      {this.money = 0,
      this.id = 0,
      this.color = 9688,
      this.position: 0,
      this.name}) {
    if (name == null) {
      name = "Player $id";
    }
  }
}
