import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plutopoly/bloc/game_listener.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/widgets/my_card.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/data/deal_data.dart';
import '../../engine/data/map.dart';
import '../../engine/kernel/main.dart';
import '../../engine/ui/alert.dart';
import '../../widgets/houses.dart';

class DealScreen extends StatelessWidget {
  final int dealer;
  final bool visit;
  const DealScreen({Key key, @required this.dealer, bool this.visit: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!visit) {
      Game.data.dealData.dealer = dealer;
    } else {
      Game.ui.showDealScreen = false;
    }

    return GameListener(
      builder: (BuildContext context, dynamic value, Widget child) {
        return DealScreenChild(visit: visit);
      },
    );
  }
}

class DealScreenChild extends StatefulWidget {
  final bool visit;
  const DealScreenChild({Key key, this.visit}) : super(key: key);

  @override
  _DealScreenChildState createState() => _DealScreenChildState();
}

class _DealScreenChildState extends State<DealScreenChild>
    with SingleTickerProviderStateMixin {
  final _dealerTextController = TextEditingController();
  final _playerTextController = TextEditingController();

  bool emptyText = true;
  bool showedDealScreen;

  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  DealData get dealData => Game.data.dealData;

  @override
  void initState() {
    super.initState();

    MainBloc.dealOpen = true;

    if (MainBloc.metaBox.get("boolDealLandscape", defaultValue: true)) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    ));
    if (dealData.dealer < 0) dealData.dealer = null;
    if (dealData.dealer == null) return;
    if (!widget.visit) {
      dealData.receivableProperties =
          List.from(Game.data.players[dealData.dealer].properties);
      dealData.payableProperties = List.from(Game.data.player.properties);
      Game.save();
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _dealerTextController.dispose();
    _playerTextController.dispose();
    _controller.dispose();
    Game.data.dealData = DealData();
    Game.data.dealData.dealer = null;
    Game.save();
    MainBloc.dealOpen = false;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (dealData.price < 0) {
      _dealerTextController.value =
          TextEditingValue(text: dealData.price.abs().toString());
      _playerTextController.clear();
    } else {
      _playerTextController.value =
          TextEditingValue(text: dealData.price.toString());
      _dealerTextController.clear();
    }
    if (emptyText) {
      Future.delayed(Duration(milliseconds: 200), () {
        emptyText = false;
        if (mounted) setState(() {});
      });
    }
    if (dealData.dealer == null || dealData.dealer < 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Deal Screen"),
        ),
        body: Center(
          child: Text("Session terminated"),
        ),
      );
    }

    if (dealData.dealerChecked && dealData.playerChecked && !Game.ui.idle) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    if (checkPay() && dealData.valid[0] && dealData.valid[1] && !Game.ui.idle) {
      _controller.forward();
    }

    bool infoMessage = MainBloc.metaBox.get("boolDealInfo", defaultValue: true);

    if (UIBloc.isWide(context)) {
      bool lockLandscape =
          MainBloc.metaBox.get("boolDealLandscape", defaultValue: true);
      return Scaffold(
        appBar: AppBar(
          title: Text("New Deal"),
          actions: [
            IconButton(
              icon: Icon(lockLandscape
                  ? Icons.screen_lock_landscape
                  : Icons.stay_current_landscape),
              onPressed: () {
                MainBloc.metaBox.put("boolDealLandscape", !lockLandscape);
                if (lockLandscape) {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeRight,
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ]);
                } else {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight,
                  ]);
                }
              },
            )
          ],
        ),
        floatingActionButton: buildFab(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            infoMessage
                ? MyCard(
                    title: "Deal screen",
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: !emptyText
                            ? Text(
                                "Here you can deal with other players. \nEverything in the left card gets swapped with the right card\n When ready click on confirm and wait for the other player to confirm as well. ",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              )
                            : Container(),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          onPressed: () {
                            MainBloc.metaBox.put("boolDealInfo", false);
                            setState(() {});
                          },
                          child: Text("Got it"),
                        ),
                      )
                    ],
                  )
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: buildDealTab(context)),
                VerticalDivider(),
                Expanded(child: buildDealTab(context, dealer: true))
              ],
            ),
          ],
        ),
      );
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: Text("New deal"),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: Game.data.player.name,
                ),
                Tab(text: Game.data.players[dealData.dealer].name),
              ],
            )),
        floatingActionButton: buildFab(context),
        body: TabBarView(
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                buildDealTab(context),
              ],
            ),
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                buildDealTab(context, dealer: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SlideTransition buildFab(BuildContext context) {
    return SlideTransition(
        position: _offsetAnimation,
        child: AbsorbPointer(
          absorbing: false,
          child: FloatingActionButton.extended(
            backgroundColor:
                checkPay() ? Colors.red : Theme.of(context).accentColor,
            label: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Center(
                    child: Text(
                  checkPay() ? "Pay" : "Deal",
                  style: TextStyle(color: Colors.white),
                ))),
            onPressed: () {
              Alert.handleAndPop(
                  () => Game.act.deal(
                      dealer: dealData.dealer,
                      payProperties: dealData.payProperties,
                      receiveProperties: dealData.receiveProperties,
                      payAmount: dealData.price),
                  context);
            },
          ),
        ));
  }

  Widget buildDealTab(BuildContext context, {bool dealer: false}) {
    bool showConfirm = true;
    if (dealer) {
      if (MainBloc.online) {
        if (MainBloc.player.code !=
            Game.data.players[Game.data.dealData.dealer].code) {
          showConfirm = false;
        }
      }
    } else {
      if (MainBloc.online && MainBloc.player.code != Game.data.player.code) {
        showConfirm = false;
      }
    }
    if (check(dealer)) {
      showConfirm = true;
    }
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        dealer
                            ? Game.data.players[dealData.dealer].name
                            : Game.data.player.name,
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Change price"),
                                content: TextFormField(
                                  autofocus: true,
                                  keyboardType: TextInputType.numberWithOptions(
                                      signed: false, decimal: false),
                                  decoration: InputDecoration(
                                    prefixText: "£ ",
                                    fillColor: Colors.red,
                                    hoverColor: Colors.red,
                                    labelText: "Enter amount",
                                    errorText: !dealData.valid[dealer ? 0 : 1]
                                        ? "Please enter a natural number"
                                        : null,
                                  ),
                                  onFieldSubmitted: (String val) {
                                    if (val == "") val = "0";
                                    dealData.price = int.tryParse(val);
                                    if (dealData.price == null)
                                      dealData.valid[dealer ? 0 : 1] = false;
                                    else {
                                      if (dealer)
                                        dealData.price = -dealData.price;
                                      dealData.valid[dealer ? 0 : 1] = true;
                                    }
                                    if (dealer) {
                                      _playerTextController.clear();
                                    } else
                                      _dealerTextController.clear();
                                    Navigator.pop(context);
                                    Game.save();
                                  },
                                ),
                              );
                            },
                          );
                        },
                        readOnly: true,
                        controller: dealer
                            ? _dealerTextController
                            : _playerTextController,
                        keyboardType: TextInputType.numberWithOptions(
                            signed: false, decimal: false),
                        decoration: InputDecoration(
                          prefixText: "£ ",
                          fillColor: Colors.red,
                          hoverColor: Colors.red,
                          labelText: "Enter amount",
                        ),
                      ),
                    ),
                    Container(
                      height: 5,
                    ),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: (dealer
                                ? dealData.receiveProperties
                                : dealData.payProperties)
                            .length,
                        itemBuilder: (context, index) {
                          return _buildPropertyCard(
                              Game.data.gmap[(dealer
                                  ? dealData.receiveProperties
                                  : dealData.payProperties)[index]],
                              index,
                              dealer);
                        }),
                    (dealer
                                ? dealData.receiveProperties
                                : dealData.payProperties)
                            .isEmpty
                        ? Container(
                            height: 64,
                            child: Center(
                              child: Text("No properties selected"),
                            ),
                          )
                        : Container(),
                    (dealData.receiveProperties.isEmpty &&
                            dealData.payProperties.isEmpty)
                        ? Container()
                        : Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: showConfirm
                                  ? RaisedButton(
                                      color: check(dealer)
                                          ? Colors.green
                                          : Colors.red,
                                      child: check(dealer)
                                          ? Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            )
                                          : Text(
                                              "Confirm",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                      onPressed: () {
                                        if (dealer) {
                                          if (MainBloc.online) {
                                            if (MainBloc.player.code !=
                                                Game
                                                    .data
                                                    .players[Game
                                                        .data.dealData.dealer]
                                                    .code) {
                                              Alert.handle(
                                                  () => Alert("No permission",
                                                      "You can not confirm this side."),
                                                  context);
                                              return;
                                            }
                                          }
                                          dealData.dealerChecked =
                                              !dealData.dealerChecked;
                                        } else {
                                          if (MainBloc.online &&
                                              MainBloc.player.code !=
                                                  Game.data.player.code) {
                                            Alert.handle(
                                                () => Alert("No permission",
                                                    "You can not confirm this side."),
                                                context);
                                            return;
                                          }
                                          if (!(showedDealScreen ?? false)) {
                                            Game.ui.showDealScreen = true;
                                            showedDealScreen = true;
                                            setState(() {});
                                          }

                                          dealData.playerChecked =
                                              !dealData.playerChecked;
                                        }
                                        Game.save();
                                      },
                                    )
                                  : Container(),
                            ),
                          )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Chip(
                  label: Text("£" +
                      (dealer
                          ? (Game.data.players[dealData.dealer].money
                              .toInt()
                              .toString())
                          : Game.data.player.money.toInt().toString())),
                ),
              ),
            ),
          ],
        ),
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: max(
                (dealer
                        ? dealData.receivableProperties
                        : dealData.payableProperties)
                    .length,
                1),
            itemBuilder: (context, index) {
              if ((dealer
                      ? dealData.receivableProperties
                      : dealData.payableProperties)
                  .isEmpty) {
                return Container(
                  height: 64,
                  child: Center(
                    child: Text("No properties"),
                  ),
                );
              }
              return _buildPropertyCard(
                  Game.data.gmap[(dealer
                      ? dealData.receivableProperties
                      : dealData.payableProperties)[index]],
                  index,
                  dealer,
                  selected: false);
            }),
      ],
    );
  }

  bool check(bool dealer) {
    return ((dealer && dealData.dealerChecked) ||
        (!dealer && dealData.playerChecked));
  }

  void addPay(int index, Tile tile, bool dealer) {
    (dealer ? dealData.receivableProperties : dealData.payableProperties)
        .removeAt(index);
    (dealer ? dealData.receiveProperties : dealData.payProperties)
        .add(tile.mapIndex);
    dealData.dealerChecked = false;
    dealData.playerChecked = false;
    Game.save();
  }

  void removePay(int index, Tile tile, bool dealer) {
    (dealer ? dealData.receiveProperties : dealData.payProperties)
        .removeAt(index);
    (dealer ? dealData.receivableProperties : dealData.payableProperties)
        .add(tile.mapIndex);
    dealData.dealerChecked = false;
    dealData.playerChecked = false;
    Game.save();
  }

  bool checkPay() {
    if (MainBloc.online) {
      if ((dealData.price ?? 0) <= 0) return false;
    }
    return dealData.payProperties.isEmpty &&
        dealData.receiveProperties.isEmpty &&
        dealData.price != 0;
  }

  Widget _buildPropertyCard(Tile tile, int index, bool dealer,
      {bool selected: true}) {
    Widget _leading = Container(
      width: 0,
    );
    if (tile.mortaged ?? false)
      _leading = Icon(Icons.turned_in, color: Colors.white);
    if (tile.type == TileType.land)
      return Card(
        color: Color(tile.color),
        child: ListTile(
          leading: _leading,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Text(
                  tile.name ?? "",
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Container(width: 2),
              Container(
                child: Houses(amount: tile.level),
                height: 40,
              )
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              selected ? Icons.close : Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              if (selected) {
                removePay(index, tile, dealer);
              } else {
                addPay(index, tile, dealer);
              }
            },
          ),
        ),
      );
    if (tile.type == TileType.company) {
      return Card(
        color: Colors.white,
        child: ListTile(
          leading: tile.idIndex == 1
              ? FaIcon(FontAwesomeIcons.bolt, color: Colors.orange)
              : FaIcon(FontAwesomeIcons.faucet, color: Colors.blue),
          title: Text(
            tile.name ?? "",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(
            icon: Icon(
              selected ? Icons.close : Icons.add,
              color: Colors.black,
            ),
            onPressed: () {
              if (selected) {
                removePay(index, tile, dealer);
              } else {
                addPay(index, tile, dealer);
              }
            },
          ),
        ),
      );
    }
    if (tile.type == TileType.trainstation) {
      return Card(
        color: Colors.white,
        child: ListTile(
          leading: Icon(Icons.train, color: Colors.black),
          title: Text(
            tile.name ?? "",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(
            icon: Icon(
              selected ? Icons.close : Icons.add,
              color: Colors.black,
            ),
            onPressed: () {
              if (selected) {
                removePay(index, tile, dealer);
              } else {
                addPay(index, tile, dealer);
              }
            },
          ),
        ),
      );
    }
    return Container();
  }
}
