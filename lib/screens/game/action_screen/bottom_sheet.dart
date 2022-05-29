import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/helpers/progress_helper.dart';
import 'package:plutopoly/screens/command_screen.dart';
import 'package:plutopoly/screens/start/info_screen.dart';
import 'package:plutopoly/widgets/share_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../bloc/main_bloc.dart';
import '../../../bloc/ui_bloc.dart';
import '../../../engine/kernel/main.dart';
import '../../hacker_screen.dart';
import '../../start/start_game.dart';
import '../move_screen.dart';

void showSettingsSheet(BuildContext context, [PageController pageController]) {
  Widget settings = Container();
  if (UIBloc.gamePlayer == Game.data.firstRealPlayer &&
      Game.data.levelId == null) {
    settings = InkWell(
      onTap: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return StartGameScreen(
            running: true,
          );
        }));
      },
      child: ListTile(
        leading: Icon(Icons.settings),
        title: Text("Open Game settings"),
      ),
    );
  }

  showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return SafeArea(
                child: ListView(
                  shrinkWrap: true,
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return InfoScreen(
                            running: true,
                          );
                        }));
                      },
                      child: ListTile(
                        leading: Icon(Icons.info),
                        title: Text("Show rules"),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        UIBloc.resetColors();
                      },
                      child: ListTile(
                        leading: Icon(Icons.colorize),
                        title: Text("Reset colors"),
                      ),
                    ),
                    Game.data.settings.hackerScreen
                        ? ListTile(
                            title: Text("open console"),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return CommandScreen();
                              }));
                            },
                            leading: Icon(FontAwesomeIcons.terminal),
                          )
                        : Container(),
                    Game.data.settings.hackerScreen
                        ? InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return HackerScreen();
                              }));
                            },
                            child: ListTile(
                              leading: Icon(Icons.code),
                              title: Text("Hacker screen"),
                            ),
                          )
                        : Container(),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return ValueListenableBuilder(
                                valueListenable: MainBloc.prefbox.listenable(),
                                builder: (context, box, __) => BottomSheet(
                                  builder: (context) {
                                    bool track = box.get("boolTrack",
                                        defaultValue: true);
                                    bool showSnackbar = box.get(
                                        "boolShowSnackbar",
                                        defaultValue: true);
                                    bool rememberScroll = box.get(
                                        "boolRememberScroll",
                                        defaultValue: true);
                                    bool showLinear = box.get("boolShowLinear",
                                        defaultValue: true);
                                    bool showSubtitle = box.get(
                                        "boolShowSubtitle",
                                        defaultValue: true);
                                    return Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Visual settings",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        SpeedSetting(),
                                        ListTile(
                                          onTap: () {
                                            box.put("boolShowSnackbar",
                                                !showSnackbar);
                                          },
                                          trailing: showSnackbar
                                              ? Icon(Icons.check)
                                              : Container(width: 0),
                                          title: Text("Show snackbars"),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            box.put("boolShowSubtitle",
                                                !showSubtitle);
                                          },
                                          trailing: showSubtitle
                                              ? Icon(Icons.check)
                                              : Container(width: 0),
                                          title: Text(
                                              "Show property tile subtitle"),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            box.put("boolTrack", !track);
                                          },
                                          title: Text("Track other players"),
                                          trailing: track
                                              ? Icon(Icons.check)
                                              : Container(width: 0),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            box.put("boolRememberScroll",
                                                !rememberScroll);
                                          },
                                          trailing: rememberScroll
                                              ? Icon(Icons.check)
                                              : Container(width: 0),
                                          title:
                                              Text("Remember scroll position"),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            box.put(
                                                "boolShowLinear", !showLinear);
                                          },
                                          trailing: showLinear
                                              ? Icon(Icons.check)
                                              : Container(width: 0),
                                          title: Text(
                                              "Show level progress indicator"),
                                        ),
                                      ],
                                    );
                                  },
                                  onClosing: () {},
                                ),
                              );
                            });
                      },
                      child: ListTile(
                        leading: Icon(Icons.assistant),
                        title: Text("Visual settings"),
                      ),
                    ),
                    settings,
                    MainBloc.online
                        ? InkWell(
                            onTap: () {
                              try {
                                Clipboard.setData(
                                    ClipboardData(text: MainBloc.gameId));
                              } catch (e) {}
                            },
                            child: ShareTile(),
                          )
                        : Container(),
                  ],
                ),
              );
            });
      });
}

class SpeedSetting extends StatefulWidget {
  const SpeedSetting({
    Key key,
  }) : super(key: key);

  @override
  _SpeedSettingState createState() => _SpeedSettingState();
}

class _SpeedSettingState extends State<SpeedSetting> {
  @override
  Widget build(BuildContext context) {
    if (ProgressHelper.level < 20) return Container();
    return ListTile(
      title: Text("Speed change"),
      subtitle: Text("Change the speed of the game."),
      onTap: () {
        if (timeDilation < 1) {
          timeDilation = 1;
        } else if (timeDilation < 2) {
          timeDilation = 2;
        } else {
          timeDilation = 0.5;
        }
        setState(() {});
      },
      trailing: Text("x " + (1 / timeDilation).toString()),
    );
  }
}
