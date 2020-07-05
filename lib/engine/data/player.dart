import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:plutopoly/engine/ai/ai.dart';

import '../extensions/bank/data/loan.dart';
import '../kernel/main.dart';
import 'update_info.dart';
import 'map.dart';

part 'player.g.dart';

@JsonSerializable(explicitToJson: true)
// @HiveType(typeId: 3)
class Player {
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
  List<String> properties = [];
  @HiveField(6)
  bool jailed = false;
  @HiveField(7)
  int jailTries = 0;
  @HiveField(8)
  int goojCards = 0;
  @HiveField(9)
  List<UpdateInfo> info = <UpdateInfo>[UpdateInfo(title: "New game")];

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
  AI ai;

  factory Player.fromJson(Map json) => _$PlayerFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerToJson(this);

  Tile get positionTile => Game.data.gmap[position];
  int get index => id;
  int get trainstations {
    int _trainsTations = 0;
    properties.forEach((String i) {
      Tile tile = Game.data.gmap.firstWhere((element) => element.id == i);
      if (tile.type == TileType.trainstation) {
        _trainsTations++;
      }
    });
    return _trainsTations;
  }

  List<Tile> get transtationTiles {
    List<Tile> _trainsTations = [];
    properties.forEach((String i) {
      Tile tile = Game.data.gmap.firstWhere((element) => element.id == i);
      if (tile.type == TileType.trainstation) {
        _trainsTations.add(tile);
      }
    });
    return _trainsTations;
  }

  int get companies {
    int _companies = 0;
    properties.forEach((String i) {
      Tile tile = Game.data.gmap.firstWhere((element) => element.id == i);
      ;
      if (tile.type == TileType.company) _companies++;
    });
    return _companies;
  }

  bool hasAll(String idPrefix) {
    return missing(idPrefix) == 0;
  }

  bool hasAllUnmortaged(String idPrefix) {
    bool has = true;
    Game.data.gmap.forEach((Tile tile) {
      if (tile.idPrefix == idPrefix) {
        if (!properties.contains(tile.id)) {
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
    Game.data.gmap.forEach((Tile tile) {
      if (tile.idPrefix == idPrefix && !properties.contains(tile.id)) {
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
    this.ai,
  }) {
    if (name == null) {
      name = "Player $id";
    }
    if (position == null) {
      position = Game?.data?.gmap
              ?.firstWhere((element) => element.type == TileType.start,
                  orElse: () => null)
              ?.mapIndex ??
          0;
    }
    moneyHistory.add(money);
  }

  @override
  String toString() {
    return 'Player(name: $name, money: $money, position: $position, color: $color, properties: $properties, jailed: $jailed, jailTries: $jailTries, goojCards: $goojCards, moneyHistory: $moneyHistory, code: $code, debt: $debt, loans: $loans, ai: $ai)';
  }
}

class PlayerAdapter extends TypeAdapter<Player> {
  @override
  final typeId = 3;

  @override
  Player read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    if (fields[9] is Map) {
      fields[9] = [];
    }
    return Player(
      money: fields[1] as double,
      color: fields[4] as int,
      position: fields[2] as int,
      name: fields[0] as String,
      code: fields[11] as int,
      ai: fields[15] as AI,
    )
      ..properties = (fields[5] as List)?.cast<String>()
      ..jailed = fields[6] as bool
      ..jailTries = fields[7] as int
      ..goojCards = fields[8] as int
      ..info = (fields[9] as List)?.cast<UpdateInfo>()
      ..moneyHistory = (fields[10] as List)?.cast<double>()
      ..debt = fields[12] as double
      ..loans = (fields[13] as List)?.cast<Contract>()
      ..stock = (fields[14] as Map)?.cast<String, int>();
  }

  @override
  void write(BinaryWriter writer, Player obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.money)
      ..writeByte(2)
      ..write(obj.position)
      ..writeByte(4)
      ..write(obj.color)
      ..writeByte(5)
      ..write(obj.properties)
      ..writeByte(6)
      ..write(obj.jailed)
      ..writeByte(7)
      ..write(obj.jailTries)
      ..writeByte(8)
      ..write(obj.goojCards)
      ..writeByte(9)
      ..write(obj.info)
      ..writeByte(10)
      ..write(obj.moneyHistory)
      ..writeByte(11)
      ..write(obj.code)
      ..writeByte(12)
      ..write(obj.debt)
      ..writeByte(13)
      ..write(obj.loans)
      ..writeByte(14)
      ..write(obj.stock)
      ..writeByte(15)
      ..write(obj.ai);
  }
}
