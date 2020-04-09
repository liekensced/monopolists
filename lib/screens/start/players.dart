import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:monopolists/engine/data/player.dart';
import 'package:monopolists/engine/kernel/../ui/alert.dart';

import '../../engine/kernel/main.dart';

class PlayersCard extends StatefulWidget {
  final bool red;
  const PlayersCard({Key key, this.red: false}) : super(key: key);

  @override
  _PlayersCardState createState() => _PlayersCardState();
}

class _PlayersCardState extends State<PlayersCard>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    int _playersLength = Game.data.players.length;
    bool _noPlayers = _playersLength == 0;
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: Text(
              "Players:",
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.start,
            ),
          ),
          _noPlayers
              ? Container(
                  height: 50,
                  child: Center(
                    child: widget.red
                        ? Text("Please add players in the right order",
                            style: TextStyle(color: Colors.red))
                        : Text("Please add players in the right order"),
                  ),
                )
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _playersLength,
                  itemBuilder: (BuildContext ctxt, int index) {
                    Player player = Game.data.players[index];
                    return ListTile(
                      title: Row(
                        children: <Widget>[
                          Text(player.name),
                          Container(width: 5),
                          CircleColor(
                            circleSize: 10,
                            color: Color(player.color),
                          ),
                        ],
                      ),
                      subtitle: Text("Normal player"),
                      trailing: index == _playersLength - 1
                          ? IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => Game.setup.deleteLastPlayer(),
                            )
                          : Container(
                              width: 0,
                            ),
                    );
                  },
                ),
          AddPlayerButton()
        ],
      ),
    );
  }
}

class AddPlayerButton extends StatelessWidget {
  const AddPlayerButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: RaisedButton(
        textColor: Colors.white,
        color: Colors.teal,
        child: Container(
            width: double.maxFinite,
            child: Text(
              "Add player",
              textAlign: TextAlign.center,
            )),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AddPlayerDialog();
            },
          );
        },
      ),
    );
  }
}

class AddPlayerDialog extends StatefulWidget {
  const AddPlayerDialog({
    Key key,
  }) : super(key: key);

  @override
  _AddPlayerDialogState createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<AddPlayerDialog> {
  int playerId;
  String name;
  int color;

  @override
  void initState() {
    playerId = Game.data.players.length + 1;
    name = "Player $playerId";
    color = ColorHelper()
        .exampleColors[Random().nextInt(ColorHelper().exampleColors.length)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add player"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            textCapitalization: TextCapitalization.words,
            onChanged: (String value) => name = value,
            decoration: InputDecoration(
                hintText: "Player ${Game.data.players.length + 1}"),
          ),
          Container(
            height: 5,
          ),
          ListTile(
            title: Text("Color"),
            trailing: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    Color newColor = Colors.red;
                    return AlertDialog(
                        title: Text("Pick a color"),
                        content: MaterialColorPicker(
                          onColorChange: (Color val) {
                            newColor = val;
                          },
                        ),
                        actions: [
                          MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "cancel",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              )),
                          MaterialButton(
                              onPressed: () {
                                color = newColor.value;
                                Navigator.pop(context);
                              },
                              child: Text(
                                "save",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ))
                        ]);
                  },
                ).then((value) {
                  setState(() {});
                });
              },
              child: CircleColor(
                color: Color(color),
                circleSize: 35,
              ),
            ),
          )
        ],
      ),
      actions: [
        MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "cancel",
              style: TextStyle(color: Theme.of(context).primaryColor),
            )),
        MaterialButton(
            onPressed: () {
              Alert.handleAndPop(
                  () => Game.setup.addPlayer(name: name, color: Color(color)),
                  context);
            },
            child: Text(
              "add",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ))
      ],
    );
  }
}

class ColorHelper {
  List<int> exampleColors = [
    Colors.red.value,
    Colors.pink.value,
    Colors.purple.value,
    Colors.deepPurple.value,
    Colors.indigo.value,
    Colors.blue.value,
    Colors.lightBlue.value,
    Colors.cyan.value,
    Colors.green.value,
    Colors.lightGreen.value,
    Colors.amber[600].value,
    Colors.orange.value,
    Colors.deepOrange.value,
    Colors.black.value
  ];

  List<int> exampleAccentColors = [
    Colors.red[300].value,
    Colors.pink[300].value,
    Colors.purple[300].value,
    Colors.deepPurple[300].value,
    Colors.indigo[300].value,
    Colors.blue[300].value,
    Colors.lightBlue[300].value,
    Colors.cyan[300].value,
    Colors.green[300].value,
    Colors.lightGreen[300].value,
    Colors.amber[300].value,
    Colors.orange[300].value,
    Colors.deepOrange[300].value,
    Colors.blueGrey.value
  ];

  Color getAccent(int color) {
    assert(exampleAccentColors.length == exampleColors.length);
    if (exampleColors.contains(color)) {
      int index = exampleColors.indexOf(color);
      return Color(exampleAccentColors[index]);
    }
    return Color(color);
  }
}
