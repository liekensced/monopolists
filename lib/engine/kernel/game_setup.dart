import 'dart:ui';

import 'package:monopolists/engine/kernel/../ui/alert.dart';

import '../data/player.dart';
import 'main.dart';

class GameSetup {
  static get data => Game.data;
  GameSetup();
  setGameName(String name) {
    Game.data.settings.name = name;
    Game.save();
  }

  Alert addPlayer({String name, Color color: const Color(0x000000)}) {
    Alert returnAlert;
    data.players.forEach((Player player) {
      if (player.name == name) {
        returnAlert =
            Alert("Couldn't add player", "The name has already been used");
        return;
      }
      if (player.color == color.value) {
        returnAlert = Alert("Couldn't add player", "The color already exists");
        return;
      }
    });
    if (returnAlert != null) return returnAlert;
    int id = data.players.length;
    data.players
        .add(Player(money: 750, id: id, color: color?.value, name: name));
    Game.save();
    return returnAlert;
  }

  deleteLastPlayer() {
    data.players.removeLast();
    Game.save();
  }
}
