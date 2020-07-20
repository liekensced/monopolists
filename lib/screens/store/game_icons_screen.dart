import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache_builder.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../bloc/main_bloc.dart';
import '../../bloc/ui_bloc.dart';
import '../../engine/kernel/main.dart';
import '../../engine/ui/alert.dart';
import '../../helpers/progress_helper.dart';
import '../../widgets/animated_count.dart';
import '../../widgets/end_of_list.dart';
import 'game_icons_data.dart';

class GameIconScreen extends StatelessWidget {
  final bool selector;
  final bool inGame;

  const GameIconScreen({Key key, this.selector: false, this.inGame: false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: selector
          ? FloatingActionButton.extended(
              onPressed: () {
                PlayerIcon selected = GameIconHelper.selectedGameIcon;
                if (inGame ?? false) {
                  UIBloc.gamePlayer.playerIcon = selected.id;
                  Game.save();
                }
                Navigator.pop(context, selected.id);
              },
              label: Text(
                "select icon",
                style: TextStyle(color: Colors.white),
              ),
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
            )
          : FloatingActionButton.extended(
              onPressed: () {
                if (ProgressHelper.tickets < 50)
                  Alert.handle(
                      () => Alert("Tickets",
                          "You need at least 50 tickets to get a new icon."),
                      context);
                else {
                  PlayerIcon playerIcon = GameIconHelper.addGameIcon();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return FlareCacheBuilder(
                        [
                          AssetFlare(
                              bundle: rootBundle, name: "assets/open.flr")
                        ],
                        builder: (context, loaded) {
                          if (!loaded)
                            return Center(child: CircularProgressIndicator());
                          return NewPlayerIconDialog(
                            playerIcon: playerIcon,
                          );
                        },
                      );
                    },
                  );
                }
              },
              label: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Text(
                      "New icon 50 ",
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.local_activity,
                      color: Colors.white,
                    )
                  ],
                ),
              )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text("Icons"),
        actions: [
          Center(
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValueListenableBuilder(
                valueListenable: Hive.box(MainBloc.ACCOUNTBOX).listenable(),
                builder: (BuildContext context, _, __) {
                  return Row(
                    children: <Widget>[
                      AnimatedCount(
                        count: ProgressHelper.tickets,
                        duration: Duration(seconds: 1),
                      ),
                      Container(
                        height: 0,
                        width: 5,
                      ),
                      Icon(
                        Icons.local_activity,
                        size: 20,
                      )
                    ],
                  );
                },
              ),
            )),
          ),
          Container(
            width: 5,
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: UIBloc.maxWidth),
            child: Center(
              child: ValueListenableBuilder(
                valueListenable: Hive.box(MainBloc.ACCOUNTBOX).listenable(),
                builder: (context, __, _) {
                  PlayerIcon selectedIcon = GameIconHelper.selectedGameIcon;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(height: 30),
                        Center(
                          child: Icon(
                            selectedIcon.data,
                            size: 100,
                          ),
                        ),
                        Container(height: 10),
                        Center(
                            child: Text(
                          selectedIcon.name,
                          style: TextStyle(fontSize: 22),
                        )),
                        Container(height: 30),
                        Container(
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 5,
                            children: [
                              for (PlayerIcon playerIcon in commonGameIcons)
                                Tooltip(
                                  message: playerIcon.name,
                                  child: Card(
                                    clipBehavior: Clip.hardEdge,
                                    child: InkWell(
                                      onTap: () {
                                        if (GameIconHelper.ownedGameIcons
                                            .contains(playerIcon.id)) {
                                          GameIconHelper.selectedGameIcon =
                                              playerIcon;
                                        }
                                      },
                                      child: Container(
                                        foregroundDecoration: BoxDecoration(
                                            color: Colors.grey.withAlpha(
                                                GameIconHelper.ownedGameIcons
                                                        .contains(playerIcon.id)
                                                    ? 0
                                                    : 220)),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Icon(
                                              playerIcon.data,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                        EndOfList()
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NewPlayerIconDialog extends StatefulWidget {
  final PlayerIcon playerIcon;
  const NewPlayerIconDialog({
    Key key,
    @required this.playerIcon,
  }) : super(key: key);

  @override
  _NewPlayerIconDialogState createState() => _NewPlayerIconDialogState();
}

class _NewPlayerIconDialogState extends State<NewPlayerIconDialog>
    with SingleTickerProviderStateMixin {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    if (!open)
      Future.delayed(Duration(seconds: 1), () {
        open = true;
        setState(() {});
      });
    return AlertDialog(
        title: Text("New currency"),
        content: Container(
          alignment: Alignment.center,
          height: 200,
          width: 200,
          child: Stack(
            children: [
              FlareActor.bundle(
                "assets/open.flr",
                animation: "Untitled",
                fit: BoxFit.cover,
              ),
              Center(
                child: AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 500),
                  child: Container(
                    height: open ? 200 : 0,
                    width: open ? 200 : 0,
                    child: Center(
                      child: Text(
                          String.fromCharCode(widget.playerIcon.data.codePoint),
                          style: TextStyle(
                            fontSize: 50.0,
                            fontFamily: widget.playerIcon.data.fontFamily,
                            package: widget.playerIcon.data.fontPackage,
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "receive",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ))
        ]);
  }
}
