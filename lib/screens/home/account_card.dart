import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/data/player.dart';
import '../../widgets/my_card.dart';
import '../start/players.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyCard(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            "Account",
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.start,
          ),
        ),
        ValueListenableBuilder(
          valueListenable: Hive.box(MainBloc.PREFBOX).listenable(),
          builder: (BuildContext context, _, __) {
            Player player = MainBloc.player;
            return ListTile(
              title: Text(
                  player.name == "null" ? "Please change name" : player.name),
              trailing: CircleColor(
                color: Color(player.color),
                circleSize: 20,
              ),
            );
          },
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: RaisedButton(
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            child: Container(
                width: double.infinity,
                child: Text(
                  "Change player",
                  textAlign: TextAlign.center,
                )),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AddPlayerDialog(prefPlayer: true);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
