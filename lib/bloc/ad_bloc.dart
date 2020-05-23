import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:hive/hive.dart';

import 'main_bloc.dart';

class AdBloc {
  static NativeAdmobController idleAdController;
  static const bool test = false;
  static String rewardAdUID = test
      ? RewardedVideoAd.testAdUnitId
      : "ca-app-pub-3735790035510409/6907004457";
  static String nativeAdUID =
      test ? NativeAd.testAdUnitId : "ca-app-pub-3735790035510409/3739583933";

  static MobileAdTargetingInfo targetingInfo =
      MobileAdTargetingInfo(keywords: <String>["boardgame"]);
  static void init() async {
    if (kIsWeb) return;
    idleAdController = NativeAdmobController();
    bool b = await FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-3735790035510409~3556832676");
    print("Very epic thing $b");
  }

  Continent get continent {
    String cont =
        Hive.box(MainBloc.METABOX).get("stringContinent", defaultValue: "us");
    switch (cont.toLowerCase()) {
      case "usa":
      case "us":
        return Continent.us;
      case "eu":
        return Continent.eu;
    }
    return Continent.other;
  }

  set continent(Continent cont) {
    String name = "us";
    switch (cont) {
      case Continent.eu:
        name = "eu";
        break;
      case Continent.us:
        name = "us";
        break;
      case Continent.other:
        name = "other";
        break;
    }
    Hive.box(MainBloc.METABOX).put("stringContinent", name);
  }
}

enum Continent { eu, us, other }
