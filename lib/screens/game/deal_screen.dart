import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/data/deal_data.dart';
import '../../engine/data/map.dart';
import '../../engine/kernel/main.dart';
import '../../engine/ui/alert.dart';
import '../../widgets/houses.dart';

class DealScreen extends StatelessWidget {
  final int dealer;
  const DealScreen({Key key, @required this.dealer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Game.data.dealData.dealer = dealer;
    Game.save();
    return GameListener(
      builder: (BuildContext context, dynamic value, Widget child) {
        return DealScreenChild();
      },
    );
  }
}

class DealScreenChild extends StatefulWidget {
  const DealScreenChild({Key key}) : super(key: key);

  @override
  _DealScreenChildState createState() => _DealScreenChildState();
}

class _DealScreenChildState extends State<DealScreenChild>
    with SingleTickerProviderStateMixin {
  final _dealerTextController = TextEditingController();
  final _playerTextController = TextEditingController();

  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  DealData get dealData => Game.data.dealData;

  @override
  void initState() {
    super.initState();
    dealData.receivableProperties =
        Game.data.players[dealData.dealer].properties;
    dealData.payableProperties = Game.data.player.properties;
    Game.save();

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
  }

  @override
  void dispose() {
    super.dispose();
    _dealerTextController.dispose();
    _playerTextController.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (dealData.dealerChecked && dealData.playerChecked) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    if (checkPay() && dealData.valid[0] && dealData.valid[1]) {
      _controller.forward();
    }

    if (MainBloc.isWide(context)) {
      return Scaffold(
        appBar: AppBar(
          title: Text("New Deal"),
        ),
        floatingActionButton: buildFab(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
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
    return Column(
      // physics: BouncingScrollPhysics(),
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
                    controller:
                        dealer ? _dealerTextController : _playerTextController,
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
                    onChanged: (String val) {
                      if (val == "") val = "0";
                      dealData.price = int.tryParse(val);
                      if (dealData.price == null)
                        dealData.valid[dealer ? 0 : 1] = false;
                      else {
                        if (dealer) dealData.price = -dealData.price;
                        dealData.valid[dealer ? 0 : 1] = true;
                      }
                      if (dealer) {
                        _playerTextController.clear();
                      } else
                        _dealerTextController.clear();
                      Game.save();
                    },
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
                (dealer ? dealData.receiveProperties : dealData.payProperties)
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
                          child: RaisedButton(
                            color: check(dealer) ? Colors.green : Colors.red,
                            child: check(dealer)
                                ? Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  )
                                : Text(
                                    "Confirm",
                                    style: TextStyle(color: Colors.white),
                                  ),
                            onPressed: () {
                              if (dealer)
                                dealData.dealerChecked =
                                    !dealData.dealerChecked;
                              else
                                dealData.playerChecked =
                                    !dealData.playerChecked;
                              Game.save();
                            },
                          ),
                        ),
                      )
              ],
            ),
          ),
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
        .add(tile.index);
    dealData.dealerChecked = false;
    dealData.playerChecked = false;
    Game.save();
  }

  void removePay(int index, Tile tile, bool dealer) {
    (dealer ? dealData.receiveProperties : dealData.payProperties)
        .removeAt(index);
    (dealer ? dealData.receivableProperties : dealData.payableProperties)
        .add(tile.index);
    dealData.dealerChecked = false;
    dealData.playerChecked = false;
    Game.save();
  }

  bool checkPay() {
    return dealData.payProperties.isEmpty &&
        dealData.receiveProperties.isEmpty &&
        dealData.price != 0;
  }

  Widget _buildPropertyCard(Tile tile, int index, bool dealer,
      {bool selected: true}) {
    if (tile.type == TileType.land)
      return Card(
        color: Color(tile.color),
        child: ListTile(
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
