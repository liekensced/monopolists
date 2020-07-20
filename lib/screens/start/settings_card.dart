import 'package:flutter/material.dart';
import 'package:plutopoly/screens/store/rewards_list.dart';

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
      animate: false,
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
              Game.save(only: [SaveData.settings.toString()]);
            },
          ),
        ),
        Divider(),
        ListTile(
          title: Text("Currency"),
          subtitle: Text("The currency used in the game"),
          trailing: IconButton(
            icon: Text(
              Game.data.currency ?? "£",
              style: TextStyle(fontSize: 25, color: Colors.orangeAccent),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return CurrencyScreen(
                  selector: true,
                );
              }));
            },
          ),
        ),
        Divider(),
        ListTile(
          title: Text("Starting money"),
          subtitle: Text(Game.data.settings.startingMoney.toString()),
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
                    Game.save(only: [SaveData.settings.toString()]);
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
          title: Text("Get assets when bankrupting"),
          subtitle:
              Text("If you bankrupt another player you'll get all his assets."),
          trailing: Switch(
            value: Game.data.settings.receiveProperties ?? false,
            onChanged: (val) {
              Game.data.settings.receiveProperties = val;
              Game.save(only: [SaveData.settings.toString()]);
            },
          ),
        ),
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
                    Game.save(only: [SaveData.settings.toString()]);
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
          title: Text("Double go bonus"),
          subtitle: Text("Double the bonus when you land on start."),
          trailing: Switch(
            value: Game.data.settings.doubleBonus ?? false,
            onChanged: (val) {
              Game.data.settings.doubleBonus = val;
              Game.save(only: [SaveData.settings.toString()]);
            },
          ),
        ),
        Divider(),
        ListTile(
          title: Text("Receive rent in jail"),
          subtitle: Text(
              "Wheter you receive rent from your properties while in jail."),
          trailing: Switch(
            value: Game.data.settings.receiveRentInJail ?? true,
            onChanged: (val) {
              Game.data.settings.receiveRentInJail = val;
              Game.save(only: [SaveData.settings.toString()]);
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
                    Game.save(only: [SaveData.settings.toString()]);
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
          title: Text("Hacker screen"),
          subtitle: Text("Allow players to see the hacker screen."),
          trailing: Switch(
            value: Game.data.settings.hackerScreen,
            onChanged: (val) {
              Game.data.settings.hackerScreen = val;
              Game.save(only: [SaveData.settings.toString()]);
            },
          ),
        ),
      ],
    );
  }
}
