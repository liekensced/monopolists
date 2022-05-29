import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:plutopoly/engine/ui/alert.dart';
import 'package:plutopoly/helpers/progress_helper.dart';
import 'package:plutopoly/store/adventure/levels/classic_adventure_lands.dart';
import 'package:plutopoly/widgets/end_of_list.dart';
import 'package:plutopoly/widgets/my_card.dart';

import '../../bloc/main_bloc.dart';
import '../../bloc/ui_bloc.dart';
import '../../engine/data/main_data.dart';
import '../../engine/kernel/main.dart';
import '../../engine/ui/game_navigator.dart';
import '../../store/adventure/adventure_data.dart';
import '../../store/adventure/level_page.dart';
import '../../store/preset.dart';
import 'adventure_screen.dart';

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

  AdventureLand get land => classicAdventureLands[widget.level];

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
                    reverse: true,
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
          body: AdventurePageBody(land: land, pageController: pageController),
        ),
      ),
    ));
  }
}

class AdventurePageBody extends StatelessWidget {
  const AdventurePageBody({
    Key key,
    @required this.land,
    @required this.pageController,
  }) : super(key: key);

  final AdventureLand land;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    if (!land.isOpen()) {
      return Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: ListView(
            children: [
              Container(
                height: 150,
              ),
              Center(
                child: Icon(
                  Icons.lock,
                  size: 70,
                ),
              ),
              Container(
                height: 10,
              ),
              Center(
                child: Text("This needs to be unlocked"),
              )
            ],
          ),
        ),
      );
    }
    return ListView(
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
                      child: ValueListenableBuilder(
                        valueListenable:
                            Hive.box(MainBloc.ACCOUNTBOX).listenable(),
                        builder: (context, _, __) => LevelCard(
                          level: level,
                          land: land,
                        ),
                      ),
                      height: 200,
                    ),
                  ],
                )
            ],
          ),
        ),
        Container(
          constraints: BoxConstraints(maxWidth: UIBloc.maxWidth),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  MyCard(
                    title: "info",
                    smallTitle: true,
                    children: [
                      ListTile(
                        title: Text("Energy"),
                        subtitle: Text(
                            "To play a game in adventure mode you need to play 1 Energy."),
                        leading: FaIcon(
                          FontAwesomeIcons.bolt,
                          color: Colors.yellow,
                        ),
                      ),
                      Divider(),
                      ListTile(
                        title: Text("Receive more Energy"),
                        subtitle:
                            Text("You get 1-3 energy by watching a daily ad."),
                        leading: FaIcon(
                          FontAwesomeIcons.plus,
                          color: Colors.red,
                        ),
                      ),
                      Divider(),
                      ListTile(
                        title: Text("Unlock new levels"),
                        subtitle: Text(
                            "If you win a level you unlock the next. If you win 3 levels in a land, you unlock the next land."),
                        leading: FaIcon(
                          FontAwesomeIcons.road,
                        ),
                      ),
                    ],
                  ),
                  MyCard(
                    title: "Stars",
                    smallTitle: true,
                    children: [
                      ListTile(
                        title: Text("Win the game"),
                        subtitle:
                            Text("You get 1 star if you if you win a game."),
                        leading: FaIcon(
                          FontAwesomeIcons.solidStar,
                          color: Colors.yellow,
                        ),
                      ),
                      Divider(),
                      ListTile(
                        title: Text("Win fast"),
                        subtitle: Text(
                            "You get 1 extra star if you finish in an amount of turns."),
                        leading: FaIcon(
                          FontAwesomeIcons.solidStar,
                          color: Colors.yellow,
                        ),
                      ),
                      Divider(),
                      ListTile(
                        title: Text("Hard mode"),
                        subtitle: Text(
                            "You get 1 extra star if you win in hard mode. coming soon"),
                        leading: FaIcon(
                          FontAwesomeIcons.solidStar,
                          color: Colors.yellow,
                        ),
                      ),
                    ],
                  ),
                  EndOfList()
                ],
              ),
            ),
          ),
        )
      ],
    );
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

class LevelCard extends StatefulWidget {
  const LevelCard({
    Key key,
    @required this.level,
    @required this.land,
  }) : super(key: key);

  final Level level;
  final AdventureLand land;

  @override
  _LevelCardState createState() => _LevelCardState();
}

class _LevelCardState extends State<LevelCard> {
  Level get level => widget.level;
  @override
  Widget build(BuildContext context) {
    String levelId = level.id(widget.land);
    LevelProgress progress = LevelProgress.get(levelId);
    Preset preset = level.preset;
    bool open = progress.isOpen(widget.land, level);
    bool played = progress.best != null;
    GameData openedGame = Hive.box(MainBloc.GAMESBOX)
        .values
        .toList()
        .whereType<GameData>()
        .toList()
        .firstWhere((element) => element.levelId == levelId,
            orElse: () => null);
    bool gameOpen = openedGame != null;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        child: Stack(
          children: [
            if (!progress.unlocked)
              Center(
                child: InkWell(
                  onTap: () {
                    if (open) {
                      progress.unlocked = true;
                      progress.save();
                      setState(() {});
                    }
                  },
                  child: Icon(
                    open ? Icons.lock_open : Icons.lock,
                    size: 40,
                  ),
                ),
              ),
            AnimatedOpacity(
              opacity: progress.unlocked ? 1 : 0.1,
              duration: Duration(milliseconds: 500),
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
                            Theme.of(context).primaryColor.value), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(preset.accentColor ??
                            Theme.of(context).colorScheme.secondary.value))),
                    child: Builder(
                      builder: (context) => Align(
                        alignment: Alignment.bottomCenter,
                        child: Tooltip(
                          message: gameOpen
                              ? "Continue game"
                              : (played ? "Open game" : "Start game"),
                          child: MaterialButton(
                            textColor: Theme.of(context).primaryColor,
                            child: Text(gameOpen
                                ? "Continue game"
                                : (played ? "Open game" : "Start game")),
                            onPressed: () {
                              if (played && !gameOpen) {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return LevelPage(
                                    land: widget.land,
                                    progress: progress,
                                    level: level,
                                  );
                                }));
                              } else {
                                openLevel(gameOpen, openedGame, preset, levelId,
                                    context);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void openLevel(bool gameOpen, GameData openedGame, Preset preset,
    String levelId, BuildContext context) {
  if (preset.data == null) {
    Alert.handle(
        () => Alert("No data", "This level does not exist yet.",
            type: DialogType.WARNING),
        context);
    return;
  }
  MainBloc.cancelOnline();
  if (gameOpen) {
    Game.loadGame(
      openedGame
        ..onFinished = preset.data.onFinished
        ..levelId = levelId
        ..onLaunch = preset.data.onLaunch,
    );
  } else {
    if (ProgressHelper.energy < 1) {
      Alert.handle(
          () => Alert("Energy required",
              "You need at least 1 energy. You can earn more via dialy ads."),
          context);
      return;
    } else {
      ProgressHelper.energy--;
      showSimpleNotification(
          Text(
            "Payed 1 energy",
            style: TextStyle(color: Colors.white),
          ),
          leading: FaIcon(
            FontAwesomeIcons.bolt,
            color: Colors.white,
          ));
    }
    Game.newGame(
      GameData.fromJson(preset.data.toJson())
        ..levelId = levelId
        ..onLaunch = preset.data.onLaunch
        ..onFinished = preset.data.onFinished
        ..running = false,
    );
  }

  GameNavigator.navigate(context, loadGame: true);
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
