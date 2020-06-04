import 'dart:math';

import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/engine/extensions/transportation.dart';

import '../../bloc/main_bloc.dart';
import '../ai/ai_type.dart';
import '../ai/normal/normal_ai.dart';
import '../data/actions.dart';
import '../data/extensions.dart';
import '../data/info.dart';
import '../data/main_data.dart';
import '../data/map.dart';
import '../data/player.dart';
import '../data/ui_actions.dart';
import '../extensions/bank/bank.dart';
import '../extensions/bank/data/bank_data.dart';
import '../ui/alert.dart';
import 'core_actions.dart';
import 'game_helpers.dart';
import 'game_setup.dart';

class Game {
  static GameData data;

  static BankExtension bank = BankExtension();
  static CoreActions act = CoreActions();
  static GameSetup setup = GameSetup();
  static GameHelpers helper = GameHelpers();
  static UIActionsData get ui => Game.data.ui;

  static bool testing = false;
  static save({
    force: false,
    List<String> only,
    List<String> exclude,
    bool excludeBasic: false,
  }) {
    if (excludeBasic) {
      exclude = [
        SaveData.gmap.toString(),
        SaveData.settings.toString(),
        SaveData.dealData.toString(),
        SaveData.lostPlayers.toString(),
      ];
    }
    if (Game.data.dealData.dealer != null) {
      if (Game.data.players[Game.data.dealData.dealer].ai.type ==
          AIType.normal) {
        NormalAI.onDealUpdate();
        MainBloc.updateUI();
      }
    }
    if (data.running == true && data.player.ai.type == AIType.normal && !force)
      return;
    if (!(testing ?? false)) {
      MainBloc.save(data, only: only, exclude: exclude);
    }
  }

  //launching
  static newGame() {
    data = MainBloc.newGame();

    loadGame(data);
  }

  static loadGame(GameData loadData) {
    data = loadData;
    if (Game.data == null || !(Game.data.running ?? false)) return;
    if (MainBloc.online) {
      ///RETURNS
      if (Game.data.nextRealPlayer.code != UIBloc.gamePlayer.code) return;
    }
    if (Game.data.player.ai.type == AIType.normal) {
      NormalAI.onPlayerTurn();
    }
  }

  static addInfo(UpdateInfo updateInfo, [int playerIndex, int minus = 1]) {
    if (playerIndex == null) playerIndex = Game.data.currentPlayer;
    if (Game.data.players[playerIndex].info[Game.data.turn - minus] == null) {
      Game.data.players[playerIndex].info[Game.data.turn - minus] = [];
    }
    Game.data.players[playerIndex].info[Game.data.turn - minus].add(updateInfo);
  }

  static Alert build([Tile property]) {
    Tile tile = property ?? Game.data.player.positionTile;
    if (!Game.data.player.hasAll(tile.idPrefix)) {
      return Alert("Couldn't build house",
          "You don't have all the properties of this street .");
    }
    if (!Game.data.player.hasAllUnmortaged(tile.idPrefix)) {
      return Alert("Couldn't build house",
          "You don't have all the properties of this street unmortaged.");
    }
    if (tile.housePrice == null)
      return Alert("Couldn't build house", "No house price specified?");
    if (data.player.money < tile.housePrice) return Alert.funds();
    if (tile.level >= tile.rent.length - 1)
      return Alert("Not upgradable",
          "The tile ${tile.name} is already the highest level.");
    if (!data.settings.remotelyBuild) {
      if (property.mapIndex != Game.data.player.position) {
        return Alert("Couldn't build house",
            "You can not remotely build houses. (You can change this in settings)");
      }
    }
    try {
      act.pay(PayType.bank, tile.housePrice, count: true, shouldSave: false);
    } on Alert catch (e) {
      return e;
    }
    tile.level++;
    save(exclude: [
      SaveData.settings.toString(),
      SaveData.dealData.toString(),
      SaveData.lostPlayers.toString(),
    ]);
    return Alert.snackBar("Build 1 house", "house");
  }

  static launch() {
    if (data.running ?? false) return;
    Game.data.running = true;

    //init variables
    if (testing ?? false) {
      data.settings.name = "test game";
    }

    if (Game.data.extensions.contains(Extension.bank)) {
      Game.data.bankData = BankData();
    }
    try {
      if (Game.data.settings.startProperties != 0) {
        List<Tile> buyables =
            Game.data.gmap.where((element) => element.buyable).toList();
        Game.data.settings.startProperties = min(
          Game.data.settings.startProperties,
          buyables.length / Game.data.players.length,
        ).floor();
        for (int i = 0; i < Game.data.settings.startProperties; i++) {
          Game.data.players.forEach((Player p) {
            var where = buyables
                .where((element) => element.owner == null)
                .map<int>((e) => e.mapIndex);
            int r = Random().nextInt(where.length);
            p.properties.add(Game.data.gmap[where.toList()[r]].id);
          });
        }
        Game.data.players.forEach((Player p) {
          p.properties.sort((a, b) => a.compareTo(b));
        });
      }
    } catch (e) {
      UIBloc.alerts.add(Alert("Start properties failed", "$e"));
    }

    data.findingsIndex = Random().nextInt(findings.length);
    data.eventIndex = Random().nextInt(events.length);
    data.currentPlayer = 0;

    data.players.forEach((Player p) {
      p.money = Game.data.settings.startingMoney.toDouble();
    });
    save();
  }

