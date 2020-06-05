import 'package:flutter/material.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/engine/data/extensions.dart';
import 'package:plutopoly/engine/data/map.dart';
import 'package:plutopoly/engine/kernel/main.dart';
import 'package:plutopoly/screens/actions.dart/actions.dart';
import 'package:plutopoly/screens/actions.dart/money_card.dart';
import 'package:plutopoly/screens/actions.dart/property_action_card.dart';
import 'package:plutopoly/screens/game/action_screen/default_card.dart';
import 'package:plutopoly/screens/game/action_screen/loan_card.dart';
import 'package:plutopoly/screens/game/action_screen/stock_card.dart';
import 'package:plutopoly/widgets/end_of_list.dart';

import 'drain_the_lake_card.dart';
import 'info_card.dart';
import 'move_card.dart';

class ActionCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [
      PropertyActionCard(),
      MoneyCard(),
      ActionsCard(),
      InfoCard(),
    ];

    if (Game.data.extensions.contains(Extension.transportation) &&
        Game.data.tile.type == TileType.trainstation &&
        (Game.data.tile.owner?.trainstations ?? 0) > 1) {
      actions.insert(1, MoveCard());
    }

    if (Game.data.extensions.contains(Extension.bank)) {
      actions.add(LoanCard());
      if ((Game.data.player.loans ?? []).isNotEmpty) {
        actions.add(DebtCard());
      }
    }

    if (Game.data.extensions.contains(Extension.stock)) {
      actions.add(StockCard());
    }

    if (Game.data.extensions.contains(Extension.drainTheLake)) {
      actions.add(DrainTheLakeCard());
    }

    //END
    actions.add(DefaultCard());

    List<Widget> evenActions = [];

    List<Widget> oddActions = [];
    actions.asMap().forEach((index, w) {
      if (index.isEven)
        evenActions.add(w);
      else
        oddActions.add(w);
    });

    if (UIBloc.isWide(context)) {
      return SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: evenActions,
              ),
            ),
            Expanded(
              child: Column(
                children: oddActions,
              ),
            )
          ],
        ),
      );
    }
    actions.add(EndOfList());
    return ListView(
      shrinkWrap: true,
      children: actions,
    );
  }
}
