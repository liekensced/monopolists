import 'package:flutter/material.dart';

import 'package:plutopoly/engine/data/extensions.dart';
import 'package:plutopoly/engine/data/tip.dart';
import 'package:plutopoly/engine/kernel/main.dart';
import 'package:plutopoly/engine/ui/alert.dart';

class ExtensionData {
  final Extension ext;
  final Widget Function({double size}) icon;
  get enabled => Game.data.extensions.contains(Extension.bank);
  final List<Info> Function() getInfo;
  final String name;
  final String description;
  final List<Extension> dependencies;
  Alert Function() onAdded;
  Alert Function() onNewTurn;
  Alert Function() onNewTurnPlayer;
  Alert Function() onPassGo;
  ExtensionData({
    @required this.ext,
    @required this.getInfo,
    @required this.name,
    @required this.description,
    @required this.icon,
    this.dependencies: const [],
    this.onAdded,
    this.onNewTurn,
    this.onNewTurnPlayer,
    this.onPassGo,
  }) {
    if (onAdded == null) {
      onAdded = () => null;
    }
    if (onNewTurn == null) {
      onNewTurn = () => null;
    }
    if (onNewTurnPlayer == null) {
      onNewTurnPlayer = () => null;
    }
    if (onPassGo == null) {
      onPassGo = () => null;
    }
  }

  @override
  String toString() =>
      'ExtensionData(ext: $ext, icon: $icon, getInfo: $getInfo)';
}
