import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:plutopoly/bloc/game_listener.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/engine/data/extensions.dart';
import 'package:plutopoly/engine/extensions/extension_data.dart';
import 'package:plutopoly/engine/extensions/setting.dart';
import 'package:plutopoly/screens/start/info_screen.dart';
import 'package:plutopoly/widgets/end_of_list.dart';
import 'package:plutopoly/widgets/my_card.dart';
import 'package:plutopoly/widgets/setting_tile.dart';

class ExtensionScreen extends StatelessWidget {
  final Extension ext;
  final ExtensionData data;

  const ExtensionScreen({
    Key key,
    @required this.ext,
    this.data,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ExtensionData extensionData = data ?? ExtensionsMap.call()[ext];
    return Scaffold(
      appBar: AppBar(
        title: Text(extensionData.name),
      ),
      body: ListView(
        children: [
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: UIBloc.maxWidth),
              child: Card(
                child: Row(
                  children: [
                    Expanded(
                        child: Center(child: extensionData.icon(size: 50))),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              extensionData.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(color: Colors.white),
                              textAlign: TextAlign.start,
                            ),
                            Container(height: 4),
                            Text(extensionData.description)
                          ],
                        ),
                      ),
                      flex: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
          buildSettings(extensionData),
          IconDivider(icon: extensionData.icon()),
          GameListener(builder: (_, __, ___) => getInfo(extensionData)),
          IconDivider(
              icon: Icon(
            Icons.info,
            size: 30,
          )),
          buildDependant(extensionData, context),
          buildDependencies(extensionData, context),
          EndOfList()
        ],
      ),
    );
  }

  Widget buildDependant(ExtensionData extensionData, BuildContext context) {
    List<Widget> children = [];
    ExtensionsMap.call().forEach((key, ExtensionData ext) {
      if (ext.dependencies.contains(extensionData.ext)) {
        children.add(ExtensionInfoTile(
          ext: ext,
          extensionName: key,
        ));
        children.add(Divider());
      }
    });
    if (children.isEmpty) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
          child: Text("No dependents"),
        ),
      );
    } else {
      children.removeLast();
    }
    return MyCard(
      title: "Dependents:",
      smallTitle: true,
      children: children,
    );
  }

  Widget buildDependencies(ExtensionData extensionData, BuildContext context) {
    List<Widget> children = [];
    extensionData.dependencies.forEach((key) {
      children.add(ExtensionInfoTile(
        extensionName: key,
        ext: ExtensionsMap.call()[key],
      ));
      children.add(Divider());
    });
    if (children.isEmpty) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
          child: Text("No dependencies"),
        ),
      );
    } else {
      children.removeLast();
    }
    return MyCard(
      title: "Requires:",
      smallTitle: true,
      children: children,
    );
  }

  Widget getInfo(ExtensionData extensionData) {
    List<Widget> out = [];
    extensionData.getInfo().forEach((info) {
      out.add(GeneralInfoCard(info: info));
    });
    return Column(children: out);
  }

  buildSettings(ExtensionData extensionData) {
    if (extensionData.settings?.isEmpty ?? true) {
      return Container();
    }
    return MyCard(
      title: "Settings",
      children: [
        for (Setting setting in extensionData.settings)
          SettingTile(
            setting: setting,
            ext: extensionData.ext,
          ),
        Container(height: 10),
      ],
    );
  }
}

class ExtensionInfoTile extends StatelessWidget {
  final Extension extensionName;
  final ExtensionData ext;
  const ExtensionInfoTile({
    Key key,
    this.extensionName,
    @required this.ext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Extension key = extensionName ?? ext.ext;
    return OpenContainer(
      closedColor: Theme.of(context).cardColor,
      openColor: Theme.of(context).backgroundColor,
      closedBuilder: (_, __) => ListTile(
        leading: ext.icon(),
        title: Text(
          ext.name,
        ),
        subtitle: Text(ext.description),
        trailing: Icon(Icons.navigate_next),
      ),
      openBuilder: (BuildContext context, void Function() action) {
        return ExtensionScreen(ext: key);
      },
    );
  }
}
