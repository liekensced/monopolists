import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../engine/data/extensions.dart';
import '../../engine/extensions/bank/bank.dart';
import '../../engine/extensions/jurisdiction.dart';
import '../../engine/kernel/main.dart';
import '../../widgets/my_card.dart';

class ExtensionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: "Extensions",
      children: <Widget>[
        ExtensionTile(
          title: "Banking I",
          icon: Bank.icon(),
          ext: Extension.bank,
        ),
        Game.data.extensions.contains(Extension.bank)
            ? ExtensionTile(
                title: "World stock",
                icon: FaIcon(FontAwesomeIcons.chartLine),
                ext: Extension.stock)
            : Container(),
        Divider(),
        ExtensionTile(
            title: "Jurisdiction I",
            icon: Jurisdiction.icon(),
            ext: Extension.jurisdiction),
      ],
    );
  }
}

class ExtensionTile extends StatelessWidget {
  final String title;
  final Extension ext;
  final Widget icon;

  const ExtensionTile(
      {Key key, @required this.title, @required this.ext, @required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: icon,
      trailing: Wrap(children: <Widget>[
        Switch(
          value: Game.data.extensions.contains(ext),
          onChanged: (val) {
            if (Game.data.running == true) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: Text("Game is running"),
                      content: Text(
                          "You can't change extensions while the game is running."),
                      actions: [
                        MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "close",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ))
                      ]);
                },
              );
            } else {
              if (val)
                Game.data.extensions.add(ext);
              else
                Game.data.extensions.remove(ext);
              Game.save();
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.navigate_next),
          onPressed: () {},
        )
      ]),
    );
  }
}
