import 'package:flutter/material.dart';
import 'package:plutopoly/engine/data/extensions.dart';
import 'package:plutopoly/engine/extensions/bank/bank.dart';
import 'package:plutopoly/engine/extensions/jurisdiction.dart';
import 'package:plutopoly/screens/start/info_screen.dart';
import 'package:plutopoly/widgets/end_of_list.dart';
import 'package:plutopoly/widgets/my_card.dart';

class ExtensionScreen extends StatelessWidget {
  final String name;
  final Widget icon;
  final Extension extensionName;

  const ExtensionScreen(
      {Key key,
      @required this.name,
      @required this.extensionName,
      @required this.icon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(extensionName.toString()),
      ),
      body: ListView(
        children: [
          MyCard(
            title: name,
            children: [Text(getDescription())],
          ),
          IconDivider(icon: icon),
          getInfoList(),
          EndOfList()
        ],
      ),
    );
  }

  String getDescription() {
    switch (extensionName) {
      case Extension.bank:
        return "";
        break;
      case Extension.bank2:
        return "";

        break;
      case Extension.jurisdiction:
        return "";

        break;
      case Extension.stock:
        return "";
        break;
    }
    return "no info";
  }

  getInfoList() {
    switch (extensionName) {
      case Extension.bank:
        Bank.getInfo();
        break;
      case Extension.bank2:
        Bank.getInfo();
        break;
      case Extension.jurisdiction:
        Jurisdiction.getInfo();
        break;
      case Extension.stock:
        Bank.getInfo();
        break;
    }
  }
}
