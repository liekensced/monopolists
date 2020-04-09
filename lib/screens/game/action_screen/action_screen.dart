import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:monopolists/engine/ui/alert.dart';
import 'package:monopolists/screens/game/action_screen/bottom_sheet.dart';
import 'package:monopolists/screens/game/action_screen/property_card.dart';

import '../../../bloc/main_bloc.dart';
import '../../../engine/kernel/main.dart';
import '../../../engine/ui/game_navigator.dart';
import '../../../widgets/animated_count.dart';
import '../../actions.dart/actions.dart';
import '../../actions.dart/money_card.dart';
import '../../actions.dart/property_action_card.dart';
import '../../carousel/map_carousel.dart';

class ActionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double fraction = 200 / MediaQuery.of(context).size.width;
    PageController pageController = PageController(
        initialPage: Game.data.player.position, viewportFraction: fraction);
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (Alert.handle(Game.next, context)) {
              GameNavigator.navigate(context);
            }
          },
          child: Icon(
            Icons.navigate_next,
            color: Colors.white,
          ),
        ),
        body: FractionallySizedBox(
          heightFactor: 1,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: Text(Game.data.player.name),
                  leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      showSettingsSheet(context);
                    },
                  ),
                  actions: [
                    Center(
                        child: Card(
                            child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ValueListenableBuilder(
                        valueListenable: MainBloc.listen(),
                        builder: (BuildContext context, _, __) {
                          return Row(
                            children: <Widget>[
                              Text("£"),
                              AnimatedCount(
                                count: Game.data.player.money.round(),
                                duration: Duration(seconds: 1),
                              ),
                            ],
                          );
                        },
                      ),
                    ))),
                    Container(
                      width: 5,
                    )
                  ],
                  automaticallyImplyLeading: false,
                  expandedHeight: 450.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.only(bottom: 10),
                          height: 300,
                          child: Theme(
                            data: ThemeData.light(),
                            child: ValueListenableBuilder(
                              valueListenable:
                                  Hive.box(MainBloc.GAMESBOX).listenable(),
                              builder: (_, __, ___) {
                                return MapCarousel(controller: pageController);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  bottom: TabBar(
                    tabs: [
                      Tab(child: Text("Holdings")),
                      Tab(child: Text("Actions"))
                    ],
                  ),
                )
              ];
            },
            body: TabBarView(
              children: <Widget>[
                buildHoldingCards(context),
                ValueListenableBuilder(
                  valueListenable: MainBloc.listen(),
                  builder: (BuildContext context, _, __) {
                    return buildActionCards(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHoldingCards(BuildContext context) {
    List<int> _properties = Game.data.player.properties;
    if (_properties.isEmpty) {
      return Container(
        height: 100,
        child: Center(
            child: Card(
                child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text("You have no properties yet"),
        ))),
      );
    }
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _properties.length,
        itemBuilder: (context, index) {
          return Theme(
            data: Theme.of(context).copyWith(brightness: Brightness.light),
            child: ValueListenableBuilder(
              valueListenable: MainBloc.listen(),
              builder: (BuildContext context, _, __) {
                return PropertyCard(tile: Game.data.gmap[_properties[index]]);
              },
            ),
          );
        });
  }

  Widget buildActionCards(BuildContext context) {
    List<Widget> actions = [
      PropertyActionCard(),
      MoneyCard(),
      ActionsCard(),
    ];
    List<Widget> evenActions = [];

    List<Widget> oddActions = [];
    actions.asMap().forEach((index, w) {
      if (index.isEven)
        evenActions.add(w);
      else
        oddActions.add(w);
    });

    if (MainBloc.isWide(context)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: evenActions,
            ),
          ),
          Expanded(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: oddActions,
            ),
          )
        ],
      );
    }

    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: actions,
    );
  }
}
