import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plutopoly/engine/ui/game_navigator.dart';
import 'package:uni_links/uni_links.dart';

import '../bloc/main_bloc.dart';
import '../bloc/ui_bloc.dart';
import '../engine/ui/alert.dart';
import '../screens/testing/stock_testing_screen.dart';

class RouteHelper {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (kIsWeb) _parseRoute(settings.name);
    switch (settings.name) {
      case "/stocktest":
        return MaterialPageRoute(builder: (BuildContext context) {
          return StockTestingScreen();
        });
    }
    return null;
  }

  static StreamSubscription _sub;

  static Future<Null> initUniLinks() async {
    if (kIsWeb) return;
    if (_sub != null) return;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      String initialLink = await getInitialLink();
      _parseRoute(initialLink);
    } on PlatformException {
      UIBloc.alerts.add(Alert("Link failed", "Couldn't parse deep link."));
    }
    // Attach a listener to the stream
    _sub = getLinksStream().listen((String link) {
      _parseRoute(link);
    }, onError: (err) {
      UIBloc.alerts.add(Alert("Link failed", "Couldn't parse deep link"));
    });
  }

  static disposeSub() {
    _sub.cancel();
  }

  static _parseRoute(String name) {
    if (name == null || name == "") return;
    try {
      Uri uri = Uri.parse(name);
      Map<String, String> parameters = uri.queryParameters;
      print(parameters);
      if (parameters.containsKey("gamepin") &&
          parameters["gamepin"] != null &&
          parameters["gamepin"] != "") {
        if (MainBloc.player.name == "null") {
          UIBloc.alerts.add(Alert.join(parameters["gamepin"]));
        } else {
          UIBloc.alerts.add(Alert("Join game",
              "Do you want to join this game: " + parameters["gamepin"],
              actions: {
                "join": (BuildContext context) async {
                  Alert alert =
                      await MainBloc.joinOnline(parameters["gamepin"]);
                  Navigator.pop(context);
                  if (Alert.handle(() => alert, context)) {
                    GameNavigator.navigate(context);
                  }
                }
              }));
        }
      }
      if (parameters.containsKey("authcode")) {
        UIBloc.alerts.add(Alert("Change auth code",
            "Do you want to change the auth code to: " + parameters["authcode"],
            actions: {
              "change": (BuildContext context) {
                MainBloc.setCode(parameters["authcode"]);
                Navigator.pop(context);
              }
            }));
        MainBloc.prefbox.put("update", true);
      }
      if (parameters.containsKey("name") && parameters.containsKey("color")) {
        final int code = int.tryParse(parameters["color"]) ?? 0;
        if (code != null) {
          UIBloc.alerts.add(Alert(
              "Change auth code",
              "Do you want to change your account settings to: " +
                  parameters["name"],
              actions: {
                "change": (BuildContext context) {
                  print(code);
                  MainBloc.setPlayer(name: parameters["name"], color: code);
                  Navigator.pop(context);
                }
              }));
          MainBloc.prefbox.put("update", true);
        }
      }
    } catch (e) {
      print("failed");
    }
  }
}
