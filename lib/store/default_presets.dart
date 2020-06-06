import 'package:flutter/material.dart';
import 'package:plutopoly/store/preset.dart';

List<Preset> presets = [
  Preset(
    projectName: "default.trainstations",
  )
    ..title = "Trainstations"
    ..author = "filorux"
    ..description = "Battle against the other trainstation companies."
    ..primaryColor = Colors.deepOrange[800].value
    ..accentColor = Colors.deepOrangeAccent.value
    ..version = "1.0.0",
  Preset(
    projectName: "default.space",
  )
    ..title = "Coming soon"
    ..author = "filorux"
    ..description = "More maps are coming."
    ..version = "1.0.0"
];
