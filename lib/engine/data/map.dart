import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:monopolists/engine/data/player.dart';
import 'package:monopolists/engine/kernel/main.dart';

part 'map.g.dart';

@HiveType(typeId: 1)
class Tile extends HiveObject {
  @HiveField(0)
  TileType type = TileType.land;
  @HiveField(1)
  int color;
  @HiveField(2)
  String idPrefix;
  @HiveField(3)
  String name;
  @HiveField(4)
  int price;
  @HiveField(5)
  int hyp;
  @HiveField(6)
  int housePrice;
  @HiveField(7)
  List<int> rent;
  @HiveField(9)
  int level = 0;
  @HiveField(10)
  int idIndex = 1;

  String get id => "$idPrefix:$idIndex";

  int get currentRent {
    if (rent == null) return 0;
    if (type == TileType.trainstation) {
      return rent[owner.trainstations - 1];
    }
    if (type == TileType.company) {
      int _eyes = Game.data.currentDices.fold<int>(0, (a, b) => a + b);
      if (owner.companies == 2) {
        return _eyes * 10;
      } else {
        return _eyes * 4;
      }
    }
    if (level > rent.length) return 0;
    return rent[level];
  }

  int get index {
    return Game.data.gmap.indexWhere((tile) => tile.id == id);
  }

  Player get owner {
    Player owner;
    Game.data.players.forEach((Player player) {
      if (player.properties.contains(index)) {
        owner = player;
        return;
      }
    });
    return owner;
  }

  List<Player> get players {
    return Game.data.players
        .where((player) => player.position == index)
        .toList();
  }

  Tile(
    this.type, {
    this.color,
    this.idPrefix,
    this.name,
    this.price,
    this.housePrice,
    this.rent,
    this.hyp,
    @required this.idIndex,
  });
}

@HiveType(typeId: 2)
enum TileType {
  @HiveField(0)
  land,
  @HiveField(1)
  company,
  @HiveField(2)
  trainstation,
  @HiveField(3)
  start,
  @HiveField(4)
  chest,
  @HiveField(5)
  tax,
  @HiveField(6)
  chance,
  @HiveField(7)
  jail,
  @HiveField(8)
  parking,
  @HiveField(9)
  police
}

