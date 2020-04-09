import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:monopolists/bloc/main_bloc.dart';
import 'package:monopolists/engine/data/map.dart';
import 'package:monopolists/engine/kernel/main.dart';
import 'package:monopolists/engine/ui/alert.dart';
import 'package:monopolists/widgets/houses.dart';

class DealScreen extends StatefulWidget {
  final int dealer;

  const DealScreen({Key key, @required this.dealer}) : super(key: key);

  @override
  _DealScreenState createState() => _DealScreenState();
}

class _DealScreenState extends State<DealScreen>
    with SingleTickerProviderStateMixin {
  int payAmount = 0;

  List<int> receivableProperties = [];
  List<int> receiveProperties = [];
  List<int> payableProperties = [];
  List<int> payProperties = [];

  int price = 0;
  List<bool> valid = [true, true];

  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  final _playerTextController = TextEditingController();
  final _dealerTextController = TextEditingController();

  bool playerChecked = false;
  bool dealerChecked = false;

  @override
  void initState() {
    super.initState();
    receivableProperties = Game.data.players[widget.dealer].properties;
    payableProperties = Game.data.player.properties;

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
    if (dealerChecked && playerChecked) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    if (checkPay() && valid[0] && valid[1]) {
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
                Tab(text: Game.data.players[widget.dealer].name),
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
                    dealer: widget.dealer,
                    payProperties: payProperties,
                    receiveProperties: receiveProperties,
                    payAmount: price),
                context);
          },
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
                        ? Game.data.players[widget.dealer].name
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
                      errorText: !valid[dealer ? 0 : 1]
                          ? "Please enter a natural number"
                          : null,
                    ),
                    onChanged: (String val) {
                      if (val == "") val = "0";
                      price = int.tryParse(val);
                      if (price == null)
                        valid[dealer ? 0 : 1] = false;
                      else {
                        if (dealer) price = -price;
                        valid[dealer ? 0 : 1] = true;
                      }
                      if (dealer) {
                        _playerTextController.clear();
                      } else
                        _dealerTextController.clear();
                      setState(() {});
                    },
                  ),
                ),
                Container(
                  height: 5,
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        (dealer ? receiveProperties : payProperties).length,
                    itemBuilder: (context, index) {
                      return _buildPropertyCard(
                          Game.data.gmap[(dealer
                              ? receiveProperties
                              : payProperties)[index]],
                          index,
                          dealer);
                    }),
                (dealer ? receiveProperties : payProperties).isEmpty
                    ? Container(
                        height: 64,
                        child: Center(
                          child: Text("No properties selected"),
                        ),
                      )
                    : Container(),
                (receiveProperties.isEmpty && payProperties.isEmpty)
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
                                dealerChecked = !dealerChecked;
                              else
                                playerChecked = !playerChecked;
                              setState(() {});
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
                (dealer ? receivableProperties : payableProperties).length, 1),
            itemBuilder: (context, index) {
              if ((dealer ? receivableProperties : payableProperties).isEmpty) {
                return Container(
                  height: 64,
                  child: Center(
                    child: Text("No properties"),
                  ),
                );
              }
              return _buildPropertyCard(
                  Game.data.gmap[(dealer
                      ? receivableProperties
                      : payableProperties)[index]],
                  index,
                  dealer,
                  selected: false);
            }),
      ],
    );
  }

  bool check(bool dealer) {
    return ((dealer && dealerChecked) || (!dealer && playerChecked));
  }

  void addPay(int index, Tile tile, bool dealer) {
    (dealer ? receivableProperties : payableProperties).removeAt(index);
    (dealer ? receiveProperties : payProperties).add(tile.index);
    dealerChecked = false;
    playerChecked = false;
    setState(() {});
  }

  void removePay(int index, Tile tile, bool dealer) {
    (dealer ? receiveProperties : payProperties).removeAt(index);
    (dealer ? receivableProperties : payableProperties).add(tile.index);
    dealerChecked = false;
    playerChecked = false;
    setState(() {});
  }

  bool checkPay() {
    return payProperties.isEmpty && receiveProperties.isEmpty && price != 0;
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
