import 'package:flutter/material.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/ui/alert.dart';
import '../../engine/ui/game_navigator.dart';
import '../../widgets/my_card.dart';

class JoinOnlineCard extends StatefulWidget {
  const JoinOnlineCard({
    Key key,
  }) : super(key: key);

  @override
  _JoinOnlineCardState createState() => _JoinOnlineCardState();
}

class _JoinOnlineCardState extends State<JoinOnlineCard> {
  String gamePin = "";

  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: "Join Game",
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            maxLength: 20,
            maxLengthEnforced: true,
            onChanged: (val) {
              gamePin = val;
            },
            decoration: InputDecoration(labelText: "Enter game pin"),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: RaisedButton(
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              child: Container(
                  width: double.infinity,
                  child: Text(
                    "Join",
                    textAlign: TextAlign.center,
                  )),
              onPressed: () async {
                //"hYN1GZlPy0b0WZ0uc714"
                Alert alert = await MainBloc.joinOnline(gamePin.trim());
                if (Alert.handle(() => alert, context)) {
                  GameNavigator.navigate(context);
                }
              }),
        ),
      ],
    );
  }
}
