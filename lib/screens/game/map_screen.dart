import 'package:flutter/material.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/screens/game/zoom_map.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map view"),
      ),
      body: ValueListenableBuilder(
          valueListenable: MainBloc.metaBox.listenable(),
          builder: (context, snapshot, _) {
            return ZoomMap();
          }),
    );
  }
}
