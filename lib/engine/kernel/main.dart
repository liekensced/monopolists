import 'dart:math';

import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/engine/extensions/transportation.dart';
import 'package:plutopoly/helpers/money_helper.dart';
import 'package:plutopoly/helpers/progress_helper.dart';
import 'package:plutopoly/screens/store/game_icons_data.dart';

import '../../bloc/main_bloc.dart';
import '../../places.dart';
import '../ai/ai_type.dart';
import '../ai/normal/normal_ai.dart';
import '../data/actions.dart';
import '../data/extensions.dart';
import '../data/update_info.dart';
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
  static generateNames() {
    List<int> used = [];
    Game.data.gmap.forEach((Tile property) {
      if (property.type != TileType.land) return;
      int i = Random().nextInt(MAP_NAMES.length ~/ 2) * 2;
      while (used.contains(i)) {
        i = Random().nextInt(MAP_NAMES.length ~/ 2) * 2;
      }
      used.add(i);
      property.name = MAP_NAMES[i];
      property.description = MAP_NAMES[i + 1];
    });
  }

  static save({
    force: false,
    List<String> only,
    List<String> exclude,
    bool excludeBasic: false,
    bool local: false,
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
      Player dealer = Game.data.players[Game.data.dealData.dealer];
      if (dealer.ai.type == AIType.normal) {
        NormalAI.onDealUpdate();
        MainBloc.updateUI();
      }
    }
    getPlayer() {
      if (!MainBloc.online)
        return data?.player;
      else
        return UIBloc.gamePlayer;
    }

    if (data.running == true && getPlayer().ai?.type == AIType.normal && !force)
      return;
    if (!(testing ?? false)) {
      MainBloc.save(data, only: only, exclude: exclude, local: local);
    }
  }

  static List<String> idPrefixs() {
    List<String> ids = [];
    Game.data.gmap.forEach((element) {
      if (!ids.contains(element.idPrefix))
        ids.add(
          element.idPrefix,
        );
    });
    return ids;
  }

  static Map<String, String> get streets {
    Map<String, String> streets = {};
    Game.data.gmap.forEach((element) {
      if (element.type == TileType.land)
        streets.putIfAbsent(element.idPrefix,
            () => element.name ?? element.type.toString().split(".").last);
    });
    return streets;
  }

  //launching
  static newGame([GameData preset]) {
    data = MainBloc.newGame(preset);
    if (!MainBloc.online) {
      Player account = MainBloc.player;
      setup.addPlayer(
        name: account.name,
        color: account.color,
        code: account.code,
        icon: GameIconHelper.selectedGameIcon.id,
      );
    }
    loadGame(data);
  }

  static loadGame(GameData loadData) {
    data = loadData;
  }

  static checkBot() {
    if (Game.data == null || !(Game.data.running ?? false)) return;

    if (MainBloc.online) {
      ///RETURNS
      if (Game.data.nextRealPlayer.code != UIBloc.gamePlayer.code) return;
    }
    if (Game.data.player.ai?.type == AIType.normal) {
      NormalAI.onPlayerTurn();
    }
  }

  static addInfo(UpdateInfo updateInfo, [int playerIndex]) {
    Game.data.players[playerIndex ?? Game.data.currentPlayer].info
        .add(updateInfo);
  }

  static Alert build([Tile _property]) {
    Tile tile = _property ?? Game.data.player.positionTile;
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
      if (tile.mapIndex != Game.data.player.position) {
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
    try {
      if (Game.data.onLaunch != null) Game.data.onLaunch();
    } catch (e) {
      print("failed onLaunch\n$e");
    }

    //init variables
    if (testing ?? false) {
      data.settings.name = "test game";
    }

    if (Game.data.extensions.contains(Extension.bank)) {
      Game.data.bankData = BankData();
    }
    Game.data.players.forEach((p) {
      p.position = Game?.data?.gmap
              ?.firstWhere((element) => element.type == TileType.start,
                  orElse: () => null)
              ?.mapIndex ??
          0;
    });
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

    try {
      if (data.settings.generateNames ?? false) Game.generateNames();
    } catch (e) {
      UIBloc.alerts.add(Alert("Couldn't generate names", "$e"));
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
      helper.jail(data.player, shouldSave: false);
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
          Game.save(only: [SaveData.players.toString()]);

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
    Tile currentPostionTile = Game.data.player.positionTile;
    TileType _type = currentPostionTile.type;
    Player _owner = currentPostionTile.owner;

    if (_owner != null && _owner != Game.data.player) {
      if (!Game.data.rentPayed)
        return Alert("Rent not payed", "Please pay rent before continuing");
    }
    if (_type == TileType.tax && !Game.data.rentPayed) {
      return Alert(
          "Taxes not payed", "Please pay your taxes before continuing");
    }
    if (_type == TileType.police && !Game.data.rentPayed) {
      return Alert("Go to jail", "Please go to jail");
    }
    if (_type == TileType.start &&
        !Game.data.rentPayed &&
        (Game.data.settings.doubleBonus ?? false)) {
      Game.act.doubleGoBonus(save: false);
    }
    if ((_type == TileType.chance || _type == TileType.chest) &&
        !Game.data.rentPayed) {
      return Alert("Card not executed",
          "Tap on the Findings or Event card and execute it.");
    }
    if (_type == TileType.action &&
        (currentPostionTile.actionRequired ?? true) &&
        !Game.data.rentPayed &&
        (currentPostionTile.actions ?? []).isNotEmpty) {
      return Alert("Action required", "You need to execute at least 1 action.");
    }

    if (Game.data.player.money < 0)
      return Alert("Negative cash",
          "You can not have negative cash! Make your cash postion positive or default.");
    return null;
  }

  /// If changeS experience++
  static Alert next({force: false, changeS: false}) {
    Alert alert = nextCheck();
    if (alert != null && !force) return alert;
    data.findingsIndex = Random().nextInt(findings.length);
    data.eventIndex = Random().nextInt(events.length);

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

    if (data.player.ai.type == AIType.normal &&
        (Game.ui.realPlayers || Game.testing) &&
        !Game.ui.ended &&
        Game.data.turn < 500) {
      UIBloc.changeScreen(Screen.idle);
      NormalAI.onPlayerTurn();
    }
    if (MainBloc.online && Game.data.ui.idle) {
      UIBloc.changeScreen(Screen.idle);
    }

    if (changeS) ProgressHelper.onNext();

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

      BankExtension.onNewTurnPlayer(i);

      data.players[i].moneyHistory?.add(mapPlayer.money);
    });
  }

  static onPassGo() {
    int _goBonus = Game.data.settings.goBonus;
    data.player.money += _goBonus;

    addInfo(
        UpdateInfo(
            title: "Received go bonus",
            trailing: "${mon(_goBonus)}",
            show: true),
        Game.data.currentPlayer);
    Game.save(local: true);

    BankExtension.onPassGo();
  }
}
