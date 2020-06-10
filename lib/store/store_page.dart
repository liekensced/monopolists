import 'package:flutter/material.dart';

import '../screens/store/store_list.dart';
import '../widgets/my_card.dart';
import 'start_preset.dart';

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
        Container(
          height: 50,
        ),
        StudioCard(),
      ],
    );
  }
}

class StudioCard extends StatelessWidget {
  const StudioCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: "studio",
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Create (or edit) your own unique maps!",
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Container(
          height: 80,
          child: Center(
            child: Text("No open projects."),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            child: Text("Start new project"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return StartPresetScreen();
              }));
            },
          ),
        ),
      ],
    );
  }
}
