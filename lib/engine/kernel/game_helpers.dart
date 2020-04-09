import 'package:monopolists/engine/data/main.dart';

import 'main.dart';

class GameHelpers {
  GameHelpers();

  static GameData get data => Game.data;

  jail(int player) {
    data.players[player].jailed = true;
    data.players[player].jailTries = 3;
    data.players[player].position = 10;
    Game.save();
  }

  undoubleDices() {
    data.currentDices[0] -= 10;
    data.currentDices[1] += 10;
  }
}
