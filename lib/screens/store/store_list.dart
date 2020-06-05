import 'package:flutter/material.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/engine/kernel/main.dart';
import 'package:plutopoly/engine/ui/game_navigator.dart';
import 'package:plutopoly/store/default_presets.dart';
import 'package:plutopoly/store/preset.dart';
import 'package:plutopoly/widgets/my_card.dart';

class StoreList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.8),
        itemCount: presets.length,
        itemBuilder: (BuildContext context, int index) {
          Preset preset = presets[index];
          return MyCard(
            title: preset.title,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(preset.description),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text("Open game"),
                  onPressed: () async {
                    MainBloc.cancelOnline();
                    Game.loadGame(await preset.data);
                    GameNavigator.navigate(context, loadGame: true);
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
