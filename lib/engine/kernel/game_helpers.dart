import 'package:plutopoly/bloc/main_bloc.dart';

import '../data/main_data.dart';
import '../data/map.dart';
import '../data/player.dart';
import 'core_actions.dart';
import 'main.dart';

class GameHelpers {
  GameHelpers();

  static GameData get data => Game.data;

  jail(int player, {bool shouldSave: true}) {
    data.doublesThrown = 0;
    data.players[player].jailed = true;
    data.players[player].jailTries = 2;
    data.players[player].position = 10;
    if (shouldSave) {
      Game.save(only: ["doublesThrown", SaveData.players.toString()]);
    }
  }

  birthDay() {
    data.players.forEach((Player p) {
      if (p == data.player) return;
      p.money -= 10;
      data.player.money += 10;
    });
    Game.save(only: [SaveData.players.toString()]);
  }

  undoubleDices() {
    data.currentDices[0] -= 10;
    data.currentDices[1] += 10;
  }

  repareHouses({int houseFactor: 25, hotelFactor: 100}) {
    int _housesPay = 0;
    Game.data.player.properties.forEach((int i) {
      Tile tile = Game.data.gmap[i];
      if (tile.level == 5) {
        _housesPay += hotelFactor;
        return;
      }
      _housesPay += tile.level * houseFactor;
    });
    Game.act.pay(PayType.bank, _housesPay, count: true, force: true);
  }
}
