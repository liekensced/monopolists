import 'package:flutter/material.dart';
import 'package:plutopoly/screens/game/zoom_map.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map view"),
      ),
      body: ZoomMap(),
    );
  }
}
