import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/engine/data/bank/loan.dart';
import 'package:plutopoly/engine/data/map.dart';
import 'package:plutopoly/engine/ui/alert.dart';

import '../../data/extensions.dart';
import '../../data/info.dart';
import '../../data/player.dart';
import '../../data/tip.dart';
import '../core_actions.dart';
import '../main.dart';

class Bank {
  static get enabled => Game.data.extensions.contains(Extension.bank);
  static List<Info> getInfo() {
    List<Info> info = <Info>[];
    if (Game.data.extensions.contains(Extension.bank)) {
      info.add(
        Info(
            "Interest",
            "You get 20% interest on the money you have in the bank if you pass go.",
            InfoType.rule),
      );
    }

    return info;
  }

  static List<Loan> getAllLoans() {
    return getLoans();
  }

  static double _checkLoan(Loan loan, int playerIndex) {
    if (loan.waitingTurns == 0) {
      Game.data.players[playerIndex].money += loan.amount;
      return loan.amount;
    }
    return 0;
  }

  static newTurn(int i) {
    double totalInterest = 0;
    double totalReceived = 0;
    Game.data.players[i].loans.asMap().forEach((int index, Loan loan) {
      if (loan.waitingTurns > 0) {
        Game.data.players[i].loans[index].waitingTurns--;
        totalReceived += _checkLoan(loan, i);
      } else {
        Game.data.players[i].money -= loan.interest * loan.amount;
        totalInterest += loan.interest * loan.amount;
      }
    });
    if (totalReceived != 0)
      Game.addInfo(UpdateInfo(
          title: "Received loan(s): +£$totalReceived", leading: "bank"));
    if (totalInterest != 0)
      Game.addInfo(UpdateInfo(
          title: "Total interest: -£$totalInterest", leading: "bank"));
  }

  static Widget icon({double size: 30}) {
    return FaIcon(FontAwesomeIcons.university, size: size);
  }

  static rent() {
    if (!enabled) return;
    double rent = Game.data.player.money * 0.10;
    Game.data.player.money += rent;
    Game.addInfo(UpdateInfo(title: "Received rent: +£$rent"));
  }

  static Alert payLoan(Loan loan) {
    Alert alert = Game.act.pay(PayType.bank, loan.amount.toInt());
    if (alert != null) return alert;
    Game.data.player.loans.remove(loan);
    Game.data.player.debt -= loan.amount;
    Game.save();
    return alert;
  }

  static List<Loan> getLoans([Player player]) {
    if (player == null) player = Game.data.player;
    return standardLoans;
  }

  static Alert lend(Loan loan, [Player player]) {
    if (player == null) player = Game.data.player;
    Alert alert;
    if (lendingRoom(player) < loan.amount && loan.countToCap)
      return Alert("Lend amount to high",
          "You do not posses enough assets. Try a smaller loan.");
    if (!loan.countToCap) {
      player.loans.forEach((Loan l) {
        if (l == loan) {
          alert = Alert("You already have this loan",
              "You can buy this loan only once. ");
          return;
        }
      });
    }

    if (alert != null) return alert;

    if (loan.countToCap) Game.data.player.debt += loan.amount;
    Game.act.pay(PayType.bank, (loan.amount * loan.fee).toInt());
    Game.data.player.loans.add(Loan.copy(loan));
    _checkLoan(loan, player.index);
    Game.save();
    return Alert.snackBar("Loan available in ${loan.waitingTurns} turn(s).");
  }

  static double lendingCap([Player player]) {
    if (player == null) player = Game.data.player;
    return (player.money * 3) + propertiesValue(player);
  }

  static double lendingRoom([Player player]) {
    if (player == null) player = Game.data.player;
    return lendingCap(player) - player.debt;
  }

  static double propertiesValue([Player player]) {
    if (player == null) player = Game.data.player;
    double propertiesValue = 0;
    player.properties.forEach((int index) {
      Tile tile = Game.data.gmap[index];
      propertiesValue += tile.price;
      propertiesValue += tile.level * tile.housePrice;
      if (tile.mortaged) propertiesValue -= tile.hyp;
    });
    return propertiesValue;
  }
}

final List<Loan> standardLoans = [
  Loan(
    amount: 100,
    interest: 0.05,
    fee: 0.05,
    waitingTurns: 1,
    id: "std:0",
  ),
  Loan(
    amount: 100,
    interest: 0.05,
    fee: 0.20,
    waitingTurns: 0,
    id: "std:1",
  ),
  Loan(
    amount: 200,
    interest: 0.03,
    waitingTurns: 3,
    id: "std:2",
  ),
];
