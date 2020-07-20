import 'dart:math';

import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/engine/ai/ai.dart';
import 'package:plutopoly/engine/ai/ai_type.dart';
import 'package:plutopoly/engine/data/main_data.dart';
import 'package:plutopoly/engine/kernel/core_actions.dart';
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
    if ((data?.players ?? []).length > 10)
      throw Alert("Couldn't add player", "The're is a maximum of 10 players.");
    (data?.players ?? []).forEach((player) {
      if (player.name == name) {
        throw Alert("Couldn't add player", "The name has already been used");
      }
    });
  }

  Alert addBot({bool hard: false}) {
    String name = "bot ${data.players.length + 1}";
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
      ai: AI(AIType.normal, hard: hard),
    ));
    Game.save(only: [SaveData.players.toString()]);
    return null;
  }

  Alert addPlayer({String name, int color: 0, int code: -1, String icon}) {
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
      playerIcon: icon,
      ai: AI(AIType.player),
    ));
    Game.save(only: [SaveData.players.toString()]);
    return null;
  }

  deletePlayer(Player player, [bool shouldSave = true]) {
    Game.data.players.remove(player);

    if (shouldSave) Game.save(only: [SaveData.players.toString()]);
  }

  defaultPlayer(Player player, [bool next = true]) {
    Game.data.lostPlayers.add(player);
    if (Game.data.settings.receiveProperties ?? false) {
      Player owner = Game.data.tile.owner;
      if (owner != null && owner != player) {
        owner.properties.addAll(player.properties);
        Game.act.pay(
            PayType.pay, max(player.money.floor(), -Game.data.tile.currentRent),
            force: true,
            shouldSave: false,
            message: "You bankrupted " + owner.name);
      } else {
        resetProperties(player);
      }
    } else {
      resetProperties(player);
    }
    deletePlayer(player, false);
    Game.data.currentPlayer--;
    if (Game.data.currentPlayer < 0) {
      Game.data.currentPlayer = Game.data.players.last.index;
    }
    Game.save(force: true);
    if (next) Game.next(force: true);
  }

  void resetProperties(Player player) {
    player.properties.forEach((String index) {
      Game.data.gmap
          .where((element) => element.id == index)
          .forEach((element) => element.reset());
    });
  }
}
