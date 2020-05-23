import 'dart:async';
import 'dart:math';

import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import '../../bloc/main_bloc.dart';
import '../../bloc/ui_bloc.dart';
import '../../engine/data/player.dart';
import '../../engine/kernel/main.dart';
import '../../engine/ui/game_navigator.dart';
import '../../widgets/my_card.dart';
import 'action_screen/bottom_sheet.dart';

class WinScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Game.data.currentPlayer = Game.data.ui.winner?.index ?? 0;
    return Scaffold(
      body: FractionallySizedBox(
        heightFactor: 1,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    showSettingsSheet(context);
                  },
                ),
                expandedHeight: 400.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text("Game ended",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        )),
                    background: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              "Winner",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                AnimatedCircleColor(
                                  delay: Duration(milliseconds: 0),
                                ),
                                AnimatedCircleColor(
                                  delay: Duration(milliseconds: 100),
                                ),
                                AnimatedCircleColor(
                                  delay: Duration(milliseconds: 200),
                                ),
                                AnimatedCircleColor(
                                  delay: Duration(milliseconds: 300),
                                ),
                                AnimatedCircleColor(
                                  delay: Duration(milliseconds: 400),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Card(
                              margin: EdgeInsets.all(8),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                    title: Center(
                                  child: Text(
                                    Game.data.player.name,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                    ),
                                  ),
                                )),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ];
          },
          body: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: UIBloc.maxWidth),
              child: ListView(
                children: [
                  MyCard(
                    title: "Money progression",
                    children: [
                      buildBezierChart(context),
                      Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Expanditure",
                          style: Theme.of(context).textTheme.headline3,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      buildexpanditureChart(context),
                    ],
                  ),
                  Center(
                    child: RaisedButton(
                      color: Colors.red,
                      child: Text(
                        "Reset: you can reuse this game pin",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        MainBloc.resetGame();
                        Navigator.popUntil(context, (Route d) {
                          return d.isFirst;
                        });
                        GameNavigator.navigate(context);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBezierChart(BuildContext context) {
    List<double> xAxisCustomValues = List<double>.generate(
        Game.data.player.moneyHistory.length, (i) => i + 1.0);

    List<DataPoint> playerMoney = [];
    List<BezierLine> series = [];

    if (Game.data.lostPlayers != null) {
      [...Game.data.lostPlayers, ...Game.data.players].forEach((Player player) {
        playerMoney = [];
        for (int key = 0; key < Game.data.player.moneyHistory.length; key++) {
          double value = 0;
          if (player.moneyHistory.length > key) {
            value = player.moneyHistory[key];
          }
          if (value >= 0) {
            playerMoney.add(DataPoint(xAxis: key + 1, value: value));
          } else {
            playerMoney.add(DataPoint(xAxis: key + 1, value: 0));
          }
        }

        series.add(BezierLine(
          data: playerMoney,
          lineColor: Color(player.color),
        ));
      });
    }

    return Container(
      height: min(MediaQuery.of(context).size.height / 2, 300),
      width: min(MediaQuery.of(context).size.width * 0.9, UIBloc.maxWidth - 50),
      child: BezierChart(
        bezierChartAggregation: BezierChartAggregation.MAX,
        config: BezierChartConfig(
          xAxisTextStyle: TextStyle(fontSize: 0),
          verticalIndicatorStrokeWidth: 3.0,
          verticalIndicatorColor: Colors.black26,
          showVerticalIndicator: true,
          stepsYAxis: 100,
          displayYAxis: true,
          showDataPoints: false,
        ),
        series: series,
        xAxisCustomValues: xAxisCustomValues,
        bezierChartScale: BezierChartScale.CUSTOM,
      ),
    );
  }

  Widget buildexpanditureChart(BuildContext context) {
    if (Game.data.bankData == null)
      return Container(
        height: 80,
        child: Center(child: Text("Add banking to see expanditure")),
      );
    List<double> xAxisCustomValues = List<double>.generate(
        Game.data.bankData.expandatureList.length, (i) => i + 1.0);

    List<DataPoint> expanditure = [];
    Game.data.bankData.expandatureList.asMap().forEach((int key, int value) {
      if (value >= 0) {
        expanditure.add(DataPoint(xAxis: key + 1, value: value.toDouble()));
        return;
      }
      expanditure.add(DataPoint(xAxis: key + 1, value: 0));
    });

    return Container(
      height: min(MediaQuery.of(context).size.height / 2, 300),
      width: min(MediaQuery.of(context).size.width * 0.9, UIBloc.maxWidth - 50),
      child: BezierChart(
        bezierChartAggregation: BezierChartAggregation.MAX,
        config: BezierChartConfig(
          xAxisTextStyle: TextStyle(fontSize: 0),
          verticalIndicatorStrokeWidth: 3.0,
          verticalIndicatorColor: Colors.black26,
          showVerticalIndicator: true,
          stepsYAxis: 100,
          displayYAxis: true,
          showDataPoints: false,
        ),
        series: [
          BezierLine(
            data: expanditure,
          ),
        ],
        xAxisCustomValues: xAxisCustomValues,
        bezierChartScale: BezierChartScale.CUSTOM,
      ),
    );
  }
}

class AnimatedCircleColor extends StatefulWidget {
  final Duration delay;
  const AnimatedCircleColor({
    Key key,
    @required this.delay,
  }) : super(key: key);

  @override
  _AnimatedCircleColorState createState() => _AnimatedCircleColorState();
}

class _AnimatedCircleColorState extends State<AnimatedCircleColor> {
  Timer _timer;
  bool floop = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
        floop = !floop;
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircleColor(
      color: Color(Game.data.player.color),
      circleSize: floop ? 25 : 55,
    );
  }
}
