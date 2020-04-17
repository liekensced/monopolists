import 'package:flutter/material.dart';
import 'package:flutter_json_widget/flutter_json_widget.dart';

import '../engine/kernel/main.dart';

class HackerScreen extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Game Data Json"),
        ),
        body: Builder(builder: (context) {
          Map<String, dynamic> json = Game.data.toJson();
          json["players"].forEach((Map<String, dynamic> players) {
            players["code"] = 1234;
          });
          return SafeArea(
              child: DefaultTextStyle.merge(
            style: TextStyle(fontSize: 20),
            child: SingleChildScrollView(
              child: JsonViewerWidget(json),
            ),
          ));
        }));
  }
}
