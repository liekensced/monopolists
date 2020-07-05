import 'dart:math';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plutopoly/helpers/progress_helper.dart';

import '../bloc/ad_bloc.dart';
import '../bloc/main_bloc.dart';

class DailyAdsMessage extends StatelessWidget {
  const DailyAdsMessage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return Container();
    int amount = Hive.box(MainBloc.METABOX).get("intAdDays") ?? -1;
    List<Widget> children = <Widget>[];

    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.rewarded) {
        giveReward(amount);
      }

      if (event == RewardedVideoAdEvent.loaded) {
        Hive.box(MainBloc.METABOX).put("boolShowAd", false);
        RewardedVideoAd.instance.show();
      }
    };

    for (int i = 0; i < amount; i++) {
      children.add(
        Container(
          height: 50,
          width: double.maxFinite,
          color: Colors.red,
          child: InkWell(
            onTap: () {
              Future.delayed(Duration(seconds: 15), () {
                if (Hive.box(MainBloc.METABOX).get("boolShowAd")) {
                  Hive.box(MainBloc.METABOX).put("boolShowAd", false);
                  giveReward(amount);
                }
              });

              Hive.box(MainBloc.METABOX).put("boolShowAd", true);
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return ValueListenableBuilder(
                      valueListenable: Hive.box(MainBloc.METABOX).listenable(),
                      builder: (context, box, _) {
                        if (!box.get("boolShowAd", defaultValue: true)) {
                          Navigator.pop(context);
                        }
                        return AlertDialog(
                          content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                              ]),
                          actions: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                Hive.box(MainBloc.METABOX)
                                    .put("boolShowAd", false);
                              },
                              child: Text(
                                "cancel",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            )
                          ],
                        );
                      },
                    );
                  });
              RewardedVideoAd.instance.load(
                adUnitId: AdBloc.rewardAdUID,
                targetingInfo: AdBloc.targetingInfo,
              );
            },
            child: ListTile(
              title: Text(
                "Click here for your daily add.",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(
                Icons.play_circle_filled,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  void giveReward(int amount) {
    ProgressHelper.energy += Random().nextInt(3) + 1;
    Hive.box(MainBloc.METABOX).put("intAdDays", amount - 1);
  }
}
