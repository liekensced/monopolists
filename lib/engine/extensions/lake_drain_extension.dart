import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/engine/data/extensions.dart';
import 'package:plutopoly/engine/data/map.dart';
import 'package:plutopoly/engine/data/tip.dart';
import 'package:plutopoly/engine/extensions/extension_data.dart';
import 'package:plutopoly/engine/extensions/setting.dart';
import 'package:plutopoly/engine/kernel/core_actions.dart';
import 'package:plutopoly/engine/kernel/main.dart';
import 'package:plutopoly/engine/ui/alert.dart';
import 'package:plutopoly/helpers/money_helper.dart';

class LakeDrain {
  static ExtensionData data = ExtensionData(
      name: "Drain the lake",
      description:
          "This extension allows you to add a street to the map, that you will own, for a large amount of money.",
      ext: Extension.drainTheLake,
      getInfo: () => [
            Info(
              "Drain the lake",
              "You can drain the lake for ${mon(Game?.data?.settings?.dtlPrice ?? 1500)}. This will add 2 properties to the map that you will own and can upgrade.",
              InfoType.rule,
            ),
            Info(
              "Turn 15",
              "you have to wait untill turn 15 to drain the lake.",
              InfoType.alert,
            ),
            Info(
              "Rent",
              "The 2 properties are mostly the same as the Dark Blue street.",
              InfoType.tip,
            )
          ],
      hotAdd: true,
      settings: [
        Setting<int>(
          title: "Drain price",
          subtitle:
              "The price it costs to drain the lake. Default: ${mon(1500)}",
          onChanged: (dynamic price) {
            Game.data.settings.dtlPrice = price;
            Game.save(only: [SaveData.settings.toString()]);
          },
          value: () => Game.data.settings.dtlPrice,
        )
      ],
      icon: ({double size}) => FaIcon(
            FontAwesomeIcons.water,
            size: size,
          ));
  static bool get canDrain =>
      !Game.data.gmap.any((Tile tile) => tile.idPrefix == "dtl.fl") &&
      Game.data.turn >= 15;

  /// use Alert.handle!
  static Alert drain([int color]) {
    if (!canDrain) {
      return Alert("Couldn't drain", "The lake has already been drained");
    }

    Game.act.pay(
      PayType.bank,
      Game.data.settings.dtlPrice ?? 1500,
      shouldSave: false,
    );

    Game.data.gmap.addAll([
      Tile(TileType.chance, idPrefix: "Ch", idIndex: 4),
      Tile(
        TileType.land,
        color: color ?? Game.data.player.color,
        name: "Flevo 1",
        description:
            "This property has been raised from the sea. Icecream not included.",
        price: 500,
        housePrice: 200,
        rent: [35, 175, 500, 1100, 1300, 1500],
        hyp: 200,
        idPrefix: "dtl.fl",
        idIndex: 1,
      ),
      Tile(
        TileType.land,
        color: color ?? Game.data.player.color,
        name: "Flevo 2",
        description:
            "This property has been raised from the sea. Here to make people broke.",
        price: 500,
        housePrice: 200,
        rent: [50, 200, 600, 1400, 1700, 2000],
        hyp: 200,
        idPrefix: "dtl.fl",
        idIndex: 2,
      )
    ]);
    Game.data.player.properties.addAll(["dtl.fl:1", "dtl.fl:2"]);
    Game.save();
    return Alert("Drained the lake!",
        "You drained the lake, you now own a new street with 2 properties",
        failed: false);
  }
}
