import 'dart:math';

import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
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
  void generateData() {
    Game.testing = true;
    Game.newGame();
    Game.data.extensions.add(Extension.bank);
    Game.data.extensions.add(Extension.stock);
    Game.setup.addPlayer(name: "Jeff");
    Game.launch();
    Game.ui.idle;
    while (Game.data.turn < 50) {
      Game.data.bankData.expendature =
          Random().nextInt(400 + 50 * Game.data.turn);
      Bank.onNewTurn();
      Game.data.turn++;
    }
  }

  @override
  Widget build(BuildContext context) {
    generateData();
    return Scaffold(
      appBar: AppBar(
        title: Text("Stock testing screen"),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          StockCard(
            maxDots: 99,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text("Reload"),
              onPressed: () => setState(() {}),
            ),
          ),
          buildExpenditureCard()
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

  Widget buildBezierChart(BuildContext context) {
    List<DataPoint> stockData = [];
    List<double> xAxisCustomValues = [];
    Game.data.bankData.expandatureList.asMap().forEach((key, value) {
      stockData.add(DataPoint(value: value.toDouble(), xAxis: key));
      xAxisCustomValues.add(key.toDouble());
    });
    return Container(
      height: min(MediaQuery.of(context).size.height / 2, 300),
      width:
          min(MediaQuery.of(context).size.width * 0.9, MainBloc.maxWidth - 50),
      child: BezierChart(
        bezierChartAggregation: BezierChartAggregation.MAX,
        config: BezierChartConfig(
          xAxisTextStyle: TextStyle(fontSize: 0),
          verticalIndicatorStrokeWidth: 3.0,
          verticalIndicatorColor: Colors.black26,
          showVerticalIndicator: true,
          stepsYAxis: Game.data.bankData.worldStock.value ~/ 2,
          displayYAxis: true,
          showDataPoints: false,
        ),
        series: [
          BezierLine(data: stockData, lineColor: Theme.of(context).accentColor)
        ],
        xAxisCustomValues: xAxisCustomValues,
        bezierChartScale: BezierChartScale.CUSTOM,
      ),
    );
  }
}
