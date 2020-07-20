import 'dart:math';
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache_builder.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plutopoly/screens/store/game_icons_data.dart';
import 'package:plutopoly/screens/store/game_icons_screen.dart';

import '../../bloc/main_bloc.dart';
import '../../bloc/ui_bloc.dart';
import '../../engine/kernel/main.dart';
import '../../engine/ui/alert.dart';
import '../../helpers/progress_helper.dart';
import '../../widgets/animated_count.dart';
import '../../widgets/end_of_list.dart';
import 'currencies_data.dart';

class StoreRewardsList extends StatefulWidget {
  const StoreRewardsList({Key key}) : super(key: key);

  @override
  _StoreRewardsListState createState() => _StoreRewardsListState();
}

class _StoreRewardsListState extends State<StoreRewardsList> {
  int startIndex;
  int statIconIndex;
  @override
  void initState() {
    startIndex = Random().nextInt(commonCurrencies.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    startIndex = Random().nextInt(commonCurrencies.length);
    statIconIndex = Random().nextInt(commonGameIcons.length);

    return Container(
      height: 220,
      child: PageView(
        controller: PageController(
            viewportFraction: min(
                UIBloc.maxWidth * 0.8 / MediaQuery.of(context).size.width,
                0.8)),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OpenContainer(
              closedColor: Theme.of(context).cardColor,
              openBuilder: (context, _) {
                return CurrencyScreen();
              },
              closedBuilder: (contect, f) => Column(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Currencies",
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                  height: 50,
                  child: Center(
                    child: Text(
                      commonCurrencies[startIndex].icon,
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
                Flexible(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (int i in List.generate(5, (index) => index))
                          Text(
                            commonCurrencies[(startIndex + i + 1) %
                                    (commonCurrencies.length - 1)]
                                .icon,
                          ),
                      ],
                    ),
                  ),
                ),
                Builder(
                  builder: (context) => Align(
                    alignment: Alignment.bottomCenter,
                    child: Tooltip(
                      message: "Open currency screen",
                      child: MaterialButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Text("Open screen"),
                        onPressed: () {
                          f();
                        },
                      ),
                    ),
                  ),
                )
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OpenContainer(
              closedColor: Theme.of(context).cardColor,
              openBuilder: (context, _) {
                return GameIconScreen();
              },
              closedBuilder: (contect, f) => Column(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Icons",
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                  height: 50,
                  child: Center(
                    child: Icon(
                      commonGameIcons[statIconIndex].data,
                      size: 40,
                    ),
                  ),
                ),
                Flexible(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (int i in List.generate(5, (index) => index))
                          Icon(
                            commonGameIcons[(statIconIndex + i + 1) %
                                    (commonGameIcons.length - 1)]
                                .data,
                          ),
                      ],
                    ),
                  ),
                ),
                Builder(
                  builder: (context) => Align(
                    alignment: Alignment.bottomCenter,
                    child: Tooltip(
                      message: "Open icon screen",
                      child: MaterialButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Text("Open screen"),
                        onPressed: () {
                          f();
                        },
                      ),
                    ),
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}

class CurrencyScreen extends StatelessWidget {
  final bool selector;

  const CurrencyScreen({Key key, this.selector: false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: selector
          ? FloatingActionButton.extended(
              onPressed: () {
                Currency selected = CurrencyHelper.selectedCurrency;
                Game.data.currency = selected.icon;
                Game.data.placeCurrencyInFront = selected.placeCurrencyInFront;
                Game.save();
                Navigator.pop(context);
              },
              label: Text(
                "select currency",
                style: TextStyle(color: Colors.white),
              ),
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
            )
          : FloatingActionButton.extended(
              onPressed: () {
                if (ProgressHelper.tickets < 20)
                  Alert.handle(
                      () => Alert("Tickets",
                          "You need at least 20 tickets to get a new currency."),
                      context);
                else {
                  Currency cur = CurrencyHelper.addCurrency();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return FlareCacheBuilder(
                        [
                          AssetFlare(
                              bundle: rootBundle, name: "assets/open.flr")
                        ],
                        builder: (context, loaded) {
                          if (!loaded)
                            return Center(child: CircularProgressIndicator());
                          return NewCurrencyDialog(
                            cur: cur,
                          );
                        },
                      );
                    },
                  );
                }
              },
              label: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Text(
                      "New currency 20 ",
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.local_activity,
                      color: Colors.white,
                    )
                  ],
                ),
              )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text("Currencies"),
        actions: [
          Center(
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValueListenableBuilder(
                valueListenable: Hive.box(MainBloc.ACCOUNTBOX).listenable(),
                builder: (BuildContext context, _, __) {
                  return Row(
                    children: <Widget>[
                      AnimatedCount(
                        count: ProgressHelper.tickets,
                        duration: Duration(seconds: 1),
                      ),
                      Container(
                        height: 0,
                        width: 5,
                      ),
                      Icon(
                        Icons.local_activity,
                        size: 20,
                      )
                    ],
                  );
                },
              ),
            )),
          ),
          Container(
            width: 5,
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: UIBloc.maxWidth),
            child: Center(
              child: ValueListenableBuilder(
                valueListenable: Hive.box(MainBloc.ACCOUNTBOX).listenable(),
                builder: (context, __, _) {
                  Currency selectedCurrency = CurrencyHelper.selectedCurrency;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(height: 30),
                        Center(
                          child: Text(
                            selectedCurrency.icon,
                            style: TextStyle(fontSize: 100),
                          ),
                        ),
                        Center(
                            child: Text(
                          selectedCurrency.name,
                          style: TextStyle(fontSize: 22),
                        )),
                        Container(height: 30),
                        Container(
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 5,
                            children: [
                              for (Currency cur in commonCurrencies)
                                Tooltip(
                                  message: cur.name,
                                  child: Card(
                                    clipBehavior: Clip.hardEdge,
                                    child: InkWell(
                                      onTap: () {
                                        if (CurrencyHelper.ownedCurrencies
                                            .contains(cur.icon)) {
                                          CurrencyHelper.selectedCurrency = cur;
                                        }
                                      },
                                      child: Container(
                                        foregroundDecoration: BoxDecoration(
                                            color: Colors.grey.withAlpha(
                                                CurrencyHelper.ownedCurrencies
                                                        .contains(cur.icon)
                                                    ? 0
                                                    : 220)),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              cur.icon,
                                              style: TextStyle(
                                                  fontSize: 40,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                        EndOfList()
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NewCurrencyDialog extends StatefulWidget {
  final Currency cur;
  const NewCurrencyDialog({
    Key key,
    @required this.cur,
  }) : super(key: key);

  @override
  _NewCurrencyDialogState createState() => _NewCurrencyDialogState();
}

class _NewCurrencyDialogState extends State<NewCurrencyDialog>
    with SingleTickerProviderStateMixin {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    if (!open)
      Future.delayed(Duration(seconds: 1), () {
        open = true;
        setState(() {});
      });
    return AlertDialog(
        title: Text("New currency"),
        content: Container(
          alignment: Alignment.center,
          height: 200,
          width: 200,
          child: Stack(
            children: [
              FlareActor.bundle(
                "assets/open.flr",
                animation: "Untitled",
                fit: BoxFit.cover,
              ),
              Center(
                child: AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 500),
                  child: Container(
                    height: open ? 200 : 0,
                    width: open ? 200 : 0,
                    child: Center(
                      child: Text(
                        widget.cur.icon,
                        style: TextStyle(fontSize: 60),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "receive",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ))
        ]);
  }
}
