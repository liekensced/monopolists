import 'dart:math';

import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/engine/data/extensions.dart';
import 'package:plutopoly/engine/extensions/bank/bank.dart';
import 'package:plutopoly/engine/kernel/main.dart';
import 'package:plutopoly/screens/game/action_screen/stock_card.dart';
import 'package:plutopoly/widgets/my_card.dart';

class StockTestingScreen extends StatefulWidget {
  @override
  _StockTestingScreenState createState() => _StockTestingScreenState();
}

class _StockTestingScreenState extends State<StockTestingScreen> {
  List<int> bullPointsHistory = [];

  int turns = 50;
  bool constExpenditure = false;

  void generateData() {
    bullPointsHistory = [];
    Game.testing = true;
    Game.newGame();
    Game.data.extensions.add(Extension.bank);
    Game.data.extensions.add(Extension.stock);
    Game.setup.addPlayer(name: "Jeff");
    Game.launch();
    Game.ui.idle;
    while (Game.data.turn < turns) {
      Game.data.bankData.expendature =
          Random().nextInt(400 + 50 * Game.data.turn);
      BankExtension.onNewTurn();
      bullPointsHistory.add(Game.data.bankData.bullPoints);
      Game.data.turn++;
    }
  }

  @override
  Widget build(BuildContext context) {
    generateData();
    return Scaffold(
      appBar: AppBar(
        title: Text("Stock testing screen"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: Text("Change turns"),
                      content: TextField(
                        decoration:
                            InputDecoration(labelText: "Enter test turns"),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          int newVal = min(int.tryParse(val), 500);
                          if (newVal != null) turns = newVal;
                        },
                      ),
                      actions: [
                        MaterialButton(
                            onPressed: () {
                              setState(() {});
                              Navigator.pop(context);
                            },
                            child: Text(
                              "enter",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ))
                      ]);
                },
              );
            },
          )
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          StockCard(
            showTrend: true,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text("Reload"),
              onPressed: () => setState(() {}),
            ),
          ),
          buildExpenditureCard(),
          buildBullCard(),
        ],
      ),
    );
  }

  MyCard buildExpenditureCard() {
    return MyCard(
      title: "Expenditure",
      children: [buildBezierChart(context)],
    );
  }

  Widget buildBullCard() {
    return MyCard(
      title: "Bull/Bear points",
      children: [buildBezierChart(context, false)],
    );
  }

  Widget buildBezierChart(BuildContext context, [bool exp = true]) {
    List<DataPoint> stockData = [];
    List<double> xAxisCustomValues = [];
    Game.data.bankData.expandatureList.asMap().forEach((key, value) {
      stockData.add(DataPoint(value: value.toDouble(), xAxis: key));
      xAxisCustomValues.add(key.toDouble());
    });
    List<DataPoint> bullData = [DataPoint(value: 0, xAxis: 0)];
    List<DataPoint> bearData = [DataPoint(value: 0, xAxis: 0)];
    bullPointsHistory.asMap().forEach((int key, int value) {
      if (value >= 0) {
        bearData.add(DataPoint(xAxis: key + 1, value: 0));
        bullData.add(DataPoint(xAxis: key + 1, value: value.toDouble()));
        return;
      }

      bearData.add(DataPoint(xAxis: key + 1, value: -value.toDouble()));
      bullData.add(DataPoint(xAxis: key + 1, value: 0));
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
        series: exp
            ? [
                BezierLine(
                    data: stockData, lineColor: Theme.of(context).accentColor)
              ]
            : [
                BezierLine(
                    data: bullData,
                    lineColor: Colors.green,
                    lineStrokeWidth: 1),
                BezierLine(
                    data: bearData, lineColor: Colors.red, lineStrokeWidth: 1),
              ],
        xAxisCustomValues: xAxisCustomValues,
        bezierChartScale: BezierChartScale.CUSTOM,
      ),
    );
  }
}
