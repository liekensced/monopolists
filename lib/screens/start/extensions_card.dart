import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plutopoly/engine/extensions/extension_data.dart';
import 'package:plutopoly/engine/ui/alert.dart';
import 'package:plutopoly/screens/extension_screen.dart';

import '../../engine/data/extensions.dart';
import '../../engine/kernel/main.dart';
import '../../widgets/my_card.dart';

class ExtensionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    ExtensionsMap.call().forEach((ext, ExtensionData extensionData) {
      for (Extension dep in extensionData.dependencies) {
        if (!Game.data.extensions.contains(dep)) return;
      }

      children.add(ExtensionTile(
        title: extensionData.name,
        icon: extensionData.icon(),
        ext: ext,
      ));
    });
    return MyCard(
      title: "Extensions",
      children: children,
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
    return OpenContainer(
        closedColor: Theme.of(context).cardColor,
        openColor: Theme.of(context).backgroundColor,
        openBuilder: (_, __) {
          return ExtensionScreen(ext: ext);
        },
        closedBuilder: (_, f) => closedBuilder(context, f));
  }

  closedBuilder(BuildContext context, f) => ListTile(
        title: Text(title),
        leading: icon,
        trailing: Wrap(children: <Widget>[
          Switch(
            value: Game.data.extensions.contains(ext),
            onChanged: (Game.data.running == true &&
                    !ExtensionsMap.call()[ext].hotAdd)
                ? null
                : (val) {
                    if (Game.data.running == true &&
                        !ExtensionsMap.call()[ext].hotAdd) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              title: Text("Game is running"),
                              content: Text(
                                  "You can't change this extensions while the game is running."),
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
                                    ))
                              ]);
                        },
                      );
                    } else {
                      ExtensionData extensionData = ExtensionsMap.call()[ext];
                      if (val) {
                        if (Alert.handle(extensionData.onAdded, context)) {
                          Game.data.extensions.add(ext);
                        }
                      } else {
                        ExtensionsMap.call()
                            .forEach((key, ExtensionData dependant) {
                          if (dependant.dependencies.contains(ext) &&
                              Game.data.extensions.contains(key)) {
                            Game.data.extensions.remove(key);
                          }
                        });
                        Game.data.extensions.remove(ext);
                      }
                      Game.save();
                    }
                  },
          ),
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              f();
            },
          )
        ]),
      );
}