List<Tile> defaultMap = [
  Tile(TileType.start, idIndex: 1),
  Tile(TileType.land,
      color: Colors.brown.value,
      idPrefix: "Br",
      idIndex: 1,
      name: "Brown 1",
      price: 60,
      housePrice: 50,
      rent: [2, 10, 30, 90, 160, 250],
      hyp: 30),
  Tile(TileType.chest, idPrefix: "CC", idIndex: 1),
  Tile(TileType.land,
      color: Colors.brown.value,
      idPrefix: "Br",
      idIndex: 2,
      name: "Brown 2",
      price: 60,
      housePrice: 50,
      rent: [4, 20, 60, 180, 320, 450],
      hyp: 30),
  Tile(TileType.tax, idPrefix: "tax", idIndex: 1, price: 200),
  Tile(TileType.trainstation,
      idPrefix: "T",
      idIndex: 1,
      price: 200,
      rent: [25, 50, 100, 200],
      hyp: 100,
      name: "Trainstation 1"),
  Tile(TileType.land,
      color: Colors.lightBlue.value,
      idPrefix: "LB",
      idIndex: 1,
      name: "Light blue 1",
      price: 100,
      housePrice: 50,
      rent: [6, 30, 90, 270, 400, 550],
      hyp: 50),
  Tile(TileType.chance, idPrefix: "Ch", idIndex: 1),
  Tile(TileType.land,
      color: Colors.lightBlue.value,
      idPrefix: "LB",
      idIndex: 2,
      name: "Light Blue 2",
      price: 100,
      housePrice: 50,
      rent: [6, 30, 90, 270, 400, 550],
      hyp: 50),
  Tile(TileType.land,
      color: Colors.lightBlue.value,
      idPrefix: "LB",
      idIndex: 3,
      name: "Light Blue 3",
      price: 120,
      housePrice: 50,
      rent: [8, 40, 100, 300, 450, 600],
      hyp: 60),
  Tile(TileType.jail, idPrefix: "JAIL", idIndex: 1),
  Tile(TileType.land,
      color: Colors.purple.value,
      idPrefix: "P",
      idIndex: 1,
      name: "Purple 1",
      price: 140,
      housePrice: 100,
      rent: [10, 50, 150, 450, 625, 750],
      hyp: 70),
  Tile(TileType.company,
      price: 150, idPrefix: "C", idIndex: 1, name: "Elektric Company", hyp: 75),
  Tile(TileType.land,
      color: Colors.purple.value,
      idPrefix: "P",
      idIndex: 2,
      name: "Purple 2",
      price: 140,
      housePrice: 100,
      rent: [10, 50, 150, 450, 625, 750],
      hyp: 70),
  Tile(TileType.land,
      color: Colors.purple.value,
      idPrefix: "P",
      idIndex: 3,
      name: "Purple 3",
      price: 160,
      housePrice: 100,
      rent: [12, 60, 180, 500, 700, 900],
      hyp: 80),
  Tile(TileType.trainstation,
      idPrefix: "T",
      idIndex: 2,
      price: 200,
      rent: [25, 50, 100, 250],
      name: "Trainstation 2"),
  Tile(TileType.land,
      color: Colors.orange.value,
      idPrefix: "O",
      idIndex: 1,
      name: "Orange 1",
      price: 180,
      housePrice: 100,
      rent: [14, 70, 200, 550, 750, 950],
      hyp: 90),
  Tile(TileType.chest, idPrefix: "CC", idIndex: 2),
  Tile(TileType.land,
      color: Colors.orange.value,
      idPrefix: "O",
      idIndex: 2,
      name: "Orange 2",
      price: 180,
      housePrice: 100,
      rent: [14, 70, 200, 550, 750, 950],
      hyp: 90),
  Tile(TileType.land,
      color: Colors.orange.value,
      idPrefix: "O",
      idIndex: 3,
      name: "Orange 3",
      price: 200,
      housePrice: 100,
      rent: [16, 80, 220, 600, 800, 1000],
      hyp: 100),
  Tile(TileType.parking, idPrefix: "PARK", idIndex: 1),
  Tile(TileType.land,
      color: Colors.red.value,
      idPrefix: "R",
      idIndex: 1,
      name: "Red 1",
      price: 220,
      housePrice: 150,
      rent: [18, 90, 250, 700, 875, 1050],
      hyp: 110),
  Tile(
    TileType.chance,
    idPrefix: "Ch",
    idIndex: 2,
  ),
  Tile(TileType.land,
      color: Colors.red.value,
      idPrefix: "R",
      idIndex: 2,
      name: "Red 2",
      price: 220,
      housePrice: 150,
      rent: [18, 90, 250, 700, 875, 1050],
      hyp: 110),
  Tile(TileType.land,
      color: Colors.red.value,
      idPrefix: "R",
      idIndex: 3,
      name: "Red 3",
      price: 240,
      housePrice: 150,
      rent: [20, 100, 300, 750, 925, 1100],
      hyp: 120),
  Tile(TileType.trainstation,
      idPrefix: "T",
      idIndex: 3,
      price: 200,
      rent: [25, 50, 100, 250],
      hyp: 100,
      name: "Trainstation 3"),
  Tile(TileType.land,
      color: Colors.amber.value,
      idPrefix: "Y",
      idIndex: 1,
      name: "Yellow 1",
      price: 260,
      housePrice: 150,
      rent: [22, 110, 330, 800, 975, 1150],
      hyp: 130),
  Tile(TileType.land,
      color: Colors.amber.value,
      idPrefix: "Y",
      idIndex: 2,
      name: "Yellow 2",
      price: 260,
      housePrice: 150,
      rent: [22, 110, 330, 800, 975, 1150],
      hyp: 130),
  Tile(
    TileType.company,
    price: 150,
    idPrefix: "C",
    idIndex: 2,
    name: "Water company",
    hyp: 75,
  ),
  Tile(TileType.land,
      color: Colors.amber.value,
      idPrefix: "Y",
      idIndex: 3,
      name: "Yellow 3",
      price: 280,
      housePrice: 150,
      rent: [24, 120, 360, 850, 1025, 1200],
      hyp: 140),
  Tile(TileType.police, idPrefix: "POL", idIndex: 1),
  Tile(TileType.land,
      color: Colors.green.value,
      idPrefix: "G",
      idIndex: 1,
      name: "Green 1",
      price: 300,
      housePrice: 200,
      rent: [26, 130, 390, 900, 1100, 1275],
      hyp: 150),
  Tile(TileType.land,
      color: Colors.green.value,
      idPrefix: "G",
      name: "Green 2",
      idIndex: 2,
      price: 300,
      housePrice: 200,
      rent: [26, 130, 390, 900, 1100, 1250],
      hyp: 150),
  Tile(TileType.chest, idPrefix: "CC", idIndex: 3),
  Tile(TileType.land,
      color: Colors.green.value,
      idPrefix: "G",
      idIndex: 3,
      name: "Green 3",
      price: 320,
      housePrice: 200,
      rent: [28, 150, 450, 1000, 1200, 1400],
      hyp: 160),
  Tile(TileType.trainstation,
      idPrefix: "T",
      idIndex: 4,
      price: 200,
      rent: [25, 50, 100, 250],
      hyp: 100,
      name: "Trainstation 4"),
  Tile(TileType.chance, idPrefix: "Ch", idIndex: 3),
  Tile(TileType.land,
      color: Colors.blue[900].value,
      idPrefix: "DB",
      idIndex: 1,
      name: "Dark Blue 1",
      price: 350,
      housePrice: 200,
      rent: [35, 175, 500, 1100, 1300, 1500],
      hyp: 175),
  Tile(TileType.tax, idPrefix: 'tax', idIndex: 2, price: 100),
  Tile(TileType.land,
      color: Colors.blue[900].value,
      idPrefix: "DB",
      idIndex: 2,
      name: "Dark Blue 2",
      price: 400,
      housePrice: 200,
      rent: [50, 200, 600, 1400, 1700, 2000],
      hyp: 200),
];