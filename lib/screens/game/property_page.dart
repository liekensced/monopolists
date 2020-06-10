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
    if (!property.buyable) return Container();
    return Scaffold(
      appBar: AppBar(
        title: Text(studio ? property.name + " (studio)" : property.name),
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
            buildRentCard(),
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
            Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(studio ? "Tap on values to edit them" : ""),
            )),
            EndOfList(),
          ],
        );
      }),
    );
  }

  Widget buildRentCard() {
    if (property.rent == null) return Container();
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
                value: property.name,
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
                value: Color(property.color),
                onChanged: (dynamic val) {
                  property.color = val.value;
                  Game.save();
                })),
      ],
    );
  }
}
