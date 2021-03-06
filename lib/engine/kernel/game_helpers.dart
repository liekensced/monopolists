import 'dart:math';

import 'package:plutopoly/bloc/main_bloc.dart';

import '../data/main_data.dart';
import '../data/map.dart';
import '../data/player.dart';
import '../ui/alert.dart';
import 'core_actions.dart';
import 'main.dart';

class GameHelpers {
  GameHelpers();

  static GameData get data => Game.data;

  void jail(Player player, {bool shouldSave: true}) {
    data.doublesThrown = 0;
    player.jailed = true;
    List<Tile> jails =
        data.gmap.where((element) => element.type == TileType.jail).toList();

    player.position = jails[Random().nextInt(jails.length)].mapIndex;
    player.jailTries = data.tile.price ?? 2;
    if (shouldSave) {
      Game.save(only: ["doublesThrown", SaveData.players.toString()]);
    }
  }

  birthDay([int amount = 50]) {
    data.players.forEach((Player p) {
      if (p == data.player) return;
      p.money -= amount;
      data.player.money += amount;
    });
    Game.save(only: [SaveData.players.toString()]);
  }

  undoubleDices() {
    data.currentDices[0] -= 10;
    data.currentDices[1] += 10;
  }

  Alert repareHouses({int houseFactor: 25, int hotelFactor: 100}) {
    int _housesPay = 0;
    Game.data.player.properties.forEach((String i) {
      Tile tile = Game.data.gmap.firstWhere((element) => element.id == i);
      if (tile.level == 5) {
        _housesPay += hotelFactor;
        return;
      } else {
        _housesPay += tile.level * houseFactor;
      }
    });
    try {
      Game.act.pay(PayType.bank, _housesPay, count: true);
    } on Alert catch (e) {
      return e;
    }
    return null;
  }
}
