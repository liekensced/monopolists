import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/player.dart';
import '../../data/tip.dart';
import '../main.dart';

class Jurisdiction {
  static Widget icon({double size: 30}) {
    return FaIcon(FontAwesomeIcons.balanceScaleLeft, size: size);
  }

  static List<Info> getInfo() {
    return [
      Info(
          "Rules",
          "There are rules that must be followed. Every 4 turns you can vote on some rules. One person will be the Speaker (follows dice-order). Only he can bring legislation forward and he has 2 votes.",
          InfoType.rule),
      Info(
          "Deals",
          "You can get creative with deals if the rules allow it. Ask for exemption of rent, free travel, rent money, ... be creative!",
          InfoType.tip),
    ];
  }

  static bool get showJurisdictionScreen {
    int turn = Game.data.turn;
    return turn % 4 == 0;
  }

  static Player get speaker {
    return Game.data.players[(Game.data.turn ~/ 4) % Game.data.players.length];
  }
}
