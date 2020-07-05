import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../bloc/main_bloc.dart';
import '../../../bloc/ui_bloc.dart';
import '../../../engine/data/map.dart';
import '../../../engine/extensions/transportation.dart';
import '../../../engine/kernel/main.dart';
import '../../../engine/ui/alert.dart';
import '../../../helpers/sure_helper.dart';
import '../../../widgets/houses.dart';
import '../../../widgets/my_card.dart';
import '../property_page.dart';

class PropertyCard extends StatefulWidget {
  final Tile tile;
  final bool expanded;
  const PropertyCard({
    @required this.tile,
    Key key,
    this.expanded: false,
  }) : super(key: key);

  @override
  _PropertyCardState createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard>
    with SingleTickerProviderStateMixin {
  Tile get tile => widget.tile;

  bool expanded;

  @override
  Widget build(BuildContext context) {
    if (expanded == null) {
      expanded = widget.expanded;
    }
    Color color = Colors.white;
    Widget leading = Container(width: 0);
    Color textColor = Colors.black;
    Widget content = Container(height: 200);
    if (tile.mortaged ?? false)
      leading = Icon(Icons.turned_in, color: Colors.white);

    if (tile.type == TileType.land) {
      bool _hasAll = UIBloc.gamePlayer.hasAllUnmortaged(tile.idPrefix);
      color = Color(tile.color ?? Theme.of(context).primaryColor.value);
      textColor = Colors.white;

      content = Container(
        height: 200,
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return PropertyPage(
                property: tile,
              );
            }));
          },
          child: Column(
            children: !expanded
                ? []
                : [
                    TileInfo(tile: tile),
                    MortageButton(tile: tile),
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.all(8.0),
                        width: double.maxFinite,
                        child: Tooltip(
                          message: _hasAll
                              ? "Build a house"
                              : "You need all properties of this color.",
                          child: RaisedButton(
                            color: Colors.orange,
                            child: Container(
                              width: double.maxFinite,
                              child: Center(
                                child: Text(
                                  "Build house £" + tile.housePrice.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            onPressed: _hasAll
                                ? () {
                                    sure(
                                      context,
                                      Game.data.rentPayed ||
                                          Game.data.player.money < 300,
                                      "Are you sure you want to build a house",
                                      () => Alert.handle(
                                          () => Game.build(tile), context),
                                    );
                                  }
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ],
          ),
        ),
      );
    }

    if (tile.type == TileType.company) {
      color = Colors.white;
      textColor = Colors.black;
      leading = (tile.icon == "bolt")
          ? FaIcon(FontAwesomeIcons.bolt, color: Colors.orange)
          : FaIcon(FontAwesomeIcons.faucet, color: Colors.blue);
      content = InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return PropertyPage(
              property: tile,
            );
          }));
        },
        child: Container(
            height: 200,
            child: Column(
              children: [
                TileInfo(tile: tile),
                Expanded(
                  flex: 2,
                  child: leading,
                ),
                MortageButton(
                  tile: tile,
                )
              ],
            )),
      );
    }

    if (tile.type == TileType.trainstation) {
      color = Colors.white;
      textColor = Colors.black;
      leading = Icon(
        Icons.train,
        color: Colors.black,
      );
      if (TransportationBloc.active) {
        Widget message;

        if ((tile.owner.trainstations ?? 0) == 0) {
          message = Container(
              height: 100,
              child: Center(child: Text("Get more transations to move.")));
        }
        content = InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return PropertyPage(
                property: tile,
              );
            }));
          },
          child: Container(
              height: 200,
              child: Column(
                children: [
                  TileInfo(
                    tile: tile,
                  ),
                  MortageButton(
                    tile: tile,
                  ),
                  message == null
                      ? Container(width: 0)
                      : Expanded(
                          child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: message,
                        )),
                  ListTile(
                    title: Text("Price to move"),
                    subtitle: Text(
                        "How much other players have to pay to move from this station."),
                    trailing: RaisedButton.icon(
                      color: Theme.of(context).primaryColor,
                      icon: Text(
                          '£' + (tile.transportationPrice ?? 0).toString()),
                      label: Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            String text = "";
                            return AlertDialog(
                                title: Text("Change price"),
                                content: TextField(
                                  autofocus: true,
                                  onChanged: (val) {
                                    text = val;
                                  },
                                ),
                                actions: [
                                  MaterialButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "close",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      )),
                                  MaterialButton(
                                      onPressed: () {
                                        int price = int.tryParse(text);
                                        tile.transportationPrice = price;
                                        Game.save(
                                            only: [SaveData.gmap.toString()]);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "change",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      )),
                                ]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              )),
        );
      } else {
        content = InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return PropertyPage(
                property: tile,
              );
            }));
          },
          child: Container(
              height: 200,
              child: Column(
                children: [
                  TileInfo(
                    tile: tile,
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Icon(
                        Icons.train,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  MortageButton(
                    tile: tile,
                  )
                ],
              )),
        );
      }
    }

    return MyCard(
      children: <Widget>[
        Container(
          color: color,
          child: InkWell(
            onTap: () {
              if (widget.tile.owner != UIBloc.gamePlayer) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return PropertyPage(property: tile);
                }));
              } else {
                expanded = !expanded;
                setState(() {});
              }
            },
            child: ListTile(
              leading: leading,
              title: Text(
                widget.tile.name ?? "",
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "${tile.mortaged ? 'Mortaged ' : ''} £${tile.price ?? 0}, £${tile.hyp ?? 0}, -£${tile.currentRent ?? 0}",
                style: TextStyle(
                  color: textColor,
                ),
              ),
              trailing: Icon(
                expanded ? Icons.expand_less : Icons.expand_more,
                color: textColor,
              ),
            ),
          ),
        ),
        AnimatedSize(
          vsync: this,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          child: expanded
              ? Container(
                  constraints: BoxConstraints(minHeight: 200), child: content)
              : Container(),
        )
      ],
    );
  }
}

