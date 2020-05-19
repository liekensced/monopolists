import 'package:flutter/material.dart';

import '../data/extensions.dart';
import '../data/map.dart';
import '../data/tip.dart';
import '../kernel/core_actions.dart';
import '../kernel/main.dart';
import '../ui/alert.dart';
import 'extension_data.dart';

class TransportationBloc {
  static ExtensionData get data => ExtensionData(
      ext: Extension.transportation,
      name: "Transportation",
      description: "Adds transportation",
      hotAdd: true,
      icon: ({double size: 30}) => Icon(
            Icons.train,
            size: size,
          ),
      getInfo: () => [
            Info(
              "Transport",
              "If you own multiple trainstations you can move between them.",
              InfoType.rule,
            ),
            Info(
              "Sell rides",
              "You can let other players use your trainstations for a price.",
              InfoType.tip,
            ),
          ],
      onNext: () {
        Game.data.transported = false;
        return null;
      });
  static bool get active =>
      Game.data.extensions.contains(Extension.transportation);
  static Alert move(Tile destination) {
    Tile tile = Game.data.tile;
    int price = tile.transportationPrice;
    if (Game.data.transported) {
      return Alert("Already transported", "You have already moved this turn.");
    }
    Game.data.transported = true;
    if (tile.owner != Game.data.player) {
      if (price == null)
        return Alert("No price specified",
            "Ask the other player to add a transportation price.");
      try {
        Game.act.pay(
          PayType.pay,
          price,
          receiver: tile.owner.index,
          shouldSave: false,
        );
      } on Alert catch (e) {
        return e;
      }
    }
    Game.jump(destination.mapIndex, true, true);
    return null;
  }
}
