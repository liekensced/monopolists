import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
// WEB // import 'dart:js' as js;

import '../../bloc/game_listener.dart';
import '../../bloc/main_bloc.dart';
import '../../bloc/ui_bloc.dart';
import '../../engine/extensions/setting.dart';
import '../../engine/kernel/main.dart';
import '../../engine/ui/alert.dart';
import '../../engine/ui/game_navigator.dart';
import '../../widgets/end_of_list.dart';
import '../../widgets/my_card.dart';
import '../../widgets/online_extensions_card.dart';
import '../../widgets/setting_tile.dart';
import '../no_data_screen.dart';
import 'extensions_card.dart';
import 'extra_card.dart';
import 'players.dart';
import 'settings_card.dart';

class StartGameScreen extends StatefulWidget {
  final bool studio;
  final bool running;
  const StartGameScreen({Key key, this.studio: false, this.running: false})
      : super(key: key);
  @override
  _StartGameScreenState createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  ItemScrollController ctrl = ItemScrollController();
  bool red = false;

  @override
  Widget build(BuildContext context) {
    if (Game.data == null) return NoDataScreen();
    return ValueListenableBuilder(
        valueListenable: Hive.box(MainBloc.METABOX).listenable(),
        builder: (context, Box box, __) {
          return Scaffold(
              floatingActionButton: widget.studio
                  ? Container()
                  : FloatingActionButton(
                      child: Icon(
                        Icons.navigate_next,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (widget.running) {
                          Navigator.pop(context);
                          return;
                        }
                        if (Game.data.players.length >= 2 || MainBloc.online) {
                          Game.data.running = Game.data.running ?? false;
                          GameNavigator.navigate(context, loadGame: true);
                        } else {
                          red = true;
                          ctrl.scrollTo(
                              index: 1,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.decelerate);
                          setState(() {});
                          Alert.handle(
                              () => Alert("Not enough players",
                                  "Please add at least 2 players or bots",
                                  failed: false),
                              context);
                        }
                        // WEB //js.context["gdsdk"].callMethod("showAd");
                      },
                    ),
              appBar: AppBar(
                title: Text(widget.studio
                    ? "Edit game settings (studio)"
                    : "Start new game"),
              ),
              body: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: UIBloc.maxWidth),
                  child: GameListener(builder: (context, __, _) {
                    List<Widget> items = [
                      SettingsCard(),
                      PlayersCard(red: red, studio: widget.studio),
                      ExtensionsCard(),
                      ExtraCard(),
                      MainBloc.online
                          ? OnlineExtensionsCard()
                          : MyCard(
                              title: "Playing with board",
                              listen: true,
                              children: [
                                SettingTile(
                                  setting: Setting<bool>(
                                      onChanged: (dynamic val) {
                                        Game.data.settings.allowDiceSelect =
                                            val;
                                        Game.save(only: [
                                          SaveData.settings.toString()
                                        ]);
                                      },
                                      value: () =>
                                          Game.data.settings.allowDiceSelect ??
                                          false,
                                      title: "Allow dice select",
                                      subtitle:
                                          "For when your playing with real dices."),
                                ),
                                SettingTile(
                                  setting: Setting<bool>(
                                      onChanged: (dynamic val) {
                                        Game.data.settings.allowPriceChanges =
                                            val;
                                        Game.save(only: [
                                          SaveData.settings.toString()
                                        ]);
                                      },
                                      value: () =>
                                          Game.data.settings
                                              .allowPriceChanges ??
                                          false,
                                      title: "Allow price changes",
                                      subtitle: "If you have other prices"),
                                ),
                              ],
                            ),
                      Container(
                        height: 100,
                        child: Center(
                          child: MaterialButton(
                            onPressed: () => UIBloc.launchUrl(
                                context, MainBloc.website + "#h.xyloj3nibgrj"),
                            textColor: Theme.of(context).primaryColor,
                            child: Text(
                              "Missing a feature?\nSuggest it!",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      EndOfList()
                    ];
                    return FractionallySizedBox(
                      heightFactor: 1,
                      child: ScrollablePositionedList.builder(
                          itemScrollController: ctrl,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return items[index];
                          }),
                    );
                  }),
                ),
              ));
        });
  }
}
