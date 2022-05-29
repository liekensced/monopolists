import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/screens/game/zoom_map.dart';
import 'package:plutopoly/screens/store/game_icons_data.dart';

import '../../engine/data/map.dart';
import '../../engine/data/player.dart';
import '../../engine/kernel/main.dart';

class PlayerIndicators extends StatelessWidget {
  final bool jailed;
  final Tile tile;
  final String heroTag;
  final bool zoom;

  const PlayerIndicators(
      {Key key,
      @required this.tile,
      this.jailed: false,
      this.heroTag,
      @required this.zoom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool zoom = context.findAncestorWidgetOfExactType<ZoomMap>() != null;
    List<Widget> wrap = [];
    tile.players.forEach((player) {
      if (player.jailed != jailed) return;

      if (player == Game.data.player && !Game.ui.shouldMove) {
        wrap.add(FadeIn(player, zoom));
      } else {
        wrap.add(buildTooltip(player, zoom));
      }
    });

    return Padding(
      padding: EdgeInsets.all(zoom ? 6.0 : 12.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Wrap(
          spacing: zoom ? 2 : 5,
          runSpacing: zoom ? 2 : 5,
          alignment: WrapAlignment.start,
          children: wrap,
        ),
      ),
    );
  }

  Tooltip buildTooltip(Player player, bool zoom) {
    return Tooltip(
        message: player.name,
        child: PlayerIconWidget(
          player: player,
          zoom: zoom,
        ));
  }
}

class PlayerIconWidget extends StatelessWidget {
  final Player player;
  final bool zoom;
  final int size;
  const PlayerIconWidget({
    Key key,
    @required this.player,
    @required this.zoom,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (player == null) return Container();
    double iconSize = size?.toDouble() ??
        (player.index == Game.data.currentPlayer && zoom
            ? 18
            : (zoom ? 15 : 40));
    if (player.playerIcon != null) {
      IconData data = commonGameIcons
          .firstWhere(
            (element) => element.id == player.playerIcon,
            orElse: () => commonGameIcons.first,
          )
          .data;
      if (data != null && data != FontAwesomeIcons.circle) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Icon(
            data,
            size: iconSize - 5,
            color: Color(player.color),
          ),
        );
      }
    }
    return CircleColor(color: Color(player.color), circleSize: iconSize);
  }
}

class FadeIn extends StatefulWidget {
  final Player player;
  final bool zoom;
  FadeIn(this.player, this.zoom);

  @override
  _FadeInState createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> {
  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.synchronized(
      child: FadeInAnimation(
        duration: Duration(milliseconds: 500),
        delay: Duration(milliseconds: Game.ui.moveAnimationMillis),
        child: Tooltip(
            message: widget.player.name,
            child: PlayerIconWidget(
              player: widget.player,
              zoom: widget.zoom,
            )),
      ),
    );
  }
}
