import 'package:flutter/material.dart';
import 'package:plutopoly/engine/ui/game_navigator.dart';
import 'package:plutopoly/widgets/my_card.dart';

class NoDataScreen extends StatefulWidget {
  @override
  _NoDataScreenState createState() => _NoDataScreenState();
}

class _NoDataScreenState extends State<NoDataScreen> {
  bool cancel = false;
  @override
  Widget build(BuildContext context) {
    Future.delayed(
        Duration(
          milliseconds: 2000,
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
