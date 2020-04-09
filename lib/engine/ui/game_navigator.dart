import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monopolists/engine/kernel/main.dart';
import 'package:monopolists/screens/game/action_screen/action_screen.dart';
import 'package:monopolists/screens/game/move_screen.dart';
import 'package:monopolists/screens/start/info_screen.dart';
import 'package:monopolists/screens/start/start_game.dart';

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
    if (page != null) {
      push(context, page);
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

    //DURING GAME

    SystemChrome.setEnabledSystemUIOverlays([]);
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
