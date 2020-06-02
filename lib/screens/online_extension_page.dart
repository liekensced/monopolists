import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/engine/data/tip.dart';
import 'package:plutopoly/screens/start/info_screen.dart';
import 'package:plutopoly/widgets/end_of_list.dart';
import 'package:plutopoly/widgets/my_card.dart';

class OnlineExtensionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Online extensions"),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          MyCard(
            title: "Add online extensions",
            smallTitle: true,
            children: [
              Container(
                  height: 100,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FaIcon(
                        FontAwesomeIcons.globe,
                        size: 40,
                      ),
                      Icon(
                        Icons.extension,
                        size: 40,
                      ),
                    ],
                  ))),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "To add online extensions, you have to go to a provider and enter your game pin. When you did that, the bot should be shown in the online extensions card. When you give your game pin to a provider they have full acces to all data.",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          IconDivider(
            icon: Icon(Icons.code),
          ),
          MyCard(
            title: "Create online extensions",
            smallTitle: true,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InkWell(
                  onTap: () {
                    _launchURL(context);
                  },
                  child: ListTile(
                    title: Text(
                        "You can easily build your own extensions if you have some programming experience. Check out the github page."),
                    trailing: Icon(Icons.open_in_new),
                  ),
                ),
              )
            ],
          ),
          GeneralInfoCard(
              info: Info(
                  "Broken",
                  "The online extensions are not compatible with\nversions > 0.3.0",
                  InfoType.alert)),
          GeneralInfoCard(
              info: Info(
                  "Proof of concept",
                  "The online extensions are in early acces. It is not stable yet. You can already create your own map but live updating is very unstable.",
                  InfoType.alert)),
          EndOfList()
        ],
      ),
    );
  }

  _launchURL(BuildContext context) async {
    const url = 'https://github.com/filoruxonline/plutopoly-bot';
    UIBloc.launchUrl(context, url);
  }
}
