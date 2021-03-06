import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/engine/data/extensions.dart';
import 'package:plutopoly/engine/extensions/bank/bank_main.dart';
import 'package:plutopoly/engine/kernel/main.dart';
import 'package:plutopoly/helpers/money_helper.dart';

import '../../../engine/extensions/bank/data/loan.dart';
import '../../../engine/ui/alert.dart';
import '../../../widgets/my_card.dart';

class LoanCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!UIBloc.playing) return Container();
    if (!Game.data.extensions.contains(Extension.bank)) return Container();

    List<Widget> loans = [];

    loans.add(Container(
      height: 40,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("${mon(UIBloc.gamePlayer.debt)}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(
                " / ${mon(BankMain.lendingCap())}"
                " lend ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Tooltip(
              message:
                  "This is the maximum you can lend. (Cash * 2 + assets / 2)",
              child: Icon(
                Icons.info,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    ));

    BankMain.getLoans().forEach((Contract loan) {
      loans.add(ListTile(
        title:
            Text("+${mon(loan.amount)} with ${loan.interest * 100}% interest."),
        subtitle: Text(
            "Start fee: ${loan.fee * 100}%. Receive in ${loan.waitingTurns} turns."),
        trailing: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.creditCard,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: Text("Take loan"),
                      content: Text(
                          "+${mon(loan.amount.toInt())} with ${loan.interest * 100}% interest.\n" +
                              "Start fee: ${loan.fee * 100}%. Receive in ${loan.waitingTurns} turns."),
                      actions: [
                        MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "close",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            )),
                        MaterialButton(
                            onPressed: () {
                              Alert.handle(() => BankMain.lend(loan), context);
                            },
                            child: Text(
                              "add 1",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            )),
                        MaterialButton(
                            onPressed: () {
                              Alert.handleAndPop(
                                  () => BankMain.lend(loan), context);
                            },
                            child: Text(
                              "take",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ))
                      ]);
                },
              );
            }),
      ));
    });
    return MyCard(
      title: "Loans",
      children: loans,
    );
  }
}

class DebtCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyCard(
      listen: true,
      title: "Your debt",
      children: getDebts(context),
    );
  }

  List<Widget> getDebts(BuildContext context) {
    List<Widget> debts = [];
    List<Contract> loans = UIBloc.gamePlayer.loans;
    loans.sort((l, ll) => l.fullId.compareTo(ll.fullId));
    Map<String, int> idAmount = {};
    loans.forEach((l) {
      if (idAmount.containsKey(l.fullId)) {
        idAmount[l.fullId]++;
      } else {
        idAmount[l.fullId] = 1;
      }
    });
    idAmount.forEach((String fullId, int amount) {
      Contract loan = loans.firstWhere((element) => element.fullId == fullId);
      if (amount == 0) return;
      debts.add(ListTile(
        leading: Text(
          amount.toString(),
          textScaleFactor: 2,
        ),
        title:
            Text("+${mon(loan.amount)} with ${loan.interest * 100}% interest."),
        subtitle: Text("Start fee: ${loan.fee * 100}%. " +
            ((loan.waitingTurns > 0)
                ? "Receive in ${loan.waitingTurns} turns."
                : "Received")),
        trailing: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.moneyBill,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Alert.handle(() => BankMain.payLoan(loan), context);
            }),
      ));
      amount = 1;
    });
    return debts;
  }
}
