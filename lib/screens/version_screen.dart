import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/main_bloc.dart';
import '../engine/data/tip.dart';
import '../widgets/end_of_list.dart';
import '../widgets/my_card.dart';
import 'start/info_screen.dart';

class VersionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      openColor: Theme.of(context).canvasColor,
      closedColor: Theme.of(context).canvasColor,
      openBuilder: (_, __) => VersionScreen(),
      closedBuilder: (_, f) => MyCard(
        title: "Version",
        children: [
          ListTile(
            title: Text("Your current version:"),
            trailing: Text(MainBloc.version),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FlatButton(
              textColor: Theme.of(context).primaryColor,
              onPressed: () {
                f();
              },
              child: Text("More info"),
            ),
          )
        ],
      ),
    );
  }
}

class VersionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("version"),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          MyCard(
            title: "v" + MainBloc.version + " bèta",
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0).copyWith(bottom: 0),
                child: Text(
                  "There is a chance that your game will break when updating the app. The version number is structured like this:",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              Container(
                height: 40,
                child: Center(
                  child: Text(
                    "major.minor.hotfix",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0).copyWith(top: 0),
                child: Text(
                  "Your current game can break if the minor changes. The stock price could be calculated differently. When the major changes, your past games will probably fully break.",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ],
          ),
          GeneralInfoCard(
              info: Info(
                  "Website",
                  "There are 2 websites to play Plutopoly:\nplutopoly.web.app\nplayplutopoly.web.app\nYour data is not shared on these sites so you could have multiple accounts.",
                  InfoType.rule)),
          GeneralInfoCard(
              info: Info(
                  "Web updates",
                  "The web version updates when you fully close your browser. It could be the you are on a older version",
                  InfoType.alert)),
          MyCard(
            title: "Fix version",
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "If you want to play on a older version of Plutopoly, to continue an already started game for example, you can visit oldplutopoly.web.app.",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              RaisedButton(
                child: Text("Open Old Plutopoly"),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  String url =
                      'https://oldplutopoly.web.app/?authcode=${MainBloc.code}&name=${MainBloc.player.name}&color=${MainBloc.player.color}';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            title: Text("Failed"),
                            content: Text("Failed to open link"),
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
                  }
                },
              )
            ],
          ),
          EndOfList()
        ],
      ),
    );
  }
}
