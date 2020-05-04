import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/engine/extensions/bank/bank_main.dart';
import 'package:plutopoly/engine/extensions/bank/stock_bloc.dart';

import '../../data/extensions.dart';
import '../../data/tip.dart';
import '../../kernel/main.dart';
import '../../ui/alert.dart';
import 'data/loan.dart';

class Bank {
  //META

  static get enabled => Game.data.extensions.contains(Extension.bank);

  static Alert onEnabled([Extension type]) {
    if (Game.data.settings.startingMoney <= 1000) return null;
    return Alert("Banking",
        "If you enable this extension, you should give a lower starting money. Tap to change to 1000",
        actions: {
          "Change": (c) {
            Game.data.settings.startingMoney = 1000;
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

    if (Game.data.extensions.contains(Extension.stock)) {
      info.add(
        Info("World Stock", "__WS__", InfoType.rule),
      );
    }
    return info;
  }

  static onNewTurn() {
    if (!enabled) return;
    Game.data.bankData.expandatureList.add(Game.data.bankData.expendature);
    Game.data.bankData.expendature = 0;
    StockBloc.onNewTurn();
  }

  static onPassGo() {
    BankMain.rent();
  }

  static onNewTurnPlayer(int i) {
    if (!enabled) return;
    BankMain.onNewTurnPlayer(i);
  }

  onCountedPay(int amount) {
    if (!enabled) return;
    if (Game.data.bankData == null) return;
    Game.data.bankData.expendature += amount;
  }
}

final List<Contract> standardLoans = [
  Contract(
    amount: 100,
    interest: 0.05,
    waitingTurns: 1,
    id: "std:0",
  ),
  Contract(
    amount: 100,
    interest: 0.10,
    waitingTurns: 0,
    id: "std:1",
  ),
  Contract(
    amount: 200,
    interest: 0.03,
    waitingTurns: 4,
    id: "std:2",
    fee: 0.10,
  ),
];
