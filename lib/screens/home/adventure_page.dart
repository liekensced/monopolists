import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/screens/home/adventure_screen.dart';
import 'package:plutopoly/store/adventure/adventure_data.dart';
import 'package:plutopoly/store/preset.dart';

class AdventurePage extends StatefulWidget {
  final int level;

  const AdventurePage({Key key, @required this.level}) : super(key: key);

  @override
  _AdventurePageState createState() => _AdventurePageState();
}

class _AdventurePageState extends State<AdventurePage> {
  ScrollController scrollController;
  PageController pageController;
  @override
  void dispose() {
    scrollController.dispose();
    pageController.dispose();
    super.dispose();
  }

  AdventureLand get land => classicAdventure[widget.level];

  @override
  Widget build(BuildContext context) {
    double mapHeight = MediaQuery.of(context).size.height * 1.5;
    scrollController ??=
        ScrollController(initialScrollOffset: mapHeight * widget.level / 4);
    pageController ??= PageController(
        viewportFraction: min(
            0.8, UIBloc.maxWidth * 0.8 / MediaQuery.of(context).size.width));

    return Scaffold(
        body: SafeArea(
      child: FractionallySizedBox(
        heightFactor: 1,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 350.0,
                floating: false,
                pinned: true,
                backgroundColor: Theme.of(context).primaryColor,
                actions: [buildEnergyAction()],
                flexibleSpace: FlexibleSpaceBar(
                  background: SingleChildScrollView(
                    controller: scrollController,
                    physics: NeverScrollableScrollPhysics(),
                    child: MapView(
                      level: widget.level,
                      height: mapHeight,
                    ),
                  ),
                  title: Text(land.name),
                ),
              ),
            ];
          },
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(land.description),
              ),
              Container(
                height: 300,
                child: PageView(
                  controller: pageController,
                  children: [
                    for (Level level in land.levels)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 80,
                            child: Stars(
                              level: level,
                              land: land,
                            ),
                          ),
                          Container(
                            child: LevelCard(level: level),
                            height: 200,
                          ),
                        ],
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

class Stars extends StatelessWidget {
  final Level level;
  final AdventureLand land;
  const Stars({
    Key key,
    @required this.level,
    @required this.land,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LevelProgress progress = LevelProgress.get(level.id(land));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Star(
          gotten: progress.stars >= 1,
        ),
        Container(
          width: 10,
        ),
        Star(
          large: true,
          gotten: progress.stars >= 2,
        ),
        Container(
          width: 10,
        ),
        Star(
          gotten: progress.stars >= 3,
        ),
      ],
    );
  }
}

class Star extends StatelessWidget {
  final bool gotten;
  final bool large;
  const Star({
    Key key,
    this.gotten: false,
    this.large: false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (gotten) {
      return FaIcon(
        FontAwesomeIcons.solidStar,
        color: Colors.yellow,
        size: large ? 40 : 30,
      );
    }
    return FaIcon(
      FontAwesomeIcons.star,
      size: large ? 40 : 30,
    );
  }
}

class LevelCard extends StatelessWidget {
  const LevelCard({
    Key key,
    @required this.level,
  }) : super(key: key);

  final Level level;

  @override
  Widget build(BuildContext context) {
    Preset preset = level.preset;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: Text(
                preset.title,
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(preset.description ?? "no description"),
            ),
            Spacer(),
            Theme(
              data: Theme.of(context).copyWith(
                  primaryColor: Color(preset.primaryColor ??
                      Theme.of(context).primaryColor.value),
                  accentColor: Color(preset.accentColor ??
                      Theme.of(context).accentColor.value)),
              child: Builder(
                builder: (context) => Align(
                  alignment: Alignment.bottomCenter,
                  child: Tooltip(
                    message: "Start game",
                    child: MaterialButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text("Start game"),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MapView extends StatelessWidget {
  final int level;
  final double height;
  const MapView({
    Key key,
    this.level,
    @required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "mapView",
      child: Center(
        child: Image.asset(
          "assets/map.png",
          fit: BoxFit.cover,
          height: height,
          semanticLabel: "Map view",
        ),
      ),
    );
  }
}
