import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../bloc/game_listener.dart';
import '../../bloc/main_bloc.dart';
import '../../bloc/ui_bloc.dart';
import '../../engine/ai/ai_type.dart';
import '../../engine/kernel/main.dart';
import '../../engine/ui/alert.dart';
import '../../engine/ui/game_navigator.dart';
import '../../widgets/end_of_list.dart';
import '../../widgets/online_extensions_card.dart';
import '../no_data_screen.dart';
import 'extensions.dart';
import 'players.dart';
import 'settings_card.dart';

class StartGameScreen extends StatefulWidget {
  final bool online;

  const StartGameScreen({Key key, this.online}) : super(key: key);
  @override
  _StartGameScreenState createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  ItemScrollController ctrl = ItemScrollController();
  bool red = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(MainBloc.METABOX).listenable(),
        builder: (context, Box box, __) {
          if (widget.online != null) if (box.get("boolOnline") == false &&
              widget.online) return NoDataScreen(cancel: true);
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                child: Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (Game.data.players[0].aiType != AIType.player &&
                      Game.data.running == true) {
                    Alert.handle(
                        () => Alert(
                            "Real player", "The first player can't be a bot"),
                        context);
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
                  }
                },
              ),
              appBar: AppBar(
                title: Text("Start new game"),
              ),
              body: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: UIBloc.maxWidth),
                  child: GameListener(builder: (context, __, _) {
                    List<Widget> items = [
                      SettingsCard(),
                      PlayersCard(red: red),
                      ExtensionsCard(),
                      OnlineExtensionsCard(),
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
