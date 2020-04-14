import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/extensions.dart';
import '../../data/tip.dart';
import '../main.dart';

class Bank {
  static get enabled => Game.data.extensions.contains(Extension.bank);
  static List<Info> getInfo() {
    List<Info> info = <Info>[];
    if (Game.data.extensions.contains(Extension.bank)) {
      info.add(
        Info(
            "Interest",
            "You get 20% interest on the money you have in the bank if you pass go.",
            InfoType.rule),
      );
    }

    return info;
  }

  static Widget icon({double size: 30}) {
    return FaIcon(FontAwesomeIcons.university, size: size);
  }

  static rent() {
    if (!enabled) return;
    Game.data.player.money += Game.data.player.money * 0.10;
  }
}
