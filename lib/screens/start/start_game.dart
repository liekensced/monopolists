import 'package:flutter/material.dart';
import 'package:monopolists/engine/kernel/main.dart';
import 'package:monopolists/engine/ui/game_navigator.dart';
import 'package:monopolists/screens/start/settings_card.dart';
import 'package:monopolists/widgets/end_of_list.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../bloc/main_bloc.dart';
import 'extensions.dart';
import 'players.dart';

class StartGameScreen extends StatefulWidget {
  @override
  _StartGameScreenState createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  ItemScrollController ctrl = ItemScrollController();
  bool red = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.navigate_next,
            color: Colors.white,
          ),
          onPressed: () {
            if (Game.data.players.length >= 2) {
              Game.data.running = false;
              GameNavigator.navigate(context);
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
        body: ValueListenableBuilder(
            valueListenable: MainBloc.listen(),
            builder: (context, __, _) {
              List<Widget> items = [
                SettingsCard(),
                PlayersCard(red: red),
                ExtensionsCard(),
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
            }));
  }
}
