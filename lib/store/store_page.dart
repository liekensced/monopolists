import 'package:flutter/material.dart';
import 'package:plutopoly/screens/start/extensions_card.dart';
import 'package:plutopoly/screens/store/store_list.dart';

class StorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            "Maps",
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.start,
          ),
        ),
        StoreList(),
        Container(height: 10),
        ExtensionsCard(
          info: true,
        )
      ],
    );
  }
}
