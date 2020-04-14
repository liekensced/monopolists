import '../data/player.dart';
import '../ui/alert.dart';
import 'main.dart';

class GameSetup {
  static get data => Game.data;
  GameSetup();
  setGameName(String name) {
    Game.data.settings.name = name;
    Game.save();
  }

  Alert addPlayer({String name, int color: 0, int code: -1}) {
    Alert returnAlert;
    data.players.forEach((Player player) {
      if (player.name == name && player.code != code) {
        returnAlert =
            Alert("Couldn't add player", "The name has already been used");
        return;
      }
      if (player.color == color) {
        returnAlert = Alert("Couldn't add player", "The color already exists");
        return;
      }
    });
    if (returnAlert != null) return returnAlert;
    int id = data.players.length;
    data.players
        .add(Player(money: 750, id: id, color: color, name: name, code: code));
    Game.save();
    return returnAlert;
  }

  deleteLastPlayer() {
    data.players.removeLast();
    Game.save();
  }
}
