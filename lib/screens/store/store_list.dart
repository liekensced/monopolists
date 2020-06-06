import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/engine/kernel/main.dart';
import 'package:plutopoly/engine/ui/game_navigator.dart';
import 'package:plutopoly/store/default_presets.dart';
import 'package:plutopoly/store/preset.dart';

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
          return Card(
            child: Column(children: [
              Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: Text(
                  preset.title,
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(preset.description),
              ),
              Flexible(
                child: Container(),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                    primaryColor: Color(preset.primaryColor ??
                        Theme.of(context).primaryColor.value),
                    accentColor: Color(preset.accentColor ??
                        Theme.of(context).accentColor.value)),
                child: Builder(
                  builder: (context) => Align(
                    alignment: Alignment.bottomCenter,
                    child: MaterialButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text("Start game"),
                      onPressed: () async {
                        MainBloc.cancelOnline();
                        Game.newGame(await preset.data);

                        GameNavigator.navigate(context, loadGame: true);
                        SystemChrome.setSystemUIOverlayStyle(
                            SystemUiOverlayStyle(
                                statusBarColor: Color(preset.primaryColor) ??
                                    Theme.of(context).primaryColor));
                        MainBloc.prefbox.put(
                            "primaryColor",
                            preset.primaryColor ??
                                Theme.of(context).primaryColor.value);
                        MainBloc.prefbox.put(
                            "accentColor",
                            preset.accentColor ??
                                Theme.of(context).accentColor.value);
                      },
                    ),
                  ),
                ),
              )
            ]),
          );
        },
      ),
    );
  }
}
