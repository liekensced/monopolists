import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/bloc/game_listener.dart';
import 'package:plutopoly/store/default_presets.dart';
import 'package:plutopoly/store/preset.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/data/extensions.dart';
import '../../engine/data/settings.dart';
import '../../engine/data/tip.dart';
import '../../engine/extensions/extension_data.dart';
import '../../engine/kernel/main.dart';
import '../../engine/ui/game_navigator.dart';
import '../../widgets/end_of_list.dart';
import '../../widgets/my_card.dart';
import 'players.dart';

class InfoScreen extends StatelessWidget {
  final bool running;

  const InfoScreen({Key key, this.running: false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GameListener(
      builder: (context, _, __) => InfoScreenChild(),
    );
  }
}

class InfoScreenChild extends StatelessWidget {
  final bool running;

  const InfoScreenChild({Key key, this.running: false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Widget> infoWidgets = <Widget>[];
    List<Extension> extensions = Game.data.extensions;

    if (MainBloc.online) infoWidgets.add(PlayersCard(showBots: false));

    infoWidgets.add(IconDivider(
      icon: Icon(Icons.settings, size: 40),
    ));
    List<Widget> prefs = <Widget>[];
    Settings settings = Game.data.settings;
    if (settings.mustAuction) {
      prefs.add(ListTile(
        leading: Icon(Icons.info),
        title: Text("You must auction a property if you don't buy it"),
      ));
    }
    if (settings.startProperties != Null && settings.startProperties != 0) {
      prefs.add(ListTile(
        leading: Icon(Icons.info),
        title: Text("You get ${settings.startProperties} start properties."),
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
    if (settings.receiveProperties ?? false) {
      prefs.add(ListTile(
        leading: Icon(Icons.info),
        title:
            Text("If you bankrupt another player you'll get all his assets."),
      ));
    }
    if (!(settings.receiveRentInJail ?? true)) {
      prefs.add(ListTile(
        leading: Icon(Icons.info),
        title: Text("You don't receive rent in jail"),
      ));
    }
    if (settings.doubleBonus ?? false) {
      prefs.add(ListTile(
        leading: Icon(Icons.info),
        title: Text("You get a double bonus when landing on start."),
      ));
    }
    if (settings.startingMoney != 1500) {
      prefs.add(ListTile(
        leading: Icon(Icons.info),
        title: Text("You get ${settings.startingMoney} money to start with."),
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
    Preset preset = PresetHelper.findPreset(Game.data.preset);
    if (preset != null && (preset.infoCards?.isNotEmpty ?? false)) {
      infoWidgets.add(IconDivider(icon: Icon(Icons.map)));
      preset.infoCards.forEach((info) {
        infoWidgets.add(GeneralInfoCard(info: info));
      });
    }

    switch (settings.diceType) {
      case DiceType.one:
        infoWidgets.add(IconDivider(
            icon: Icon(
          FontAwesomeIcons.dice,
          size: 35,
        )));
        infoWidgets.add(GeneralInfoCard(
            info: Info("1 Dice", "You only have one dice.", InfoType.rule)));
        infoWidgets.add(GeneralInfoCard(
            info: Info("Leave prison", "You can leave prison via throwing a 6.",
                InfoType.tip)));
        break;
      case DiceType.two:
        //default
        break;
      case DiceType.three:
        infoWidgets.add(IconDivider(
            icon: Icon(
          FontAwesomeIcons.dice,
          size: 35,
        )));
        infoWidgets.add(GeneralInfoCard(
            info: Info("3 Dices", "You have 2 dices and 1 bonus dice.",
                InfoType.rule)));
        infoWidgets.add(GeneralInfoCard(
            info: Info(
                "Bonus dice",
                "You can only throw a double with the first 2 dices. The last one doesn't count.",
                InfoType.alert)));
        break;
      case DiceType.random:
        infoWidgets.add(IconDivider(
            icon: Icon(
          FontAwesomeIcons.dice,
          size: 35,
        )));
        infoWidgets.add(GeneralInfoCard(
            info: Info("Random amount of dices",
                "You'll will randomly get 1, 2 or 3 dices.", InfoType.rule)));
        infoWidgets.add(GeneralInfoCard(
            info: Info("Leave prison (1 dice)",
                "You can leave prison via throwing a 6.", InfoType.tip)));
        infoWidgets.add(GeneralInfoCard(
            info: Info(
                "Bonus dice (3 dices)",
                "You can only throw a double with the first 2 dices. The last one doesn't count.",
                InfoType.alert)));
        break;
      case DiceType.choose:
        infoWidgets.add(IconDivider(
            icon: Icon(
          FontAwesomeIcons.dice,
          size: 35,
        )));
        infoWidgets.add(GeneralInfoCard(
            info: Info(
                "Choose the amount of dices",
                "You can choose if you want to use 1 or 2 dices.",
                InfoType.rule)));
        infoWidgets.add(GeneralInfoCard(
            info: Info("Leave prison (1 dice)",
                "You can leave prison via throwing a 6.", InfoType.tip)));
        break;
    }

    extensions.forEach((ext) {
      ExtensionData extensionData = ExtensionsMap.call()[ext];
      infoWidgets.add(IconDivider(icon: extensionData.icon()));
      extensionData.getInfo().forEach((info) {
        infoWidgets.add(GeneralInfoCard(info: info));
      });
    });

    if (infoWidgets.length > 3) {
      infoWidgets.add(EndOfList());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Info"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (running) {
            Navigator.pop(context);
            return;
          }
          Game.launch();
          Game.checkBot();
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
}

class GeneralInfoCard extends StatelessWidget {
  final Info info;
  const GeneralInfoCard({
    Key key,
    @required this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  info.title ?? "",
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
          child: buildContent(info),
        )
      ],
    );
  }

  Widget buildContent(Info info) {
    if (info.content == "__WS__")
      return Column(
        children: [
          Text(
              "Invest your money in world stock. The price is changed on 3 factors:"),
          ListTile(
            title: Text("Random (average of +4%)"),
          ),
          ListTile(
            title: Text("Expenditure, investing"),
            subtitle: Text(
                "If people built a lot or invest a lot the stock goes up."),
            trailing: Tooltip(
              child: Icon(Icons.info, color: Colors.grey),
              message: "Properties, houses, rent, ... NOT Fees, taxes",
            ),
          ),
          ListTile(
            title: Text("Bull/Bear market (+8% or -8%)"),
            trailing: Tooltip(
              child: Icon(Icons.info, color: Colors.grey),
              message: "Rising stock can cause a bull market and otherwise.",
            ),
          ),
        ],
      );
    return Text(info.content ?? "content",
        style: TextStyle(fontSize: 16), textAlign: TextAlign.center);
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
      case InfoType.setting:
        return Icon(
          Icons.settings,
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
