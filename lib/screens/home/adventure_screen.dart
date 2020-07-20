import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../bloc/main_bloc.dart';
import '../../helpers/progress_helper.dart';
import '../../widgets/animated_count.dart';
import 'adventure_page.dart';

class AdventureScreen extends StatefulWidget {
  @override
  _AdventureScreenState createState() => _AdventureScreenState();
}

class _AdventureScreenState extends State<AdventureScreen> {
  @override
  Widget build(BuildContext context) {
    int levels = 4;
    double mapHeight = MediaQuery.of(context).size.height * 1.5;

    return new Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        title: Text("adventure"),
        actions: [
          buildEnergyAction(),
          Container(
            width: 5,
          )
        ],
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          reverse: true,
          children: [
            Stack(
              children: [
                MapView(
                  height: mapHeight,
                ),
                Column(
                  children: [
                    for (int i in List.generate(levels, (index) => index))
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return AdventurePage(level: i);
                          }));
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: mapHeight / levels,
                        ),
                      ),
                  ].reversed.toList(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget buildEnergyAction() {
  return Hero(
    tag: "energy",
    child: Center(
      child: Tooltip(
        message:
            "Energy, needed to play an adventure map. You can receive these by watching daily ads.",
        child: Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: ValueListenableBuilder(
            valueListenable: Hive.box(MainBloc.ACCOUNTBOX).listenable(),
            builder: (BuildContext context, _, __) {
              return Row(
                children: <Widget>[
                  AnimatedCount(
                    count: ProgressHelper.energy,
                    duration: Duration(seconds: 1),
                  ),
                  Container(
                    height: 0,
                    width: 10,
                  ),
                  FaIcon(
                    FontAwesomeIcons.bolt,
                    size: 15,
                    color: Colors.yellow,
                  )
                ],
              );
            },
          ),
        )),
      ),
    ),
  );
}
