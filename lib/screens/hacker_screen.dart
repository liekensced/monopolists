import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_json_widget/flutter_json_widget.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/engine/data/info.dart';
import 'package:plutopoly/engine/data/main_data.dart';
import 'package:plutopoly/engine/data/player.dart';
import 'package:plutopoly/engine/ui/alert.dart';

import '../engine/kernel/main.dart';

class HackerScreen extends StatefulWidget {
  @override
  _HackerScreenState createState() => _HackerScreenState();
}

class _HackerScreenState extends State<HackerScreen> {
  bool editMode = false;
  String text;
  @override
  Widget build(BuildContext context) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(Game.data.toJson());

    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: editMode
            ? FloatingActionButton(
                child: Icon(
                  Icons.save_alt,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (text == null) {
                    Alert.handle(
                        () => Alert("Couldn't parse json", "Nothing changed"),
                        context);
                  }
                  try {
                    Map<String, dynamic> newJson = jsonDecode(text);
                    GameData newGameData = GameData.fromJson(newJson);
                    MainBloc.resetGame(newGameData);
                    Alert.handle(
                        () => Alert(
                            "Changed data", "Data was changed succesfully!"),
                        context);
                    editMode = false;

                    Game.data.players.forEach((Player p) {
                      int index = p.index;
                      Game.addInfo(
                        UpdateInfo(
                            title: UIBloc.gamePlayer.name +
                                " changed the game data!",
                            leading: "alert"),
                        index,
                      );
                      Game.addInfo(
                          UpdateInfo(
                              title: UIBloc.gamePlayer.name +
                                  " changed the game data!",
                              leading: "alert"),
                          index);
                    });
                    setState(() {});
                  } catch (e) {
                    Alert.handle(
                        () => Alert("Couldn't parse json", e.toString()),
                        context);
                  }
                },
              )
            : Container(),
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                editMode = !editMode;
                setState(() {});
              },
            )
          ],
          title: Text("Game Data Json"),
        ),
        body: Builder(builder: (context) {
          Map<String, dynamic> json = Game.data.toJson();
          json["players"].forEach((Map<String, dynamic> players) {
            players["code"] = 1234;
          });
          return Theme(
            data: ThemeData.light(),
            child: SafeArea(
                child: DefaultTextStyle.merge(
              style: TextStyle(fontSize: 20),
              child: SingleChildScrollView(
                child: !editMode
                    ? JsonViewerWidget(json)
                    : TextFormField(
                        maxLines: null,
                        initialValue: prettyprint,
                        onChanged: (String newData) {
                          text = newData;
                        },
                      ),
              ),
            )),
          );
        }));
  }
}