class TileInfo extends StatelessWidget {
  const TileInfo({
    Key key,
    @required this.tile,
  }) : super(key: key);

  final Tile tile;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          tile.level > 0
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Houses(amount: tile.level),
                  ),
                )
              : Container(),
          Expanded(
              child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        String name = tile.name;
                        return AlertDialog(
                            title: Text("Edit name"),
                            content: TextField(
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Enter name",
                              ),
                              onChanged: (String val) {
                                name = val;
                              },
                            ),
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
                                    tile.name = name;
                                    Game.save(only: [SaveData.gmap.toString()]);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "save",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ))
                            ]);
                      },
                    );
                  },
                ),
              ),
              Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "Value: £" +
                            tile.price.toString() +
                            "\nRent: " +
                            tile.currentRent.toString(),
                        textAlign: TextAlign.center),
                  ),
                  tile.mortaged
                      ? Center(
                          child: Text(
                          "mortaged",
                          style: TextStyle(color: Colors.grey),
                        ))
                      : Container()
                ],
              )),
            ],
          )),
        ],
      ),
    );
  }
}

class MortageButton extends StatelessWidget {
  const MortageButton({
    Key key,
    @required this.tile,
  }) : super(key: key);

  final Tile tile;

  @override
  Widget build(BuildContext context) {
    if (tile.hyp == null) {
      return Container(
        width: 0,
      );
    }
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.all(8.0),
        width: double.maxFinite,
        child: Tooltip(
          message: tile.mortaged ? "Buy back" : "Mortage",
          child: Align(
            alignment: Alignment.centerRight,
            child: FlatButton(
              child: Text(
                (tile.mortaged
                    ? "Buy back for £" + (tile.hyp * 1.1).floor().toString()
                    : "Mortage for  £" + tile.hyp.toString()),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange),
              ),
              onPressed: () {
                sure(
                    context,
                    Game.data.player.money > 400,
                    "Are you sure you want to mortage this property?",
                    () => Alert.handle(
                          () => Game.act.mortage(tile.id),
                          context,
                        ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
