import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:plutopoly/engine/extensions/bank/bank_main.dart';

import '../../bloc/main_bloc.dart';
import '../ai/ai_type.dart';
import '../kernel/main.dart';
import 'player.dart';

part 'ui_actions.g.dart';

@JsonSerializable()
@HiveType(typeId: 5)
class UIActionsData extends HiveObject {
  @HiveField(0)
  Screen screenState = Screen.idle;

  @HiveField(1)
  bool showDealScreen = false;

  bool get ended {
    if (Game.data == null) return false;
    if (Game.data.running == null || Game.data.running == false) {
      return false;
    }
    if (Game.data.turn > Game.data.settings.maxTurnes) return true;
    if (Game.data.players.length == 1) {
      return true;
    }
    if (!realPlayers) return true;

    return false;
  }

  Player get winner {
    if (Game.data.players.length == 1) {
      Game.data.player;
    }
    Player win;
    Game.data.players.forEach((Player p) {
      if (_playerValue(p) > _playerValue(win)) {
        win = p;
      }
    });
    return win;
  }

  double _playerValue(Player p) {
    if (p == null) return double.negativeInfinity;
    return BankMain.netMoney(p) +
        BankMain.propertiesValue() +
        BankMain.stocksValue();
  }

  bool get realPlayers {
    bool real = false;
    Game.data.players.forEach((Player p) {
      if ((p.ai.type ?? AIType.player) == AIType.player) real = true;
    });
    return real;
  }

  int get amountRealPlayers {
    int amount = 0;
    Game.data.players.forEach((Player p) {
      if ((p.ai.type ?? AIType.player) == AIType.player) amount++;
    });
    return amount;
  }

  bool get idle {
    try {
      if (Game.data == null) if (!realPlayers && MainBloc.online) return false;
      if (Game.data.player.ai?.type == AIType.normal) return true;
      if (!MainBloc.online) {
        return false;
      }
      bool lost = false;
      Game.data.lostPlayers.forEach((element) {
        if (element.code == MainBloc.player.code) lost = true;
      });
      if (lost) return true;
      return Game.data.player?.code != MainBloc.player?.code;
    } catch (e) {
      return true;
    }
  }

  UIActionsData();

  factory UIActionsData.fromJson(Map<String, dynamic> json) =>
      _$UIActionsDataFromJson(json);
  Map<String, dynamic> toJson() => _$UIActionsDataToJson(this);

  int get moveAnimationMillis {
    return (Game.data.currentDices[0] + Game.data.currentDices[1] * 200 + 500);
  }
}

@HiveType(typeId: 13)
enum Screen {
  @HiveField(0)
  idle,
  @HiveField(1)
  move,
  @HiveField(2)
  active,
}
