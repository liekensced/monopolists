import 'dart:math';

import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/engine/ai/ai_type.dart';
import 'package:plutopoly/engine/ai/normal/normal_ai.dart';
import 'package:plutopoly/engine/data/actions.dart';
import 'package:plutopoly/engine/data/extensions.dart';
import 'package:plutopoly/engine/data/info.dart';
import 'package:plutopoly/engine/data/main_data.dart';
import 'package:plutopoly/engine/data/map.dart';
import 'package:plutopoly/engine/data/player.dart';
import 'package:plutopoly/engine/data/ui_actions.dart';
import 'package:plutopoly/engine/extensions/bank/bank.dart';
import 'package:plutopoly/engine/extensions/transportation.dart';
import 'package:plutopoly/engine/kernel/main.dart';

import '../ui/alert.dart';

class GameEvents {
  static GameData get data => Game.data;

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

    Game.save();
    return null;
  }

  static onNewTurn() {
    BankExtension.onNewTurn();
    TransportationBloc.data.onNewTurn();
    data.turn++;
    //after here
    data.players.asMap().forEach((int i, _) {
      Player mapPlayer = data.players[i];
      Game.addInfo(UpdateInfo(title: "turn ${data.turn}", leading: "time"), i);

      BankExtension.onNewTurnPlayer(i);

      data.players[i].moneyHistory.add(mapPlayer.money);
    });
  }

  static onPassGo() {
    int _goBonus = Game.data.settings.goBonus;
    data.player.money += _goBonus;

    Game.addInfo(UpdateInfo(title: "Received go bonus: $_goBonus"));

    BankExtension.onPassGo();
  }
}
