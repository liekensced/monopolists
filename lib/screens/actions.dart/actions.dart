import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:monopolists/bloc/main_bloc.dart';
import 'package:monopolists/engine/data/player.dart';
import 'package:monopolists/engine/kernel/main.dart';
import 'package:monopolists/screens/game/deal_screen.dart';

class ActionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: MainBloc.listen(),
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
              return DealScreen(
                dealer: player.index,
              );
            }));
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
    playersList.removeLast();

    return Container(
      child: Card(
        child: Column(
          children: <Widget>[
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
      ),
    );
  }
}
