import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../engine/data/map.dart';
import '../../../engine/kernel/main.dart';
import '../../../engine/ui/alert.dart';
import '../../../widgets/houses.dart';
import '../../../widgets/my_card.dart';

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
    if (expanded == null) expanded = widget.expanded;
    Color color = Colors.white;
    Widget leading = Container(width: 0);
    Color textColor = Colors.black;
    Widget content = Container(height: 200);

    if (tile.type == TileType.land) {
      bool _hasAll = Game.data.player.hasAll(tile.idPrefix);
      color = Color(tile.color);
      textColor = Colors.white;
      if (tile.mortaged ?? false)
        leading = Icon(Icons.turned_in, color: Colors.white);
      content = Column(
        children: !expanded
            ? []
            : [
                Expanded(
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
                          child: Center(
                              child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Value: £" + tile.price.toString()),
                          tile.mortaged
                              ? Center(
                                  child: Text(
                                  "mortaged",
                                  style: TextStyle(color: Colors.grey),
                                ))
                              : Container()
                        ],
                      ))),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.all(8.0),
                    width: double.maxFinite,
                    child: Tooltip(
                      message: tile.mortaged ? "Buy back" : "Mortage",
                      child: RaisedButton(
                        color: Colors.orange,
                        child: Container(
                          width: double.maxFinite,
                          child: Center(
                            child: Text(
                              (tile.mortaged
                                  ? "Buy back for £" +
                                      (tile.hyp * 1.1).floor().toString()
                                  : "Mortage for  £" + tile.hyp.toString()),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Alert.handle(
                              () => Game.act.mortage(tile.index), context);
                        },
                      ),
                    ),
                  ),
                ),
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
                                Alert.handle(() => Game.build(tile), context);
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
      );
    }

    if (tile.type == TileType.company) {
      color = Colors.white;
      textColor = Colors.black;
      leading = (tile.idIndex == 1)
          ? FaIcon(FontAwesomeIcons.bolt, color: Colors.orange)
          : FaIcon(FontAwesomeIcons.faucet, color: Colors.blue);
      content = Container(
          height: 200,
          child: Center(
            child: leading,
          ));
    }

    if (tile.type == TileType.trainstation) {
      color = Colors.white;
      textColor = Colors.black;
      leading = Icon(Icons.train);
      content = Container(
          height: 200,
          child: Center(
            child: leading,
          ));
    }

    return MyCard(
      children: <Widget>[
        Container(
          color: color,
          child: InkWell(
            onTap: () {
              expanded = !expanded;
              setState(() {});
            },
            child: ListTile(
              leading: leading,
              title: Text(
                widget.tile.name,
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: Icon(
                  expanded ? Icons.expand_less : Icons.expand_more,
                  color: textColor,
                ),
                onPressed: () {
                  expanded = !expanded;
                  setState(() {});
                },
              ),
            ),
          ),
        ),
        AnimatedSize(
          vsync: this,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          child: Container(
              height: expanded ? 200 : 0,
              child: expanded ? content : Container()),
        )
      ],
    );
  }
}
