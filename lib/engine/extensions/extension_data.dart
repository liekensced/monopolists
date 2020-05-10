import 'package:flutter/material.dart';
import 'package:plutopoly/engine/data/extensions.dart';
import 'package:plutopoly/engine/kernel/main.dart';

class ExtensionData {
  Extension ext;
  Widget icon;
  get enabled => Game.data.extensions.contains(Extension.bank);
  Function getInfo;
}
