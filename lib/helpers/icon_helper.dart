import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache_builder.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/engine/extensions/bank/bank.dart';

class GameIcon extends StatelessWidget {
  final String iconId;
  final double size;
  final int color;

  const GameIcon(this.iconId, {Key key, this.size, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> iconCode = iconId.split(".");

    switch (iconCode[0]) {
      case "rent":
        return Icon(Icons.home);
        break;
      case "bank":
        return BankExtension.data.icon(size: size);
      case "time":
        return FaIcon(FontAwesomeIcons.solidClock, size: size);
      case "arrowRight":
        return FaIcon(FontAwesomeIcons.arrowRight, size: size);
      case "bolt":
        return FaIcon(FontAwesomeIcons.bolt, size: size);
      case "faucet":
        return FaIcon(FontAwesomeIcons.faucet, size: size);
      case "hand_usd":
        return FaIcon(FontAwesomeIcons.handHoldingUsd, size: size);
      case "i":
        return Icon(Icons.info, size: size);
      case "question":
        return flareBuilder(
            "assets/question.flr",
            FaIcon(
              FontAwesomeIcons.question,
              size: size ?? 50,
              color: Color(color ?? Colors.white.value),
            ),
            color ?? Colors.white.value);
      case "coffee":
        return flareBuilder(
          "assets/coffee.flr",
          FaIcon(FontAwesomeIcons.coffee,
              color: Color(color ?? Colors.white.value), size: size ?? 50),
          color ?? Colors.brown.value,
        );
      case "gem":
        return flareBuilder(
            "assets/gem_shine.flr",
            FaIcon(
              FontAwesomeIcons.solidGem,
              size: size ?? 50,
              color: Color(color ?? Colors.white.value),
            ),
            color ?? Colors.white.value);
    }

    return Container(width: 0);
  }

  FlareCacheBuilder flareBuilder(String path, Widget loading, [int color]) {
    return FlareCacheBuilder(
      [AssetFlare(bundle: rootBundle, name: path)],
      builder: (context, loaded) {
        if (!loaded) return Center(child: loading);
        return FlareActor(
          path,
          color: Color(color ?? Colors.white.value),
          animation: "Untitled",
        );
      },
    );
  }
}
