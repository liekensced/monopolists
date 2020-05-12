import 'dart:math' as Math;

import 'package:plutopoly/engine/kernel/core_actions.dart';

import '../../data/extensions.dart';
import '../../kernel/main.dart';
import '../../ui/alert.dart';

import 'data/stock.dart';

class StockBloc {
  static onNewTurn() {
    if (!Game.data.extensions.contains(Extension.stock)) return;
    double newWSFactor = 0;

    newWSFactor += getRandomStockFactor();
    newWSFactor += 1 + getBullStockFactor();
    newWSFactor += 1 + getExpenditureStockFactor();

    Game.data.bankData.worldStock.value *= Math.max((newWSFactor / 3), 0.1);
    Game.data.bankData.worldStock.value +=
        correction(Game.data.turn, Game.data.bankData.worldStock.value);

    if (Game.data.bankData.worldStock.value < 1) {
      Game.data.bankData.worldStock.value = 1;
    }
    Game.data.bankData.bullPoints =
        ((Game.data.bankData.bullPoints + getWSDifference) * 0.85 +
                (Game.data.bankData.bullPoints < 0 ? 10 : -10))
            .toInt();
    Game.data.bankData.volatility += Math.Random().nextInt(2) - 1;

    Game.data.bankData.worldStock.valueHistory[Game.data.turn] =
        Game.data.bankData.worldStock.value;
  }

  static getExpenditureStockFactor() {
    return (Game.data.bankData.expandatureList[Game.data.turn] -
            Game.data.bankData.bullPoints * 2) /
        (50 * Game.data.bankData.worldStock.value);
  }

  static Alert buyWorldStock() {
    Alert alert;
    alert = Game.act.pay(
        PayType.bank, (Game.data.bankData.worldStock.value * 1.05).toInt(),
        count: true);
    if (alert != null) return alert;
    Game.data.player.stock[Stock.world().id] =
        (Game.data.player.stock[Stock.world().id] ?? 0) + 1;
    Game.save();
    return null;
  }

  static Alert sellWorldStock() {
    if ((Game.data.player.stock[Stock.world().id] ?? 0) > 0) {
      Game.data.player.money += Game.data.bankData.worldStock.value.toInt();
      Game.data.player.stock[Stock.world().id]--;
    }
    Game.data.bankData.expendature -=
        (Game.data.bankData.worldStock.value * 1.1).toInt();
    Game.save();
    return null;
  }

  static double get getWSDifference {
    if (Game.data.turn == 1) return 0;
    if (!Game.data.bankData.worldStock.valueHistory
        .containsKey(Game.data.turn - 2)) return 0;
    double lastValue =
        Game.data.bankData.worldStock.valueHistory[Game.data.turn - 2];
    double percentChange =
        ((Game.data.bankData.worldStock.value - lastValue) / lastValue) * 100;
    if (percentChange.isInfinite || percentChange.isNaN)
      percentChange = Game.data.bankData.worldStock.value;

    return percentChange;
  }

  static double getBullStockFactor() {
    int bullPoints = Game.data.bankData.bullPoints;
    if (bullPoints > 100)
      return 0.18;
    else if (bullPoints >= 0)
      return 0.13;
    else if (bullPoints < -100)
      return -0.09;
    else
      return -0.15;
  }

  static double getRandomStockFactor() {
    int stableness = Game.data.bankData.volatility;
    if (stableness < 1) stableness = 1;

    double newFactor = 0;

    for (int i = 0; i < stableness; i++) {
      newFactor += Math.sqrt(Math.Random().nextDouble()) + 0.36;
    }

    newFactor /= stableness;
    return newFactor;
  }

  static int correction(int turn, double value) {
    double dif = trend(turn) - value;
    return (-dif * 0.005 * Game.data.bankData.volatility).floor();
  }

  static double trend(int x) {
    return 100 + Math.pow(8 * x, 1 + x / 1000) * 1.2;
  }
}
