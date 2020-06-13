import 'package:flutter/material.dart';

import '../../bloc/game_listener.dart';
import '../../bloc/main_bloc.dart';
import '../../bloc/ui_bloc.dart';
import '../../engine/data/map.dart';
import '../../engine/extensions/setting.dart';
import '../../engine/kernel/main.dart';
import '../../widgets/end_of_list.dart';
import '../../widgets/my_card.dart';
import '../../widgets/setting_tile.dart';
import '../carousel/map_carousel.dart';
import 'action_screen/property_card.dart';

class PropertyPage extends StatelessWidget {
  final Tile property;

  const PropertyPage({Key key, @required this.property}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool studio = MainBloc.studio;
    String type = property.type.toString().split(".").last;
    return Scaffold(
      appBar: AppBar(
        title: Text(studio
            ? (property.name ?? type) + " (studio)"
            : (property.name ?? type)),
      ),
      body: GameListener(builder: (context, _, snapshot) {
        return ListView(
          shrinkWrap: true,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height / 2,
              child: Center(
                child: Theme(
                  data: ThemeData.light(),
                  child: Container(
                    child: buildCard(property),
                    constraints: BoxConstraints(maxWidth: 250),
                  ),
                ),
              ),
            ),
            MyCard(
              title: "info",
              smallTitle: true,
              children: [
                InkWell(
                  onTap: studio
                      ? () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              String value = "";
                              return AlertDialog(
                                  title: Text("Change description"),
                                  content: TextField(
                                      autofocus: true,
                                      onChanged: (String val) {
                                        value = val;
                                      },
                                      decoration: InputDecoration(
                                          labelText: "tile description")),
                                  actions: [
                                    MaterialButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "cancel",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        )),
                                    MaterialButton(
                                        onPressed: () {
                                          property.description = value;

                                          Navigator.pop(context);
                                          Game.save();
                                        },
                                        child: Text(
                                          "change",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        )),
                                  ]);
                            },
                          );
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(property.description ?? "no info"),
                  ),
                ),
              ],
            ),
            buildRentCard(studio, context),
            studio
                ? EditCard(
                    property: property,
                  )
                : Container(),
            property.owner == UIBloc.gamePlayer || studio
                ? PropertyCard(
                    tile: property,
                    expanded: true,
                  )
                : Container(),
            MyCard(
              show: studio,
              title: "Preset values",
              children: [
                ValueSettingTile(
                    setting: ValueSetting<bool>(
                        allowNull: true,
                        title: "Mortaged",
                        value: property.mortaged,
                        onChanged: (dynamic val) {
                          property.mortaged = val;
                          Game.save();
                        })),
                ValueSettingTile(
                    setting: ValueSetting<int>(
                        allowNull: true,
                        title: "level",
                        subtitle: "The amount of houses",
                        value: property.level,
                        onChanged: (dynamic val) {
                          property.level = val;
                          Game.save();
                        })),
                ValueSettingTile(
                    setting: ValueSetting<int>(
                        allowNull: true,
                        title: "Transportation price",
                        subtitle:
                            "Amount other players have to pay to transport",
                        value: property.transportationPrice,
                        onChanged: (dynamic val) {
                          property.transportationPrice = val;
                          Game.save();
                        })),
              ],
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(studio ? "Tap on values to edit them" : ""),
            )),
            studio
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: Colors.red,
                      child: Text(
                        "Delete tile",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Game.data.gmap.remove(property);
                        Game.save();
                      },
                    ),
                  )
                : Container(width: 0),
            EndOfList(),
          ],
        );
      }),
    );
  }

  Widget buildRentCard(bool studio, context) {
    if (property.rent == null) return Container();
    if (studio)
      return MyCard(
        animate: false,
        title: "Rent (reordable)",
        children: [
          Container(
            height: property.rent.length * 60.0,
            child: ReorderableListView(
              children: [
                for (int rent in property.rent)
                  ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        property.rent.remove(rent);
                        Game.save();
                      },
                    ),
                    key: Key(rent.toString()),
                    title: Text(property.type == TileType.company
                        ? "x $rent"
                        : rent.toString()),
                  ),
              ],
              onReorder: (oldIndex, newIndex) {
                int cache = property.rent[oldIndex];
                property.rent.removeAt(oldIndex);
                if (newIndex > oldIndex) newIndex--;
                if (newIndex > Game.data.gmap.length - 1) {
                  property.rent.add(cache);
                } else {
                  property.rent.insert(newIndex, cache);
                }
                Game.save();
              },
            ),
          ),
          FlatButton(
            textColor: Theme.of(context).primaryColor,
            child: Text("Add rent"),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  String value = "";
                  return AlertDialog(
                      title: Text("Add rent"),
                      content: TextField(
                          onChanged: (String val) {
                            value = val;
                          },
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          decoration: InputDecoration(
                              hintText: property.rent.isEmpty
                                  ? ""
                                  : property.rent.last.toString())),
                      actions: [
                        MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "cancel",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            )),
                        MaterialButton(
                            onPressed: () {
                              int number = int.tryParse(value);
                              if (number != null) {
                                property.rent.add(number);
                                Game.save();
                              }
                              Navigator.pop(context);
                            },
                            child: Text(
                              "save",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            )),
                      ]);
                },
              );
            },
          )
        ],
      );
    return MyCard(
      title: "Rent",
      children: [
        Center(
          child: property.housePrice == null
              ? Container()
              : Text("House Price: ${property.housePrice}"),
        ),
        for (int rent in property.rent)
          ListTile(
            title: Text(property.type == TileType.company
                ? "x $rent"
                : rent.toString()),
          )
      ],
    );
  }
}

