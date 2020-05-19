import 'package:flutter/material.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/engine/data/map.dart';
import 'package:plutopoly/screens/carousel/map_carousel.dart';
import 'package:plutopoly/screens/game/action_screen/property_card.dart';
import 'package:plutopoly/widgets/end_of_list.dart';
import 'package:plutopoly/widgets/my_card.dart';

class PropertyPage extends StatelessWidget {
  final Tile property;

  const PropertyPage({Key key, @required this.property}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (!property.buyable) return Container();
    return Scaffold(
      appBar: AppBar(
        title: Text(property.name),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height / 2,
            child: Center(
              child: Container(
                child: buildCard(property),
                constraints: BoxConstraints(maxWidth: 250),
              ),
            ),
          ),
          MyCard(
            title: "info",
            smallTitle: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(property.description ?? "no info"),
              ),
            ],
          ),
          buildRentCard(),
          property.owner == UIBloc.gamePlayer
              ? PropertyCard(
                  tile: property,
                  expanded: true,
                )
              : Container(),
          EndOfList(),
        ],
      ),
    );
  }

  Widget buildRentCard() {
    if (property.rent == null) return Container();
    return MyCard(
      title: "Rent",
      children: [
        Center(
          child: Text("House Price: ${property.housePrice}"),
        ),
        for (int rent in property.rent)
          ListTile(
            title: Text(rent.toString()),
          )
      ],
    );
  }
}
