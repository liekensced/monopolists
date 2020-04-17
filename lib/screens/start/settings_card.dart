import 'package:flutter/material.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/kernel/main.dart';
import '../../widgets/my_card.dart';

class SettingsCard extends StatefulWidget {
  @override
  _SettingsCardState createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard>
    with SingleTickerProviderStateMixin {
  bool showAdvanced = false;
  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: "Settings:",
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
                hintText: "Game " + MainBloc.getGameNumber.toString(),
                labelText: "Game name"),
            onChanged: (val) => Game.data.settings.name = val,
          ),
        ),
        Divider(),
        ListTile(
          title: Text("Remotely build"),
          subtitle: Text(
              "You don't have to stand on the property to build something"),
          trailing: Switch(
            value: Game.data.settings.remotelyBuild,
            onChanged: (val) {
              Game.data.settings.remotelyBuild = val;
              Game.save();
            },
          ),
        ),
        Divider(),
        ListTile(
          title: Text("Mandatory auction"),
          subtitle:
              Text("If you don't buy the property, it must be auctioned."),
          trailing: Switch(
            value: Game.data.settings.mustAuction,
            onChanged: (val) {
              Game.data.settings.mustAuction = val;
              Game.save();
            },
          ),
        ),
        AnimatedSize(
          duration: Duration(milliseconds: 500),
          curve: Curves.decelerate,
          vsync: this,
          child: !showAdvanced ? Container() : AdvancedSettings(),
        ),
        MaterialButton(
          onPressed: () {
            setState(() {
              showAdvanced = !showAdvanced;
            });
          },
          child: Text(
            showAdvanced ? "Close advanced" : "Open advanced",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        Container(height: 8)
      ],
    );
  }
}

class AdvancedSettings extends StatelessWidget {
  const AdvancedSettings({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(),
        ListTile(
          title: Text("Go bonus"),
          subtitle: Text("Amount you get for passing go: " +
              Game.data.settings.goBonus.toString()),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              String amount;
              showDialog(
                context: context,
                builder: (context) {
                  submit(_) {
                    Game.data.settings.goBonus = int.tryParse(amount) ?? 200;
                    Game.save();
                    Navigator.pop(context);
                  }

                  return AlertDialog(
                      title: Text("Edit go bonus"),
                      content: TextField(
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "Enter amount "),
                        onChanged: (val) => amount = val,
                        onSubmitted: submit,
                      ),
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
                              submit("");
                            },
                            child: Text(
                              "change",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            )),
                      ]);
                },
              );
            },
          ),
        ),
        Divider(),
        ListTile(
          title: Text("Max Turnes"),
          subtitle: Text(Game.data.settings.maxTurnes.toString()),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              String amount;
              showDialog(
                context: context,
                builder: (context) {
                  submit(_) {
                    Game.data.settings.maxTurnes = int.tryParse(amount) ?? 200;
                    Game.save();
                    Navigator.pop(context);
                  }

                  return AlertDialog(
                      title: Text("Edit max turnes"),
                      content: TextField(
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "Enter amount "),
                        onChanged: (val) => amount = val,
                        onSubmitted: submit,
                      ),
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
                              submit("_");
                            },
                            child: Text(
                              "change",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            )),
                      ]);
                },
              );
            },
          ),
        ),
        Divider(),
        ListTile(
          title: Text("Starting money"),
          subtitle: Text(Game.data.settings.goBonus.toString()),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              String amount;
              showDialog(
                context: context,
                builder: (context) {
                  submit(_) {
                    Game.data.settings.startingMoney =
                        int.tryParse(amount) ?? 1500;
                    Game.save();
                    Navigator.pop(context);
                  }

                  return AlertDialog(
                      title: Text("Edit starting money"),
                      content: TextField(
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "Enter amount "),
                        onChanged: (val) => amount = val,
                        onSubmitted: submit,
                      ),
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
                              submit("");
                            },
                            child: Text(
                              "change",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            )),
                      ]);
                },
              );
            },
          ),
        ),
        Divider(),
        ListTile(
          title: Text("Hacker screen"),
          subtitle: Text("Allow players to see the hacker screen."),
          trailing: Switch(
            value: Game.data.settings.hackerScreen,
            onChanged: (val) {
              Game.data.settings.hackerScreen = val;
              Game.save();
            },
          ),
        ),
      ],
    );
  }
}