class EditCard extends StatelessWidget {
  final Tile property;

  const EditCard({Key key, @required this.property}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: "Edit settings",
      children: [
        ValueSettingTile(
            setting: ValueSetting<String>(
                title: "name",
                value: property.name ?? "none",
                onChanged: (dynamic val) {
                  property.name = val;
                  Game.save();
                })),
        ValueSettingTile(
            setting: ValueSetting<int>(
                title: "Property price",
                value: property.price,
                onChanged: (dynamic val) {
                  property.price = val;
                  Game.save();
                })),
        ValueSettingTile(
            setting: ValueSetting<int>(
                title: "House price",
                value: property.housePrice,
                onChanged: (dynamic val) {
                  property.housePrice = val;
                  Game.save();
                })),
        ValueSettingTile(
            setting: ValueSetting<String>(
                title: "Description",
                value: property.description,
                onChanged: (dynamic val) {
                  property.description = val;
                  Game.save();
                })),
        ValueSettingTile(
            setting: ValueSetting<int>(
                title: "Mortage",
                value: property.hyp,
                onChanged: (dynamic val) {
                  property.hyp = val;
                  Game.save();
                })),
        ValueSettingTile(
            setting: ValueSetting<Color>(
                title: "Color",
                subtitle: "The color of the top bar or icon.",
                value: property.color == null ? null : Color(property.color),
                onChanged: (dynamic val) {
                  property.color = val?.value;
                  Game.save();
                })),
        ValueSettingTile(
            setting: ValueSetting<Color>(
                allowNull: true,
                title: "Background color",
                value: property.backgroundColor == null
                    ? null
                    : Color(property.backgroundColor),
                onChanged: (dynamic val) {
                  property.backgroundColor = val?.value;
                  Game.save();
                })),
        ValueSettingTile(
            setting: ValueSetting<Color>(
                allowNull: true,
                title: "Table color",
                subtitle:
                    "Adds a color on the zoom map if not null. Can get busy very quickly!",
                value: property.tableColor == null
                    ? null
                    : Color(property.tableColor),
                onChanged: (dynamic val) {
                  property.tableColor = val?.value;
                  Game.save();
                })),
      ],
    );
  }
}
