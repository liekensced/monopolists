import '../data/main.dart';
import '../data/map.dart';
import '../data/player.dart';
import 'main.dart';

class GameHelpers {
  GameHelpers();

  static GameData get data => Game.data;

  jail(int player) {
    data.doublesThrown = 0;
    data.players[player].jailed = true;
    data.players[player].jailTries = 3;
    data.players[player].position = 10;
    Game.save();
  }

  birthDay() {
    data.players.forEach((Player p) {
      if (p == data.player) return;
      p.money -= 10;
      data.player.money += 10;
    });
    Game.save();
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
    Game.data.player.money -= _housesPay;
    Game.save();
  }
}
