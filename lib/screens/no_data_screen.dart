import 'package:flutter/material.dart';

import '../engine/ui/alert.dart';
import '../engine/ui/game_navigator.dart';
import '../widgets/my_card.dart';

class NoDataScreen extends StatefulWidget {
  final Alert alert;
  final bool cancel;

  const NoDataScreen({Key key, this.alert, this.cancel}) : super(key: key);
  @override
  _NoDataScreenState createState() => _NoDataScreenState();
}

class _NoDataScreenState extends State<NoDataScreen> {
  bool cancel = false;
  @override
  Widget build(BuildContext context) {
    if (widget.cancel != null) cancel = widget.cancel;
    Future.delayed(
        Duration(
          milliseconds: 3000,
        ), () {
      if (!cancel) {
        GameNavigator.navigate(context);
      }
    });
    return Scaffold(
        appBar: AppBar(title: Text("Error")),
        body: Center(
          child: MyCard(
            title: "No data loaded",
            children: [
              ListTile(title: Text("Trying again in 1 second")),
              RaisedButton(
                child: Text(
                  cancel ? "Try again" : "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (cancel) {
                    GameNavigator.navigate(context);
                  }
                  cancel = true;
                  setState(() {});
                },
              )
            ],
          ),
        ));
  }
}
