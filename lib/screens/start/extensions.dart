import 'package:flutter/material.dart';

import '../../engine/data/extensions.dart';
import '../../engine/extensions/bank/bank.dart';
import '../../engine/extensions/jurisdiction.dart';
import '../../engine/kernel/main.dart';
import '../../engine/ui/alert.dart';
import '../../widgets/my_card.dart';

class ExtensionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: "Extensions",
      children: <Widget>[
        ListTile(
          title: Text("Banking I"),
          leading: Bank.icon(),
          trailing: Wrap(
            children: <Widget>[
              Switch(
                value: Game.data.extensions.contains(Extension.bank),
                onChanged: (val) {
                  if (val) {
                    Alert.handle(Bank.onEnabled, context);
                    Game.data.extensions.add(Extension.bank);
                  } else
                    Game.data.extensions.remove(Extension.bank);
                  Game.save();
                },
              ),
              IconButton(
                icon: Icon(Icons.navigate_next),
                onPressed: () {},
              )
            ],
          ),
        ),
        Game.data.extensions.contains(Extension.bank)
            ? ListTile(
                title: Text("Banking 2"),
                leading: Container(
                  height: 30,
                  width: 30,
                ),
                trailing: Wrap(
                  children: <Widget>[
                    Switch(
                      value: Game.data.extensions.contains(Extension.bank2),
                      onChanged: (val) {
                        if (val)
                          Game.data.extensions.add(Extension.bank2);
                        else
                          Game.data.extensions.remove(Extension.bank2);
                        Game.save();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.navigate_next),
                      onPressed: () {},
                    )
                  ],
                ),
              )
            : Container(),
        Divider(),
        ListTile(
          title: Text("Jurisdiction I"),
          leading: Jurisdiction.icon(),
          trailing: Wrap(children: <Widget>[
            Switch(
              value: Game.data.extensions.contains(Extension.jurisdiction),
              onChanged: (val) {
                if (val)
                  Game.data.extensions.add(Extension.jurisdiction);
                else
                  Game.data.extensions.remove(Extension.jurisdiction);
                Game.save();
              },
            ),
            IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: () {},
            )
          ]),
        )
      ],
    );
  }
}
