import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/engine/kernel/main.dart';

import '../../../bloc/main_bloc.dart';
import '../../../engine/ui/game_navigator.dart';
import '../../start/start_game.dart';
import '../move_screen.dart';

void showSettingsSheet(BuildContext context, PageController pageController) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: Text(
                      "Settings",
                      style: Theme.of(context).textTheme.headline5,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  MainBloc.online
                      ? Container()
                      : InkWell(
                          onTap: () {
                            moveModalBottomSheet(context);
                          },
                          child: ListTile(
                            leading: FaIcon(FontAwesomeIcons.dice),
                            title: Text("Dice select"),
                          ),
                        ),
                  InkWell(
                    onTap: () {
                      GameNavigator.navigate(context, loadGame: true);
                    },
                    child: ListTile(
                      leading: Icon(Icons.info),
                      title: Text("Show rules"),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      MainBloc.toggleDarkMode();
                    },
                    child: ListTile(
                      leading: FaIcon(FontAwesomeIcons.adjust),
                      title: Text("Toggle dark mode"),
                    ),
                  ),
                  MainBloc.online
                      ? InkWell(
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: MainBloc.gameId));
                          },
                          child: ListTile(
                            title: Text("Game id"),
                            subtitle: Text(MainBloc.gameId),
                            trailing: IconButton(
                                icon: Icon(Icons.content_copy),
                                onPressed: () {}),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return StartGameScreen();
                            }));
                          },
                          child: ListTile(
                            leading: Icon(Icons.settings),
                            title: Text("Open Game settings"),
                          ),
                        ),
                  InkWell(
                    onTap: () {
                      pageController.animateToPage(Game.data.player.position,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOutCubic);
                    },
                    child: ListTile(
                      leading: Icon(Icons.location_searching),
                      title: Text("Locate player"),
                    ),
                  ),
                ],
              );
            });
      });
}
