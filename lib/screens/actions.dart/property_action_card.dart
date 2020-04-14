import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/data/actions.dart';
import '../../engine/data/map.dart';
import '../../engine/data/player.dart';
import '../../engine/kernel/../ui/alert.dart';
import '../../engine/kernel/core_actions.dart';
import '../../engine/kernel/main.dart';
import '../../widgets/my_card.dart';

class PropertyActionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(MainBloc.GAMESBOX).listenable(),
      builder: (_, __, ___) {
        Tile tile = Game.data.player.positionTile;
        if (tile.type == TileType.chance) {
          CardAction action = events[Game.data.eventIndex];
          return FlipCard(
            front: Card(
              color: Theme.of(context).primaryColor,
              child: Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.question,
                      size: 50,
                      color: Colors.white,
                    ),
                    Container(height: 20),
                    Text(
                      "Event card",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            back: Card(
              color: Theme.of(context).primaryColor,
              child: Container(
                height: 200,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Spacer(),
                      Text(
                        Game.data.rentPayed ? "done" : action.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Game.data.rentPayed
                            ? Container()
                            : RaisedButton(
                                color: Colors.red,
                                child: Text(
                                  "execute",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Alert.handle(
                                      () => Game.executeEvent(action.func),
                                      context);
                                },
                              ),
                      )
                    ]),
              ),
            ),
          );
        }
        if (tile.type == TileType.chest) {
          CardAction action = findings[Game.data.findingsIndex];
          return FlipCard(
            front: MyCard(color: Theme.of(context).primaryColor, children: [
              Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.solidGem,
                      size: 50,
                      color: Colors.white,
                    ),
                    Container(height: 20),
                    Text(
                      "Findings card",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
            ]),
            back: MyCard(color: Theme.of(context).primaryColor, children: [
              Container(
                height: 200,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Spacer(),
                      Text(
                        Game.data.rentPayed ? "done" : action.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Game.data.rentPayed
                            ? Container()
                            : RaisedButton(
                                color: Colors.red,
                                child: Text(
                                  "execute",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Alert.handle(
                                      () => Game.executeEvent(action.func),
                                      context);
                                },
                              ),
                      )
                    ]),
              ),
            ]),
          );
        }
        return PropertyActionCardChild();
      },
    );
  }
}

class PropertyActionCardChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: "tile",
      children: <Widget>[buildRaisedButton(context)],
    );
  }

  Widget buildRaisedButton(BuildContext context) {
    Tile tile = Game.data.player.positionTile;
    Player owner = tile.owner;

    if (tile.type == TileType.parking) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        width: double.maxFinite,
        child: RaisedButton(
          padding: const EdgeInsets.all(8.0),
          color: Colors.green,
          child: Text(
            "Empty  £" + Game.data.pot.floor().toString(),
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          onPressed: () {
            Alert.handle(() => Game.act.clearPot(), context);
          },
        ),
      );
    }

    if (tile.type == TileType.tax) {
      if (Game.data.rentPayed) {
        return Container(
          height: 100,
          child: Center(
            child: Text("Rent payed"),
          ),
        );
      }
      int price = Game.data.player.positionTile.price;
      return Container(
        padding: const EdgeInsets.all(8.0),
        width: double.maxFinite,
        child: RaisedButton(
          padding: const EdgeInsets.all(8.0),
          color: Colors.red,
          child: Text(
            "Pay taxes £" + price.toString(),
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          onPressed: () {
            Alert.handle(() => Game.act.pay(payType.pot, price), context);
          },
        ),
      );
    }

    if (Game.data.player.positionTile.type == TileType.jail) {
      if (!Game.data.player.jailed)
        return Container(
          height: 100,
          child: Center(
            child: Text("Your visiting prison"),
          ),
        );
      return Container(
        padding: const EdgeInsets.all(8.0),
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RaisedButton(
              padding: const EdgeInsets.all(8.0),
              color: Colors.orange,
              child: Text(
                "Use prison card (" +
                    Game.data.player.goojCards.toString() +
                    ")",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onPressed: () {
                Alert.handle(() => Game.act.useGoojCard(), context);
              },
            ),
            Container(height: 10),
            RaisedButton(
              padding: const EdgeInsets.all(8.0),
              color: Colors.red,
              child: Text(
                "Bail out £50",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onPressed: () {
                Alert.handle(() => Game.act.buyOutJail(), context);
              },
            ),
          ],
        ),
      );
    }

    //Done TileTypes
    if (Game.data.player.positionTile.price == null) return Container();

    if (owner == null) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        width: double.maxFinite,
        child: RaisedButton(
          padding: const EdgeInsets.all(8.0),
          color: Colors.green,
          child: Text(
            "Buy £" + Game.data.player.positionTile.price.toString(),
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return MyTextField();
              },
            );
          },
        ),
      );
    }
    if (owner == Game.data.player) {
      if (((tile.rent?.length ?? 0) <= tile.level) ||
          (tile.type == TileType.trainstation) ||
          !Game.data.player.hasAll(tile.idPrefix)) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          width: double.maxFinite,
          height: 60,
          child: Center(child: Text("No actions")),
        );
      }
      return Container(
        padding: const EdgeInsets.all(8.0),
        width: double.maxFinite,
        child: RaisedButton(
          padding: const EdgeInsets.all(8.0),
          color: Colors.orange,
          child: Text(
            "Build house £" + tile.housePrice.toString(),
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          onPressed: () {
            Alert.handle(Game.build, context);
          },
        ),
      );
    }
    if (Game.data.rentPayed ?? false) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        width: double.maxFinite,
        height: 60,
        child: Center(child: Text("Rent payed")),
      );
    }
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: double.maxFinite,
      child: RaisedButton(
        padding: const EdgeInsets.all(8.0),
        color: Colors.red,
        child: Text(
          "Pay rent",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        onPressed: () {
          showDialog(context: context, builder: (_) => MyPayTextField());
        },
      ),
    );
  }
}

