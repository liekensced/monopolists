import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'main_bloc.dart';

class GameListener extends StatelessWidget {
  final ValueWidgetBuilder builder;

  const GameListener({Key key, this.builder}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    try {
      if (!Hive.box(MainBloc.GAMESBOX).isOpen) {
        print("Box not opened! Not listening to game.");
        return builder(context, null, null);
      }
      return ValueListenableBuilder(
        valueListenable: Hive.box(MainBloc.GAMESBOX).listenable(),
        builder: (___, _, __) {
          return ValueListenableBuilder(
            valueListenable: Hive.box(MainBloc.UPDATEBOX).listenable(),
            builder: builder,
          );
        },
      );
    } catch (e) {
      print("GameListener failed: $e");
      return builder(context, null, null);
    }
  }
}
