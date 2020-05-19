import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        ClipboardData data = await Clipboard.getData("text/plain");
        if (data != null) {
          if (data.text.length == 20) {
            if (kIsWeb) {
              textEditingController.text = data.text;
            }
            gamePin = data.text;
          }
        }
      } catch (e) {}
    });

    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: "Join Game",
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: textEditingController,
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
                Alert alert = await MainBloc.joinOnline(gamePin);
                if (Alert.handle(() => alert, context)) {
                  GameNavigator.navigate(context, loadGame: true);
                }
              }),
        ),
      ],
    );
  }
}
