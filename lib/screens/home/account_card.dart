import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plutopoly/engine/ui/alert.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/data/player.dart';
import '../../widgets/my_card.dart';
import '../start/players.dart';

class AccountCard extends StatelessWidget {
  final bool welcome;
  const AccountCard({
    Key key,
    this.welcome: false,
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
          valueListenable: Hive.box(MainBloc.ACCOUNTBOX).listenable(),
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
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: FlatButton(
            textColor: Colors.red,
            child: Container(
                width: double.infinity,
                child: Text(
                  welcome
                      ? "Synchronize with previous account"
                      : "Authentication code",
                  textAlign: TextAlign.center,
                )),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return authDialog(context, welcome);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

AlertDialog authDialog(BuildContext context, bool welcome) {
  return AlertDialog(
    title: Text("Authentication code"),
    content: Container(
      constraints: BoxConstraints(maxWidth: MainBloc.maxWidth),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: "Change auth code"),
            maxLength: 10,
            keyboardType: TextInputType.number,
            onSubmitted: (String val) {
              Alert.handle(() => MainBloc.setCode(val), context);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(welcome
                ? "If you already have an account, enter the code here to synchronize."
                : "The authentication code is used to rejoin games as you. If you want to log into another device as this account, than you must enter this code on the new device."),
          ),
          MaterialButton(
            textColor: Colors.white,
            color: Colors.red,
            child: Container(
                width: double.infinity,
                child: Text(
                  "Show your code",
                  textAlign: TextAlign.center,
                )),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: Text("Your code"),
                      content: Text(
                        MainBloc.code.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                      actions: [
                        MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "close",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ))
                      ]);
                },
              );
            },
          ),
        ],
      ),
    ),
  );
}
