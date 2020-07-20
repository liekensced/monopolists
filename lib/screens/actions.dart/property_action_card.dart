import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plutopoly/engine/commands/parser.dart';
import 'package:plutopoly/engine/data/game_action.dart';

import '../../bloc/game_listener.dart';
import '../../engine/data/actions.dart';
import '../../engine/data/map.dart';
import '../../engine/data/player.dart';
import '../../engine/kernel/../ui/alert.dart';
import '../../engine/kernel/core_actions.dart';
import '../../engine/kernel/main.dart';
import '../../helpers/icon_helper.dart';
import '../../helpers/money_helper.dart';
import '../../widgets/my_card.dart';
import '../game/action_screen/property_card.dart';

class PropertyActionCard extends StatelessWidget {
  const PropertyActionCard({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GameListener(
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
                    Container(
                      height: 100,
                      width: 100,
                      child: GameIcon(
                        "question",
                        color: Colors.white.value,
                      ),
                    ),
                    Container(height: 20),
                    Text(
                      (tile.description ?? "No info") == "No info"
                          ? "Event card"
                          : tile.description,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Game.data.rentPayed ? "done" : action.text,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
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
                    Container(
                      height: 100,
                      width: 100,
                      child: GameIcon(
                        "gem",
                        color: Colors.white.value,
                      ),
                    ),
                    Container(height: 20),
                    Text(
                      (tile.description ?? "No info") == "No info"
                          ? "Findings card"
                          : tile.description,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Game.data.rentPayed ? "done" : action.text,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
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
        if (tile.type == TileType.action) {
          return MyCard(
            title: tile.actions.isEmpty ? "You are idle" : "Action tile",
            action: Tooltip(
              message: getMessage(tile),
              child: Icon(Icons.info),
            ),
            children: [
              if (tile.description != null)
                Center(
                  child: Padding(
                      padding: const EdgeInsets.all(12.0).copyWith(top: 0),
                      child: Text(tile.description)),
                ),
              for (GameAction action in tile.actions)
                RaisedButton(
                  padding: const EdgeInsets.all(8),
                  color: Color(
                      action.color ?? Theme.of(context).primaryColor.value),
                  child: Text(
                    action.title,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: Game.data.rentPayed && (tile.onlyOneAction ?? true)
                      ? null
                      : () {
                          Alert.handle(
                            () => CommandParser.parse(
                              action.command,
                              false,
                              true,
                            ),
                            context,
                          );
                        },
                )
            ],
          );
        }
        if (tile.owner == Game.data.player) {
          return PropertyCard(tile: tile, expanded: true);
        }
        return PropertyActionCardChild();
      },
    );
  }

  getMessage(Tile tile) {
    String msg = "";
    if (tile.onlyOneAction) {
      msg += "You can only do 1 action.";
    } else {
      msg += "You can do multiple actions.";
    }
    if (tile.actionRequired) {
      msg += "\nYou need to do at least 1 action.";
    } else {
      msg += "\nNo action is required.";
    }
    return msg;
  }
}

class PropertyActionCardChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: "Tile",
      children: <Widget>[buildRaisedButton(context)],
    );
  }

