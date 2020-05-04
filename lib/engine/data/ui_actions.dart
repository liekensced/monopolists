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
  bool shouldMove = true;

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
      if ((p.aiType ?? AIType.player) == AIType.player) real = true;
    });
    return real;
  }

  bool get idle {
    if (!realPlayers) return false;
    if (!MainBloc.online) {
      if (Game.data.player.aiType == AIType.normal) return true;
      return false;
    }
    return Game.data.player.code != MainBloc.player?.code;
  }

  UIActionsData();

  factory UIActionsData.fromJson(Map<String, dynamic> json) =>
      _$UIActionsDataFromJson(json);
  Map<String, dynamic> toJson() => _$UIActionsDataToJson(this);

  void loadActionScreen() {}

  int get moveAnimationMillis {
    return (Game.data.currentDices[0] + Game.data.currentDices[1] * 200 + 500);
  }
}
