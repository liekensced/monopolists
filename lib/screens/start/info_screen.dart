import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/widgets/my_card.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/data/extensions.dart';
import '../../engine/data/settings.dart';
import '../../engine/data/tip.dart';
import '../../engine/kernel/extensions/bank.dart';
import '../../engine/kernel/extensions/jurisdiction.dart';
import '../../engine/kernel/main.dart';
import '../../engine/ui/game_navigator.dart';
import '../../widgets/end_of_list.dart';
import 'players.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> infoWidgets = <Widget>[];
    List<Extension> extensions = Game.data.extensions;

    if (MainBloc.online) infoWidgets.add(PlayersCard());

    infoWidgets.add(IconDivider(
      icon: Icon(Icons.settings, size: 40),
    ));
    List<Widget> prefs = <Widget>[];
    Settings settings = Game.data.settings;
    if (settings.dontBuyFirstRound) {
      prefs.add(ListTile(
        leading: Icon(Icons.info),
        title: Text("You can't buy the first round"),
      ));
    }
    if (settings.mustAuction) {
      prefs.add(ListTile(
        leading: Icon(Icons.info),
        title: Text("You must auction a property if you don't buy it"),
      ));
    }
    if (settings.remotelyBuild) {
      prefs.add(ListTile(
        leading: Icon(Icons.info),
        title: Text("You can build houses remotely."),
      ));
    } else {
      prefs.add(ListTile(
        leading: Icon(Icons.info),
        title: Text("You have to stand on the property to build a house"),
      ));
    }
    if (settings.allowOneDice) {
      prefs.add(ListTile(
        leading: Icon(Icons.info),
        title: Text("You can choose to only use 1 dice."),
      ));
    }
    if (settings.goBonus != 200) {
      prefs.add(ListTile(
        leading: Icon(Icons.info),
        title: Text("Go bonus: " + settings.goBonus.toString()),
      ));
    }
    if (settings.maxTurnes < 1000) {
      prefs.add(ListTile(
        leading: Icon(Icons.info),
        title:
            Text("Maximum amount of turnes: " + settings.maxTurnes.toString()),
      ));
    }

    infoWidgets.add(MyCard(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: prefs.length,
          separatorBuilder: (_, __) {
            return Divider();
          },
          itemBuilder: (context, index) {
            return prefs[index];
          },
        ),
      ),
    ]));
    if (extensions.contains(Extension.bank)) {
      infoWidgets.add(IconDivider(icon: Bank.icon(size: 40)));
      Bank.getInfo().forEach((info) {
        infoWidgets.add(_buildCard(info));
      });
    }

    if (extensions.contains(Extension.jurisdiction)) {
      infoWidgets.add(IconDivider(icon: Jurisdiction.icon(size: 40)));
      Jurisdiction.getInfo().forEach((info) {
        infoWidgets.add(_buildCard(info));
      });
    }
    if (infoWidgets.length > 3) {
      infoWidgets.add(EndOfList());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Info"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Game.data.running = true;
          GameNavigator.navigate(context);
        },
        child: FaIcon(
          FontAwesomeIcons.rocket,
          color: Colors.white,
        ),
      ),
      body: AnimationLimiter(
        child: ListView.builder(
          itemCount: infoWidgets.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 800),
              child: FadeInAnimation(child: infoWidgets[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard(Info info) {
    return MyCard(
      children: <Widget>[
        Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _getIcon(info.type),
                Container(
                  width: 20,
                ),
                Text(
                  info.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            )),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            20.0,
            0,
            20.0,
            20.0,
          ),
          child: Text(info.content,
              style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
        )
      ],
    );
  }

  Widget _getIcon(type) {
    switch (type) {
      case InfoType.rule:
        return FaIcon(
          FontAwesomeIcons.book,
          color: Colors.green,
          size: 40,
        );
        break;
      case InfoType.tip:
        return Icon(
          Icons.info_outline,
          color: Colors.orange,
          size: 40,
        );
        break;
      case InfoType.alert:
        return Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 40,
        );
        break;
    }
    return Container();
  }
}

class IconDivider extends StatelessWidget {
  final Widget icon;
  const IconDivider({Key key, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Divider(
          thickness: 2,
        )),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(child: icon),
        ),
        Expanded(
            child: Divider(
          thickness: 2,
        ))
      ],
    );
  }
}
