import 'package:flutter/material.dart';

import 'package:plutopoly/engine/data/extensions.dart';
import 'package:plutopoly/engine/data/tip.dart';
import 'package:plutopoly/engine/extensions/setting.dart';
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
  final bool hotAdd;
  Alert Function() onAdded;
  Alert Function() onNewTurn;
  Alert Function() onNewTurnPlayer;
  Alert Function() onPassGo;
  Alert Function() onNext;
  List<Setting> settings;
  ExtensionData({
    @required this.ext,
    @required this.getInfo,
    @required this.name,
    @required this.description,
    @required this.icon,
    this.hotAdd: false,
    this.dependencies: const [],
    this.settings: const [],
    this.onAdded,
    this.onNewTurn,
    this.onNewTurnPlayer,
    this.onPassGo,
    this.onNext,
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