class MyTextField extends StatefulWidget {
  const MyTextField({
    Key key,
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool valid = true;
  int price;
  @override
  Widget build(BuildContext context) {
    Tile tile = Game.data.player.positionTile;
    return AlertDialog(
        title: Text("Buy ${tile.name}"),
        content: TextFormField(
          initialValue: tile.price.toString(),
          keyboardType:
              TextInputType.numberWithOptions(signed: false, decimal: false),
          decoration: InputDecoration(
            fillColor: Colors.red,
            hoverColor: Colors.red,
            hintText: tile.price.toString(),
            labelText: "Enter price",
            errorText: !valid ? "Please enter a natural number" : null,
          ),
          onChanged: (String val) {
            price = int.tryParse(val);
            if (price == null)
              valid = false;
            else
              valid = true;
            setState(() {});
          },
        ),
        actions: [
          MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "cancel",
                style: TextStyle(color: Theme.of(context).primaryColor),
              )),
          MaterialButton(
              onPressed: () {
                if (!valid) return;
                Alert.handleAndPop(() => Game.act.buy(price), context);
              },
              child: Text(
                "buy",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ))
        ]);
  }
}

class MyPayTextField extends StatefulWidget {
  const MyPayTextField({
    Key key,
  }) : super(key: key);

  @override
  _MyPayTextFieldState createState() => _MyPayTextFieldState();
}

class _MyPayTextFieldState extends State<MyPayTextField> {
  bool valid = true;
  int price;
  @override
  Widget build(BuildContext context) {
    Tile tile = Game.data.player.positionTile;
    return AlertDialog(
        title: Text("Pay rent for ${tile.name}"),
        content: TextFormField(
          initialValue: tile.currentRent.toString(),
          keyboardType:
              TextInputType.numberWithOptions(signed: false, decimal: false),
          decoration: InputDecoration(
            fillColor: Colors.red,
            hoverColor: Colors.red,
            hintText: tile.price.toString(),
            labelText: "Enter price",
            errorText: !valid ? "Please enter a natural number" : null,
          ),
          onChanged: (String val) {
            price = int.tryParse(val);
            if (price == null)
              valid = false;
            else
              valid = true;
            setState(() {});
          },
        ),
        actions: [
          MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "cancel",
                style: TextStyle(color: Theme.of(context).primaryColor),
              )),
          MaterialButton(
              onPressed: () {
                if (!valid) return;
                Alert.handleAndPop(
                    () => Game.act.payRent(tile.index, price), context);
              },
              child: Text(
                "pay",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ))
        ]);
  }
}
