import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../bloc/main_bloc.dart';
import '../../screens/game/action_screen/action_screen.dart';
import '../../screens/game/move_screen.dart';
import '../../screens/start/info_screen.dart';
import '../../screens/start/start_game.dart';
import '../kernel/main.dart';

class GameNavigator {
  static void push(BuildContext context, GamePage page) {
    switch (page) {
      case GamePage.auction:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return InfoScreen();
        }));
        return;
      case GamePage.infoScreen:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return InfoScreen();
        }));
        break;
      case GamePage.settings:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return StartGameScreen();
        }));
        break;
    }
  }

  static void navigate(BuildContext context,
      {bool loadGame: false, GamePage page}) {
    MainBloc.posOveride = null;

    if (page != null) {
      push(context, page);
      return;
    }

    if (Game.data?.running == null) {
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

    if (MainBloc.hideOverlays) SystemChrome.setEnabledSystemUIOverlays([]);
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
