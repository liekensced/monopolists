import 'dart:math';

import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/engine/ui/alert.dart';

import '../../../engine/extensions/bank/stock_bloc.dart';
import '../../../engine/kernel/main.dart';
import '../../../widgets/my_card.dart';

class StockCard extends StatelessWidget {
  final int maxDots;

  const StockCard({Key key, this.maxDots: 20}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double percentChange = StockBloc.getWSDifference;
    bool p = percentChange >= 0;
    return MyCard(
      title: "Stock",
      children: [
        ListTile(
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "£" + Game.data.bankData.worldStock.value.floor().toString(),
                style: TextStyle(fontSize: 20),
              ),
              Container(width: 8),
              Text(
                percentChange.floor().toString() + (p ? "% ▲" : "% ▼"),
                style: TextStyle(color: p ? Colors.green : Colors.red),
              ),
            ],
          ),
          title: Text("World stock "),
        ),
        buildBezierChart(context),
        buildActionButtons(context),
        Container(height: 10)
      ],
    );
  }

  Widget buildBezierChart(BuildContext context) {
    List<DataPoint> stockData = [];
    List<double> xAxisCustomValues = [];

    for (int key = 0;
        key < Game.data.bankData.worldStock.valueHistory.length;
        key++) {
      double value = Game.data.bankData.worldStock.valueHistory[key];

      stockData.add(DataPoint(value: value, xAxis: key));
      xAxisCustomValues.add(key.toDouble());
    }

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
          stepsYAxis: Game.data.bankData.worldStock.value ~/ 10,
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

  buildActionButtons(BuildContext context) {
    if (Game.ui.idle) return Container();

    int playerStockAmount = (Game.data.player.stock["WORLD_STOCK"] ?? 0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              playerStockAmount.toString(),
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        Spacer(),
        RaisedButton(
          color: Colors.red,
          child: Text(
            " Sell ",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: playerStockAmount <= 0
              ? null
              : () {
                  Alert.handle(StockBloc.sellWorldStock, context);
                },
        ),
        Container(width: 20),
        RaisedButton(
          color: Colors.green,
          child: Text(
            "Buy ",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    title: Text("Buy share"),
                    content: Text(Game.data.bankData.worldStock.info),
                    actions: [
                      MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "close",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )),
                      MaterialButton(
                          onPressed: () {
                            Alert.handle(
                                () => StockBloc.buyWorldStock(), context);
                          },
                          child: Text(
                            "add 1",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )),
                      MaterialButton(
                          onPressed: () {
                            Alert.handleAndPop(
                                () => StockBloc.buyWorldStock(), context);
                          },
                          child: Text(
                            "take",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ))
                    ]);
              },
            );
          },
        ),
        Container(width: 10),
      ],
    );
  }
}
