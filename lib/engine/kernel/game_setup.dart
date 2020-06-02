import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/engine/ai/ai.dart';
import 'package:plutopoly/engine/ai/ai_type.dart';
import 'package:plutopoly/engine/data/main_data.dart';
import 'package:plutopoly/screens/start/players.dart';

import '../data/player.dart';
import '../ui/alert.dart';
import 'main.dart';

class GameSetup {
  static GameData get data => Game.data;
  GameSetup();
  setGameName(String name) {
    Game.data.settings.name = name;
    Game.save(only: [SaveData.settings.toString()]);
  }

  void addPlayerCheck({String name: "", int color: 0, int code: -1}) {
    data.players.forEach((player) {
      if (player.name == name) {
        throw Alert("Couldn't add player", "The name has already been used");
      }
    });
  }

  Alert addBot() {
    if (data.players.isEmpty)
      return Alert("Failed to add bot", "Please start with a real player.");
    String name = "bot ${data.players.length}";
    while (true) {
      try {
        addPlayerCheck(name: name);
        break;
      } catch (e) {
        name += "+";
      }
    }

    data.players.add(Player(
      money: Game.data.settings.startingMoney.toDouble() ?? 750,
      name: "$name",
      color: ColorHelper().randomColor,
      code: -2,
      ai: AI(AIType.normal),
    ));
    Game.save(only: [SaveData.players.toString()]);
    return null;
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
      code: code,
      ai: AI(AIType.player),
    ));
    Game.save(only: [SaveData.players.toString()]);
    return null;
  }

  deletePlayer(Player player, [bool shouldSave = true]) {
    Game.data.players.remove(player);

    if (shouldSave) Game.save(only: [SaveData.players.toString()]);
  }

  defaultPlayer(Player player) {
    Game.data.lostPlayers.add(player);
    player.properties.forEach((String index) {
      Game.data.gmap
          .where((element) => element.id == index)
          .forEach((element) => element.reset());
    });
    deletePlayer(player, false);
    Game.data.currentPlayer--;
    if (Game.data.currentPlayer < 0) {
      Game.data.currentPlayer = Game.data.players.last.index;
    }
    Game.next(force: true);
  }
}