  //basic interactions

  static Alert executeEvent(Function func) {
    data.rentPayed = true;
    var r;
    try {
      r = func();
    } on Alert catch (e) {
      return e;
    }
    if (r is Alert) {
      return r;
    }

    Game.save();
    return null;
  }

  static void jump(
      [int newPosition, bool passGo = true, bool inRentPayed = false]) {
    if (newPosition == null)
      newPosition = Random().nextInt(Game.data.gmap.length);
    bool passesGo = Game.data.player.position > newPosition && passGo;
    if (passesGo) {
      onPassGo();
    }

    Game.data.player.position = newPosition;

    data.rentPayed = inRentPayed;

    Game.save();
  }

  static void move(int dice1, int dice2, {bool shouldSave: true}) {
    if (!ui.shouldMove) return;
    ui.shouldMove = false;
    data.rentPayed = false;

    Player player = data.player;
    data.currentDices = [dice1, dice2];
    int steps = dice1 + dice2;

    if (player.jailed) {
      data.doublesThrown = 0;
      if (dice1 == dice2 || player.jailTries == 0) {
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
      helper.jail(data.currentPlayer, shouldSave: false);
    } else {
      if (dice1 != dice2) data.doublesThrown = 0;
      for (int i = 0; i < steps; i++) {
        if (player.position >= data.gmap.length - 1) {
          player.position = 0;
          onPassGo();
        } else {
          player.position++;
        }
      }

      switch (data.gmap[player.position].type) {
        case TileType.police:
          Game.helper.jail(player.index, shouldSave: false);
          break;
        default:
      }
    }
    if (shouldSave) {
      save(exclude: [
        SaveData.settings.toString(),
        SaveData.dealData.toString(),
      ]);
    }
  }

  static Alert nextCheck() {
    TileType _type = Game.data.player.positionTile.type;
    Player _owner = Game.data.player.positionTile.owner;

    if (_owner != null && _owner != Game.data.player) {
      if (!Game.data.rentPayed)
        return Alert("Rent not payed", "Please pay rent before continuing");
    }
    if (_type == TileType.tax && !Game.data.rentPayed) {
      return Alert(
          "Taxes not payed", "Please pay your taxes before continuing");
    }
    if ((_type == TileType.chance || _type == TileType.chest) &&
        !Game.data.rentPayed) {
      return Alert("Card not executed",
          "Tap on the Findings or Event card and execute it.");
    }

    if (Game.data.player.money < 0)
      return Alert("Negative cash",
          "You can not have negative cash! Make your cash postion positive or default.");
    return null;
  }

  static Alert next({force: false, changeS: false}) {
    data.findingsIndex = Random().nextInt(findings.length);
    data.eventIndex = Random().nextInt(events.length);
    Alert alert = nextCheck();
    if (alert != null && !force) return alert;

    if (data.currentDices[0] == data.currentDices[1] && !data.player.jailed) {
      data.doublesThrown++;
    } else if (data.currentPlayer == data.players.length - 1) {
      data.currentPlayer = 0;
      onNewTurn();
    } else {
      data.currentPlayer++;
    }

    if (changeS) UIBloc.changeScreen(Screen.move);
    Game.data.ui.shouldMove = true;
    ExtensionsMap.event((data) => data.onNext);

    if (data.player.ai.type == AIType.normal && Game.ui.realPlayers) {
      UIBloc.changeScreen(Screen.idle);
      NormalAI.onPlayerTurn();
    }
    if (MainBloc.online && Game.data.ui.idle) {
      UIBloc.changeScreen(Screen.idle);
    }

    save();
    return null;
  }

  static onNewTurn() {
    BankExtension.onNewTurn();
    TransportationBloc.data.onNewTurn();
    data.turn++;
    //after here
    data.players.asMap().forEach((int i, _) {
      Player mapPlayer = data.players[i];
      addInfo(UpdateInfo(title: "turn ${data.turn}", leading: "time"), i);
      data.players[i].info[data.turn + 1] = [];
      data.players[i].info[data.turn + 2] = [];
      BankExtension.onNewTurnPlayer(i);

      data.players[i].moneyHistory.add(mapPlayer.money);
    });
  }

  static onPassGo() {
    int _goBonus = Game.data.settings.goBonus;
    data.player.money += _goBonus;

    addInfo(UpdateInfo(title: "Received go bonus: $_goBonus"));

    BankExtension.onPassGo();
  }
}
