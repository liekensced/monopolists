import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/engine/extensions/bank/bank_main.dart';
import 'package:plutopoly/engine/extensions/bank/stock.dart';

import '../../data/extensions.dart';
import '../../data/tip.dart';
import '../../kernel/main.dart';
import '../../ui/alert.dart';
import 'data/loan.dart';

class Bank {
  //META

  static get enabled => Game.data.extensions.contains(Extension.bank);

  static Alert onEnabled([Extension type]) {
    if (Game.data.settings.startingMoney <= 500) return null;
    return Alert("Banking",
        "If you enable this extension, you should give a lower starting money. Tap to change to 500",
        actions: {
          "Change": (c) {
            Game.data.settings.startingMoney = 500;
            Game.save();
            Navigator.pop(c);
          }
        });
  }

  static Widget icon({double size: 30}) {
    return FaIcon(FontAwesomeIcons.university, size: size);
  }

  static List<Info> getInfo() {
    List<Info> info = <Info>[];
    if (Game.data.extensions.contains(Extension.bank)) {
      info.add(
        Info(
            "Interest",
            "You get 10% interest on the money you have in the bank (minus debt) if you pass go.",
            InfoType.rule),
      );
    }

    return info;
  }

  static onNewTurn() {
    if (!enabled) return;
    Stock.onNewTurn();
  }

  static onPassGo() {
    BankMain.rent();
  }

  static onNewTurnPlayer(int i) {
    if (!enabled) return;
    BankMain.onNewTurnPlayer(i);
  }
}

final List<Contract> standardLoans = [
  Contract(
    amount: 100,
    interest: 0.05,
    fee: 0.05,
    waitingTurns: 1,
    id: "std:0",
  ),
  Contract(
    amount: 100,
    interest: 0.05,
    fee: 0.20,
    waitingTurns: 0,
    id: "std:1",
  ),
  Contract(
    amount: 200,
    interest: 0.03,
    waitingTurns: 3,
    id: "std:2",
  ),
];
