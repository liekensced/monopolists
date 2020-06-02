import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/engine/data/extensions.dart';

import '../data/player.dart';
import '../data/tip.dart';
import '../kernel/main.dart';
import 'extension_data.dart';

class LegislationExtension {
  static ExtensionData data = ExtensionData(
    ext: Extension.legislation,
    name: "Legislation",
    hotAdd: true,
    description:
        "You can add oral agreemants to deals, but they have to follow the rules.",
    icon: ({double size: 30}) {
      return FaIcon(FontAwesomeIcons.balanceScale);
    },
    getInfo: getInfo,
  );
  static Widget icon({double size: 30}) {
    return FaIcon(FontAwesomeIcons.balanceScaleLeft, size: size);
  }

  static List<Info> getInfo() {
    return [
      // Info(
      //     "Rules",
      //     "There are rules that must be followed. Every 4 turns you can vote on some rules. One person will be the Speaker (follows dice-order). Only he can bring legislation forward and he has 2 votes.",
      //     InfoType.rule),
      Info(
          "Deals",
          "You can get creative with deals if the rules allow it. Ask for exemption of rent, free travel, rent money, ... be creative!",
          InfoType.tip),
    ];
  }

  static Player get speaker {
    return Game.data.players[(Game.data.turn ~/ 4) % Game.data.players.length];
  }
}