  Widget buildRaisedButton(BuildContext context) {
    Tile tile = Game.data.player.positionTile;
    Player owner = tile.owner;

    if (tile.type == TileType.start) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Padding(
                  padding: const EdgeInsets.all(12.0).copyWith(top: 0),
                  child:
                      Text(tile.description ?? "You are on the start tile.")),
            ),
            (Game.data.settings.doubleBonus ?? false)
                ? RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.green,
                    child: Text(
                      "Receive double go bonus ${mon(Game.data.settings.goBonus)}!",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    onPressed:
                        Game.data.rentPayed ? null : Game.act.doubleGoBonus,
                  )
                : Container(),
          ],
        ),
      );
    }

    if (tile.type == TileType.parking) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Padding(
                  padding: const EdgeInsets.all(12.0).copyWith(top: 0),
                  child: Text(tile.description ??
                      "Congrats! You can empty the pot and enjoy your coffee break.")),
            ),
            RaisedButton(
              padding: const EdgeInsets.all(8.0),
              color: Colors.green,
              child: Text(
                "Empty  ${mon(Game.data.pot)}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onPressed: () {
                Alert.handle(() => Game.act.clearPot(), context);
              },
            ),
          ],
        ),
      );
    }

    if (tile.type == TileType.tax) {
      if (Game.data.rentPayed) {
        return Container(
          height: 100,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (tile.description != null) Text(tile.description),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(tile.price > 0 ? "Rent payed" : "Received"),
                ),
              ],
            ),
          ),
        );
      }
      int price = Game.data.player.positionTile.price;
      return Container(
        padding: const EdgeInsets.all(8.0),
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Padding(
                  padding: const EdgeInsets.all(12.0).copyWith(top: 0),
                  child:
                      Text(tile.description ?? "You have to pay your taxes.")),
            ),
            RaisedButton(
              padding: const EdgeInsets.all(8.0),
              color: price > 0 ? Colors.red : Colors.green,
              child: Text(
                (price > 0
                    ? "Pay taxes ${mon(price.abs())}"
                    : "You receive ${mon(price.abs())}"),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onPressed: () {
                Alert.handle(() => Game.act.pay(PayType.pot, price), context);
              },
            ),
          ],
        ),
      );
    }

    if (Game.data.player.positionTile.type == TileType.jail) {
      if (!Game.data.player.jailed)
        return Container(
          height: 100,
          child: Center(
            child: Text(tile.description ?? "Your visiting prison"),
          ),
        );
      return Container(
        padding: const EdgeInsets.all(8.0),
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Padding(
                  padding: const EdgeInsets.all(12.0).copyWith(top: 0),
                  child: Text(tile.description ?? "You are in prison")),
            ),
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
                "Bail out ${mon(50)}",
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

    if (tile.type == TileType.police) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        width: double.maxFinite,
        child: RaisedButton(
          padding: const EdgeInsets.all(8.0),
          color: Colors.blue[900],
          child: Text(
            "Go to jail",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          onPressed: () {
            Game.helper.jail(Game.data.player, shouldSave: true);
          },
        ),
      );
    }

    //Done TileTypes
    if (tile.price == null) return Container();

    if (owner == null) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Padding(
                  padding: const EdgeInsets.all(12.0).copyWith(top: 0),
                  child: Text(tile.description ?? "This property is for sale")),
            ),
            RaisedButton(
              padding: const EdgeInsets.all(8.0),
              color: Colors.green,
              child: Text(
                "Buy ${mon(Game.data.player.positionTile.price)}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onPressed: () {
                if (!(Game.data.settings.allowPriceChanges ?? false)) {
                  Alert.handle(
                      () =>
                          Game.act.buy() ??
                          Alert(
                              "Bought succesfully",
                              "You bought " +
                                  Game.data.player.positionTile.name +
                                  ".",
                              type: DialogType.SUCCES),
                      context);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return MyTextField();
                    },
                  );
                }
              },
            ),
          ],
        ),
      );
    }

    if (Game.data.rentPayed ?? false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          tile.description == null
              ? Container(width: 0)
              : Center(
                  child: Padding(
                      padding: const EdgeInsets.all(12.0).copyWith(top: 0),
                      child: Text(tile.description)),
                ),
          Container(
            padding: const EdgeInsets.all(8.0),
            width: double.maxFinite,
            height: 60,
            child: Center(child: Text("Rent payed")),
          ),
        ],
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
          readOnly: !(Game.data.settings.allowPriceChanges ?? false),
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
          readOnly: !(Game.data.settings.allowPriceChanges ?? false),
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
                    () => Game.act.payRent(tile.mapIndex, price), context);
              },
              child: Text(
                "pay",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ))
        ]);
  }
}
