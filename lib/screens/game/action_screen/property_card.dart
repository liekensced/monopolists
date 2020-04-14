import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../engine/data/map.dart';
import '../../../engine/kernel/main.dart';
import '../../../engine/ui/alert.dart';
import '../../../widgets/houses.dart';
import '../../../widgets/my_card.dart';

class PropertyCard extends StatefulWidget {
  final Tile tile;
  const PropertyCard({
    @required this.tile,
    Key key,
  }) : super(key: key);

  @override
  _PropertyCardState createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard>
    with SingleTickerProviderStateMixin {
  Tile get tile => widget.tile;

  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    Color color = Colors.white;
    Widget leading = Container(width: 0);
    Color textColor = Colors.black;
    Widget content = Container(height: 200);

    if (tile.type == TileType.land) {
      bool _hasAll = Game.data.player.hasAll(tile.idPrefix);
      color = Color(tile.color);
      textColor = Colors.white;
      content = Column(
        children: !expanded
            ? []
            : [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Houses(amount: tile.level),
                        ),
                      ),
                      Expanded(
                          child:
                              Center(child: Text("£" + tile.price.toString()))),
                    ],
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
      content = expanded
          ? Container(
              height: 200,
              child: Center(
                child: leading,
              ))
          : Container();
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
          child: Container(height: expanded ? 200 : 0, child: content),
        )
      ],
    );
  }
}
