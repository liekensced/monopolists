import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/screens/carousel/players_indicator.dart';
import 'package:plutopoly/screens/store/game_icons_screen.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/ai/ai_type.dart';
import '../../engine/data/player.dart';
import '../../engine/kernel/../ui/alert.dart';
import '../../engine/kernel/main.dart';
import '../../helpers/progress_helper.dart';
import '../../widgets/my_card.dart';
import '../../widgets/share_tile.dart';

class PlayersCard extends StatefulWidget {
  final bool studio;
  final bool red;
  final bool showBots;
  const PlayersCard(
      {Key key, this.red: false, this.showBots: true, this.studio: false})
      : super(key: key);

  @override
  _PlayersCardState createState() => _PlayersCardState();
}

class _PlayersCardState extends State<PlayersCard>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    bool notJoined = MainBloc.online && Game.data.players.isEmpty;
    int _playersLength = Game.data.players.length;
    bool _noPlayers = _playersLength == 0;
    return MyCard(
      title: "Players:",
      children: <Widget>[
        notJoined
            ? Center(
                child: Text(
                  "You haven't joined!\nJoin again or start a new game to try again.",
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              )
            : Container(),
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
                      subtitle: Text(player?.ai?.description ??
                          (player?.ai?.type == AIType.normal
                              ? "Normal BOT"
                              : "Normal player")),
                      trailing: !widget.showBots
                          ? Container(width: 0)
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
        widget.showBots
            ? AddBotButton(
                hard: true,
              )
            : Container(),
        AddPlayerButton(
          studio: widget.studio,
        )
      ],
    );
  }
}

class AddBotButton extends StatelessWidget {
  final bool hard;

  const AddBotButton({Key key, this.hard: false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hard) {
      if (ProgressHelper.level < 10) return Container();
    }
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: Align(
        alignment: Alignment.centerRight,
        child: RaisedButton.icon(
          textColor: Colors.white,
          color: Theme.of(context).primaryColor,
          icon: FaIcon(FontAwesomeIcons.robot),
          label: Text(
            hard ? "Add hard bot" : "Add bot",
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            Alert.handle(() => Game.setup.addBot(hard: hard), context);
          },
        ),
      ),
    );
  }
}

class AddPlayerButton extends StatelessWidget {
  final bool studio;
  const AddPlayerButton({
    Key key,
    this.studio: false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (MainBloc.online) {
      return ShareTile();
    }

    return Tooltip(
      message: studio
          ? "You can't add real players in studio mode."
          : "Add real players.",
      child: Padding(
        padding: EdgeInsets.all(20).copyWith(top: 10),
        child: RaisedButton(
          textColor: Colors.white,
          color: Theme.of(context).primaryColor,
          child: Container(
              width: double.maxFinite,
              child: Text(
                "Add player",
                textAlign: TextAlign.center,
              )),
          onPressed: studio
              ? null
              : () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AddPlayerDialog();
                    },
                  );
                },
        ),
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
  String playerIcon;

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
            autofocus: widget.prefPlayer ? true : false,
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
                circleSize: 40,
              ),
            ),
          ),
          ListTile(
            title: Text("Icon"),
            trailing: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return GameIconScreen(
                    selector: true,
                  );
                })).then((value) {
                  playerIcon = value;
                  setState(() {});
                });
              },
              child: PlayerIconWidget(
                  player:
                      Player(color: color, playerIcon: playerIcon, name: name),
                  size: 35,
                  zoom: false),
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
                  () => Game.setup
                      .addPlayer(name: name, color: color, icon: playerIcon),
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
      if (exampleAccentColors.length > index)
        return Color(exampleAccentColors[index]);
    }
    return Color(color);
  }
}
