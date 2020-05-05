import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:plutopoly/engine/ai/ai_type.dart';

import '../extensions/bank/data/loan.dart';
import '../kernel/main.dart';
import 'info.dart';
import 'map.dart';

part 'player.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 3)
class Player extends HiveObject {
  @HiveField(0)
  String name = "null";
  @HiveField(1)
  double money = 0;
  @HiveField(2)
  int position = 0;

  int get id => Game.data.players.indexWhere((Player p) => p.name == name);

  @HiveField(4)
  int color = 0;
  @HiveField(5)
  List<int> properties = [];
  @HiveField(6)
  bool jailed = false;
  @HiveField(7)
  int jailTries = 0;
  @HiveField(8)
  int goojCards = 0;
  @HiveField(9)
  Map<int, List<UpdateInfo>> info = {
    0: [UpdateInfo(title: "New game")],
    1: []
  };
  @HiveField(10)
  List<double> moneyHistory = [0];
  @HiveField(11)
  int code = 0;
  @HiveField(12)
  double debt = 0;
  @HiveField(13)
  List<Contract> loans = [];
  @HiveField(14)
  Map<String, int> stock = {};
  @HiveField(15)
  @JsonKey(defaultValue: AIType.player)
  AIType aiType = AIType.player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerToJson(this);

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
    return missing(idPrefix) == 0;
  }

  bool hasAllUnmortaged(String idPrefix) {
    bool has = true;
    Game.data.gmap.asMap().forEach((int i, Tile tile) {
      if (tile.idPrefix == idPrefix) {
        if (!properties.contains(i)) {
          has = false;
          return;
        } else {
          if (tile.mortaged) has = false;
        }
      }
    });
    return has;
  }

  int missing(String idPrefix) {
    int mis = 0;
    Game.data.gmap.asMap().forEach((int i, Tile tile) {
      if (tile.idPrefix == idPrefix && !properties.contains(i)) {
        mis++;
      }
    });
    return mis;
  }

  Player({
    this.money = 0,
    this.color = 9688,
    this.position: 0,
    this.name,
    this.code,
    this.aiType,
  }) {
    if (name == null) {
      name = "Player $id";
    }
    moneyHistory.add(money);
  }
}
