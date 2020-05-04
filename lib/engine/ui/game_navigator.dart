import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/screens/game/win_screen.dart';
import 'package:plutopoly/screens/no_data_screen.dart';

import '../../screens/game/action_screen/action_screen.dart';
import '../../screens/game/move_screen.dart';
import '../../screens/start/info_screen.dart';
import '../../screens/start/start_game.dart';
import '../kernel/main.dart';

class GameNavigator {
  static void navigate(BuildContext context, {bool loadGame: false}) {
    UIBloc.posOveride = null;

    if (Game.data == null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return NoDataScreen();
      }));
      return;
    }
    if (Game.data.running == null) {
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

    if (Game.ui.idle) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return ActionScreen();
        }),
      );
      return;
    }

    if (UIBloc.hideOverlays) SystemChrome.setEnabledSystemUIOverlays([]);
    if (Game.ui.shouldMove) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, _, __) {
            return MoveScreen();
          },
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: Duration(milliseconds: 500),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, _, __) {
            Game.ui.loadActionScreen();
            return ActionScreen();
          },
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: Duration(milliseconds: 500),
        ),
      );
    }
  }
}

enum GamePage { auction, infoScreen, settings }
