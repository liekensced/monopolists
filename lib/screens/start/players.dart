import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/engine/ai/ai_type.dart';
import 'package:plutopoly/widgets/my_card.dart';
import 'package:plutopoly/widgets/share_tile.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/data/player.dart';
import '../../engine/kernel/../ui/alert.dart';
import '../../engine/kernel/main.dart';

class PlayersCard extends StatefulWidget {
  final bool red;
  final bool showBots;
  const PlayersCard({Key key, this.red: false, this.showBots: true})
      : super(key: key);

  @override
  _PlayersCardState createState() => _PlayersCardState();
}

class _PlayersCardState extends State<PlayersCard>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    int _playersLength = Game.data.players.length;
    bool _noPlayers = _playersLength == 0;
    return MyCard(
      title: "Players:",
      children: <Widget>[
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
                      subtitle: player.aiType == AIType.normal
                          ? Text("Normal BOT")
                          : Text("Normal player"),
                      trailing: index == 0
                          ? Container(
                              width: 0,
                            )
                          : IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                if (MainBloc.online) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          title: Text("Delete Player"),
                                          content: Text(
                                              "Are you sure you want to delete this player?"),
                                          actions: [
                                            MaterialButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "cancel",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                )),
                                            MaterialButton(
                                                onPressed: () {
                                                  if (Game.data.running ==
                                                      true) {
                                                    Game.setup
                                                        .defaultPlayer(player);
                                                  } else {
                                                    Game.setup
                                                        .deletePlayer(player);
                                                  }
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "kick",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ))
                                          ]);
                                    },
                                  );
                                } else {
                                  if (Game.data.running == true) {
                                    Game.setup.defaultPlayer(player);
                                  } else {
                                    Game.setup.deletePlayer(player);
                                  }
                                  setState(() {});
                                }
                              },
                            ));
                },
              ),
        widget.showBots ? AddBotButton() : Container(),
        AddPlayerButton()
      ],
    );
  }
}

class AddBotButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: Align(
        alignment: Alignment.centerRight,
        child: RaisedButton.icon(
          textColor: Colors.white,
          color: Colors.teal,
          icon: FaIcon(FontAwesomeIcons.robot),
          label: Text(
            "Add bot",
            textAlign: TextAlign.center,
          ),
          onPressed: Game.data.players.isEmpty
              ? null
              : () {
                  Alert.handle(Game.setup.addBot, context);
                },
        ),
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
    if (MainBloc.online) {
      return ShareTile();
    }

    return Padding(
      padding: EdgeInsets.all(20).copyWith(top: 10),
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
  final bool prefPlayer;
  const AddPlayerDialog({
    Key key,
    this.prefPlayer: false,
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
    playerId = widget.prefPlayer
        ? Random().nextInt(100)
        : (Game.data.players?.length ?? 0) + 1;
    name = "Player $playerId";
    color = ColorHelper().randomColor;
    if (!widget.prefPlayer) {
      try {
        Game.setup.addPlayerCheck(color: color);
      } on Alert {
        color = ColorHelper().randomColor;
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.prefPlayer ? Text("Change account") : Text("Add player"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            maxLength: 15,
            textCapitalization: TextCapitalization.words,
            onChanged: (String value) => name = value,
            decoration: InputDecoration(
                hintText: widget.prefPlayer
                    ? "Please enter a nickname"
                    : "Player ${Game.data.players.length + 1}"),
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
              if (widget.prefPlayer) {
                MainBloc.setPlayer(name: name, color: color);
                Navigator.pop(context);
                return;
              }
              Alert.handleAndPop(
                  () => Game.setup.addPlayer(name: name, color: color),
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
  int get randomColor =>
      exampleColors[Random().nextInt(ColorHelper().exampleColors.length)];
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
