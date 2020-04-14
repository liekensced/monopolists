import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../engine/data/map.dart';
import '../../engine/data/player.dart';
import '../../engine/kernel/main.dart';

class PlayerIndicators extends StatelessWidget {
  final bool jailed;
  final Tile tile;

  const PlayerIndicators({Key key, @required this.tile, this.jailed: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> wrap = [];
    tile.players.forEach((player) {
      if (player.jailed != jailed) return;

      if (player == Game.data.player && !Game.ui.shouldMove) {
        wrap.add(FadeIn(player));
      } else {
        wrap.add(Tooltip(
            message: player.name,
            child: CircleColor(
              color: Color(player.color),
              circleSize: 40,
            )));
      }
    });

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Wrap(
          spacing: 5,
          runSpacing: 5,
          children: wrap,
        ),
      ),
    );
  }
}

class FadeIn extends StatefulWidget {
  final Player player;
  FadeIn(this.player);

  @override
  _FadeInState createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> {
  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.synchronized(
      child: FadeInAnimation(
        duration: Game.ui.shouldMove
            ? Duration(seconds: 0)
            : Duration(milliseconds: 500),
        delay: Duration(milliseconds: Game.ui.moveAnimationMillis),
        child: Tooltip(
            message: widget.player.name,
            child: CircleColor(
              color: Color(widget.player.color),
              circleSize: 40,
            )),
      ),
    );
  }
}
