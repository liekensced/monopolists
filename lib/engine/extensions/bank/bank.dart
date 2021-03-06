import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/engine/extensions/bank/bank_main.dart';
import 'package:plutopoly/engine/extensions/bank/stock_bloc.dart';
import 'package:plutopoly/engine/ui/alert.dart';

import '../../data/extensions.dart';
import '../../data/tip.dart';
import '../../kernel/main.dart';
import '../extension_data.dart';
import '../setting.dart';
import 'data/loan.dart';

class BankExtension {
  //META
  static ExtensionData data = ExtensionData(
      description:
          "This extensions enables loans and interests. Is used for other extensions like Stock.",
      name: "Bank 1",
      ext: Extension.bank,
      getInfo: () {
        List<Info> info = <Info>[];
        info.add(
          Info(
              "Interest",
              "You get ${Game.data?.settings?.interest ?? 5}% interest on the money you have in the bank (minus debt) if you pass go.",
              InfoType.rule),
        );

        return info;
      },
      icon: ({double size: 30}) {
        return FaIcon(FontAwesomeIcons.university, size: size);
      },
      settings: [
        Setting<int>(
          onChanged: onChanged,
          value: () => Game.data?.settings?.interest ?? 5,
          title: "Interest in percentage",
          subtitle:
              "Amount of interest you get for your cash for passing the start. Default: 5%",
        ),
      ],
      onAdded: () {
        if (Game.data.settings.startingMoney <= 1000) return null;
        return Alert(
          "Banking",
          "If you enable this extension, you should give a lower starting money. Tap to change to 1000",
          actions: {
            "Change": (c) {
              Game.data.settings.startingMoney = 1000;
              Game.save(only: [SaveData.settings.toString()]);
              Navigator.pop(c);
            }
          },
          failed: false,
        );
      });

  static onChanged(interest) {
    Game.data.settings.interest = interest;
    Game.save(only: [SaveData.settings.toString()]);
  }

  static onNewTurn() {
    if (!data.enabled) return;
    Game.data.bankData.expandatureList.add(Game.data.bankData.expendature);
    Game.data.bankData.expendature = 0;
    StockBloc.onNewTurn();
  }

  static onPassGo() {
    BankMain.rent();
  }

  static onNewTurnPlayer(int i) {
    if (!data.enabled) return;
    BankMain.onNewTurnPlayer(i);
  }

  onCountedPay(int amount) {
    if (!data.enabled) return;
    if (Game.data.bankData == null) return;
    Game.data.bankData.expendature += amount;
  }
}

final List<Contract> standardLoans = [
  Contract(
    amount: 100,
    interest: 0.06,
    waitingTurns: 1,
    id: "std:0",
    fee: 0.05,
  ),
  Contract(
    amount: 100,
    interest: 0.10,
    waitingTurns: 0,
    id: "std:1",
  ),
  Contract(
    amount: 200,
    interest: 0.04,
    waitingTurns: 4,
    id: "std:2",
    fee: 0.10,
  ),
  // Contract(
  //   amount: 500,
  //   interest: 0.02,
  //   waitingTurns: 4,
  //   id: "std:2",
  //   fee: 0.10,
  //   position: "db",
  // ),
];
