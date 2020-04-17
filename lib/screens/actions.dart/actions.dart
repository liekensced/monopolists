import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/widgets/my_card.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/data/deal_data.dart';
import '../../engine/data/player.dart';
import '../../engine/kernel/main.dart';
import '../game/deal_screen.dart';

class ActionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GameListener(
      builder: (BuildContext context, box, __) {
        return ActionsCardChild();
      },
    );
  }
}

class ActionsCardChild extends StatelessWidget {
  const ActionsCardChild({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> playersList = [];
    Game.data.players.forEach((Player player) {
      if (player == Game.data.player) return;
      playersList.add(ListTile(
        title: Text(player.name),
        subtitle: Text(
          "£${player.money.round()}, ${player.properties.length} properties",
          overflow: TextOverflow.fade,
        ),
        trailing: RaisedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              Game.data.dealData = DealData()..dealer = player.index;
              Game.ui.showDealScreen = true;
              Game.save();
              return DealScreen(
                dealer: player.index,
              );
            })).then((_) {
              Game.data.dealData = DealData();
              Game.data.dealData.dealer = null;
              Game.save();
            });
          },
          color: Theme.of(context).primaryColor,
          child: FaIcon(
            FontAwesomeIcons.solidHandshake,
            color: Colors.white,
          ),
        ),
      ));
      playersList.add(Divider());
    });
    if (playersList.length >= 2) playersList.removeLast();

    return Container(
      child: MyCard(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: Text(
              "Deal",
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.start,
            ),
          ),
          ...playersList
        ],
      ),
    );
  }
}
