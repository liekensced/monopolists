import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/main_bloc.dart';
import '../../../engine/data/bank/loan.dart';
import '../../../engine/kernel/extensions/bank.dart';
import '../../../engine/kernel/main.dart';
import '../../../engine/ui/alert.dart';
import '../../../widgets/my_card.dart';

class LoanCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> loans = [];
    Bank.getLoans().forEach((Loan loan) {
      loans.add(ListTile(
        title:
            Text("+£${loan.amount.toInt()} with ${loan.interest}% interest."),
        subtitle: Text(
            "Start fee: ${loan.fee}%. Receive in ${loan.waitingTurns} turns."),
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
                          "+£${loan.amount.toInt()} with ${loan.interest}% interest.\n" +
                              "Start fee: ${loan.fee}%. Receive in ${loan.waitingTurns} turns."),
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
                              Alert.handle(() => Bank.lend(loan), context);
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
    Game.data.player.loans.forEach((Loan loan) {
      debts.add(ListTile(
        title:
            Text("+£${loan.amount.toInt()} with ${loan.interest}% interest."),
        subtitle: Text(
            "Start fee: ${loan.fee}%. Receive in ${loan.waitingTurns} turns."),
        trailing: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.moneyBill,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Alert.handle(() => Bank.payLoan(loan), context);
            }),
      ));
    });
    return debts;
  }
}
