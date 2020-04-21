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

  void addPlayerCheck({String name: "", int color: 0, int code: -1}) {
    data.players.forEach((player) {
      if (player.code != code && MainBloc.online)
        Alert.snackBar("Rejoined as ${player.name}");
      if (player.name == name) {
        throw Alert("Couldn't add player", "The name has already been used");
      }
      if (player.color == color) {
        throw Alert("Couldn't add player", "The color already exists");
      }
    });
  }

  Alert addPlayer({String name, int color: 0, int code: -1}) {
    try {
      addPlayerCheck(name: name, color: color, code: code);
    } on Alert catch (e) {
      return e;
    }

    data.players.add(Player(
        money: Game.data.settings.startingMoney.toDouble() ?? 750,
        color: color,
        name: name,
        code: code));
    Game.save();
    return null;
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
