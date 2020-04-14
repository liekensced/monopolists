import 'dart:math';

import '../../bloc/main_bloc.dart';
import '../data/actions.dart';
import '../data/info.dart';
import '../data/main.dart';
import '../data/map.dart';
import '../data/player.dart';
import '../data/ui_actions.dart';
import '../ui/alert.dart';
import 'core_actions.dart';
import 'extensions/bank.dart';
import 'game_helpers.dart';
import 'game_setup.dart';

class Game {
  static GameData data;

  static Bank bank = Bank();
  static CoreActions act = CoreActions();
  static GameSetup setup = GameSetup();
  static GameHelpers helper = GameHelpers();
  static UIActionsData get ui => Game.data.ui;

  static bool testing = false;
  static save() {
    if (!(testing ?? false)) {
      MainBloc.save(data);
    }
  }

  //launching
  static newGame() {
    data = MainBloc.newGame();

    loadGame(data);
  }

  static loadGame(GameData loadData) {
    if (!(testing ?? false)) assert(loadData.isInBox || MainBloc.online);
    data = loadData;
    launch();
  }

  static Alert build([Tile property]) {
    Tile tile = property ?? Game.data.player.positionTile;
    if (tile.housePrice == null)
      return Alert("Couldn't build house", "No house price specified?");
    if (data.player.money < tile.housePrice) return Alert.funds();
    if (tile.level >= tile.rent.length - 1)
      return Alert("Not upgradable",
          "The tile ${tile.name} is already the highest level.");

    data.player.money -= tile.housePrice;
    tile.level++;
    save();
    return Alert.snackBar("Build 1 house", "house");
  }

  static launch() {
    //init variables
    if (testing ?? false) {
      data.settings.name = "test game";
    }

    data.findingsIndex = Random().nextInt(findings.length);
    data.eventIndex = Random().nextInt(events.length);

    if (data.players.length > 0) {
      data.running = true;
      data.currentPlayer = 0;
    }
    save();
  }

  //basic interactions

  static Alert executeEvent(Function func) {
    var r = func();
    if (r is Alert) {
      return r;
    }

    data.rentPayed = true;
    Game.save();
    return null;
  }

  static void jump(int position) {
    data.rentPayed = false;

    Game.data.player.position = position;
    Game.save();
  }

  static void move(int dice1, int dice2) {
    data.rentPayed = false;
    ui.shouldMove = false;
    Player player = data.player;
    data.currentDices = [dice1, dice2];
    int steps = dice1 + dice2;

    if (player.jailed) {
      data.doublesThrown = 0;
      if (dice1 == dice2 || player.jailTries == 1) {
        player.jailed = false;
        dice1 -= 10;
        dice2 += 10;
        data.currentDices = [dice1, dice2];
      } else {
        player.jailTries--;
        return;
      }
    }
    if (dice1 == dice2 && data.doublesThrown >= 2) {
      helper.jail(data.currentPlayer);
    } else {
      if (dice1 != dice2) data.doublesThrown = 0;
      for (int i = 0; i < steps; i++) {
        if (player.position >= data.gmap.length) {
          player.position = 0;
          onPassGo();
        } else {
          player.position++;
        }
      }

      switch (data.gmap[player.position].type) {
        case TileType.police:
          data.player.jailed = true;
          data.player.jailTries = 3;
          break;
        default:
      }
    }
    save();
  }

  static Alert next() {
    data.findingsIndex = Random().nextInt(findings.length);
    data.eventIndex = Random().nextInt(events.length);
    TileType _type = Game.data.player.positionTile.type;
    if (_type == TileType.tax && !Game.data.rentPayed) {
      return Alert(
          "Taxes not payed", "Please pay your taxes before continuing");
    }
    if ((_type == TileType.chance || _type == TileType.chest) &&
        !Game.data.rentPayed) {
      return Alert("Card not executed",
          "Tap on the Findings or Event card and execute it.");
    }
    ui.shouldMove = true;
    if (data.currentDices[0] == data.currentDices[1] && !data.player.jailed) {
      data.doublesThrown++;
    } else if (data.currentPlayer == data.players.length - 1) {
      data.currentPlayer = 0;
      onNewTurn();
    } else {
      data.currentPlayer++;
    }
    Bank.rent();
    save();

    return null;
  }

  static onNewTurn() {
    data.turn++;

    data.players.asMap().forEach((int i, _) {
      data.players[i].info[data.turn + 1] = [];
      data.players[i].moneyHistory.add(data.players[i].money);
    });
  }

  static onPassGo() {
    int _goBonus = Game.data.settings.goBonus;
    data.player.money += _goBonus;
    data.player.info[data.turn]
        .add(Info(title: "Received go bonus: $_goBonus"));

    Bank.rent();
  }
}
