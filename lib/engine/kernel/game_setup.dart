import 'package:plutopoly/bloc/main_bloc.dart';

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
      if (player.code != code && MainBloc.online)
        Alert.snackBar("Rejoined as ${player.name}");
      if (player.name == name) {
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
    data.players.add(Player(money: 750, color: color, name: name, code: code));
    Game.save();
    return returnAlert;
  }

  deletePlayer(Player player) {
    Game.data.players.remove(player);
    Game.save();
  }

  defaultPlayer(Player player) {
    deletePlayer(player);
    Game.data.currentPlayer--;
    Game.next(force: true);
  }
}
