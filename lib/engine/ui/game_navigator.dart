import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/screens/game/win_screen.dart';
import 'package:plutopoly/screens/no_data_screen.dart';

import '../../screens/game/action_screen/action_screen.dart';
import '../../screens/start/info_screen.dart';
import '../../screens/start/start_game.dart';
import '../kernel/main.dart';

class GameNavigator {
  static void navigate(BuildContext context, {bool loadGame: false}) {
    if (Game.data == null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return NoDataScreen();
      }));
      return;
    }

    if (Game.data.running == null &&
        (Game.data.players.isEmpty ||
            (!MainBloc.online ||
                UIBloc.gamePlayer == Game.data.nextRealPlayer))) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return StartGameScreen();
      }));
      return;
    }
    if (!Game.data.running || loadGame) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return InfoScreen();
      }));
      return;
    }
    if (Game.data.ui.ended) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return WinScreen();
      }));
      return;
    }

    //DURING GAME
    if (UIBloc.hideOverlays) SystemChrome.setEnabledSystemUIOverlays([]);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        return ValueListenableBuilder(
          valueListenable: UIBloc.screenUpdate,
          builder: (BuildContext context, value, Widget child) {
            return ActionScreen();
          },
        );
      }),
    );
  }
}
