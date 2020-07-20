import 'package:plutopoly/engine/data/player.dart';
import 'package:plutopoly/engine/kernel/core_actions.dart';
import 'package:plutopoly/engine/kernel/main.dart';

extension NullList on List<String> {
  ///Return null when out of bounds.
  String tryGet(int i) {
    if (i < this.length) {
      return this.elementAt(i);
    } else {
      return null;
    }
  }

  String tryGetLast(int from) {
    if (from < this.length) {
      return this.getRange(from, length).join(" ");
    } else {
      return null;
    }
  }

  int tryGetInt(int i) {
    return int.tryParse(tryGet(1) ?? "");
  }

  bool tryGetBool(int i) {
    String val = tryGet(i);
    if (val == null) return null;
    if (val == "1" || val.toLowerCase() == "true") return true;
    if (val == "0" || val.toLowerCase() == "false") return true;
    return null;
  }
}

class CommandParser {
  static void parse(String input, [bool force = false, bool allowNext = true]) {
    List<String> commands = input.split(";");
    if (commands.isNotEmpty) {
      commands.forEach((command) {
        parsePart(command, force, allowNext);
      });
    }
  }

  static void parsePart(String command,
      [bool force = false, bool allowNext = true]) {
    List<String> split = command.trim().split(" ");

    switch (split.first.toLowerCase()) {
      case "mv":
        Game.jump(
          split.tryGetInt(1),
          split.tryGetBool(2) ?? true,
          split.tryGetBool(3) ?? false,
        );
        break;
      case "mvr":
        Game.jump(
          Game.data.player.position + split.tryGetInt(1),
          split.tryGetBool(2) ?? true,
          split.tryGetBool(3) ?? false,
        );
        break;
      case "pay":
        Game.act.pay(
          PayType.pot,
          split.tryGetInt(1) ?? 0,
          count: split.tryGetBool(2) ?? true,
          message: split.tryGetLast(3) ?? "Payed to pot",
          force: force,
          isRentPayed: false,
        );
        break;
      case "win":
        Game.data.players.forEach((Player player) {
          if (player != Game.data.player) {
            Game.setup.defaultPlayer(player);
          }
        });
        Game.data.ui.ended;
        break;
      case "rh":
        Game.helper.repareHouses(
            houseFactor: split.tryGetInt(1) ?? 25,
            hotelFactor: split.tryGetInt(2) ?? 100);
        break;
      case "jail":
        Game.helper.jail(Game.data.player);
        break;
      case "gooj":
        Game.data.player.goojCards += split.tryGetInt(1) ?? 1;
        break;
      case "bd":
        Game.helper.birthDay(split.tryGetInt(1) ?? 50);
        break;
      default:
        print("unkown command " + split.first);
    }
    if (allowNext ?? true) Game.data.rentPayed = true;
  }
}

Map<String, Map<String, List<Map<String, List<Map<String, String>>>>>>
    commandsInfo = {
  "mv": {
    "Move player": [
      {
        "Enter a number. 0 Is the first tile.": [
          {"Move to random location": "r"}
        ]
      },
      {
        "Pass go": [
          {"yes": "1"},
          {"no": "0"},
        ]
      },
    ]
  },
  "mvr": {
    "Move player relative": [
      {"Enter a number": []},
      {
        "Pass go": [
          {"yes": "1"},
          {"no": "0"},
        ]
      },
    ]
  },
  "pay": {
    "Let player pay": [
      {"Enter an amount to pay": []},
      {
        "Count as expense": [
          {"yes, default": "1"},
          {"no": "0"},
        ]
      },
      {"message": []},
    ]
  },
  "win": {"Let player win": []},
  "rh": {
    "Repare houses": [
      {"Enter price per house": []},
      {"Enter price per hotel": []},
    ]
  },
  "jail": {
    "Jail player": [
      {"done": []}
    ]
  },
  "gooj": {
    "Get out of jail card": [
      {
        "Enter amount of cards": [],
      }
    ]
  },
  "bd": {
    "Birthday, receive from every player": [
      {
        "Enter amount of money": [],
      }
    ]
  }
};
