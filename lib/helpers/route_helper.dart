import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uni_links/uni_links.dart';

import '../bloc/main_bloc.dart';
import '../bloc/ui_bloc.dart';
import '../engine/data/extensions.dart';
import '../engine/ui/alert.dart';
import '../screens/extension_screen.dart';
import '../screens/home/recent_card.dart';
import '../screens/start/players.dart';
import '../screens/testing/stock_testing_screen.dart';

class RouteHelper {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    Uri uri = Uri.parse(settings.name);
    if (kIsWeb) _parseRoute(uri);
    switch (uri.path) {
      case "/stocktest":
        return MaterialPageRoute(builder: (BuildContext context) {
          return StockTestingScreen();
        });
      case "/extensions":
        String extString = uri.queryParameters["ext"];
        Extension ext =
            Extension.values.firstWhere((e) => e.toString() == extString);
        if (ext != null) {
          return MaterialPageRoute(builder: (BuildContext context) {
            return ExtensionScreen(
              ext: ext,
            );
          });
        }
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
      if (initialLink != null) {
        _parseRoute(Uri.parse(initialLink));
      }
    } catch (e) {
      UIBloc.alerts.add(Alert("Link failed", "Couldn't parse deep link."));
      MainBloc.prefbox.put("update", true);
    }
    // Attach a listener to the stream
    _sub = getLinksStream().listen((String link) {
      _parseRoute(Uri.parse(link));
    }, onError: (err) {
      UIBloc.alerts.add(Alert("Link failed", "Couldn't parse deep link"));
      MainBloc.prefbox.put("update", true);
    });
  }

  static disposeSub() {
    _sub.cancel();
  }

  static _parseRoute(Uri uri) async {
    try {
      Map<String, String> parameters = uri.queryParameters;
      print("\n Parsing route! \n");
      print(parameters);
      bool force = parameters["force"] == "true";
      if (parameters.containsKey("authcode")) {
        if (force) {
          MainBloc.setCode(parameters["authcode"]);
        } else {
          UIBloc.alerts.add(Alert(
              "Change auth code",
              "Do you want to change the auth code to: " +
                  parameters["authcode"],
              actions: {
                "change": (BuildContext context) {
                  MainBloc.setCode(parameters["authcode"]);
                  Navigator.pop(context);
                }
              }));
          MainBloc.prefbox.put("update", true);
        }
      }
      if (parameters.containsKey("name") && parameters.containsKey("color")) {
        final int colorCode = int.tryParse(parameters["color"].trim()) ?? 0;
        if (force) {
          MainBloc.setPlayer(name: parameters["name"], color: colorCode);
        } else {
          if (colorCode != null) {
            UIBloc.alerts.add(Alert(
                "Update account",
                "Do you want to change your account settings to: " +
                    parameters["name"],
                actions: {
                  "change": (BuildContext context) {
                    MainBloc.setPlayer(
                        name: parameters["name"], color: colorCode);
                    Navigator.pop(context);
                  }
                }));
            MainBloc.prefbox.put("update", true);
          }
        }
      }
      if (parameters.containsKey("gamepin") &&
          parameters["gamepin"] != null &&
          parameters["gamepin"] != "") {
        await Hive.openBox(MainBloc.ACCOUNTBOX);
        if (MainBloc.player.name == "null") {
          UIBloc.alerts.add(Alert.join(parameters["gamepin"]));
          MainBloc.prefbox.put("update", true);
        } else {
          UIBloc.alerts.add(Alert("Join game",
              "Do you want to join this game: " + parameters["gamepin"],
              actions: {
                "join": (BuildContext context) async {
                  RecentCard.joinOnline(context, parameters["gamepin"]);
                }
              }));
          MainBloc.prefbox.put("update", true);
        }
      }
      if (parameters.containsKey("msg")) {
        UIBloc.alerts.add(Alert(
          parameters["title"] ?? "Message",
          parameters["msg"],
          type: DialogType.INFO,
        ));
        MainBloc.prefbox.put("update", true);
      }
      if (parameters["reset"]?.toLowerCase() == "true") {
        MainBloc.prefbox.clear();
      }
      if (parameters["rainbow"]?.toLowerCase() == "true") {
        print("started timer");
        Timer.periodic(Duration(seconds: 1), (Timer t) {
          MainBloc.prefbox.put("primaryColor", ColorHelper().randomColor);
        });
      }
      if (parameters["spell"]?.toLowerCase() == "aparecium") {
        UIBloc.alerts
            .add(Alert("", "I solemnly swear that I am up to no good"));
        MainBloc.prefbox.put("update", true);
      }
      if (parameters["name"]?.toLowerCase() == "stefan") {
        UIBloc.alerts
            .add(Alert("Oh hi there", "I totally did all your tasks..."));
        MainBloc.prefbox.put("update", true);
      }
      if (parameters["broken"]?.toLowerCase() == "true") {
        Alert alert() {
          return Alert("Objection", "I am not broken!",
              closable: false,
              actions: {
                "close": (BuildContext context) {
                  Alert.handle(alert, context);
                }
              });
        }

        UIBloc.alerts.add(alert());

        MainBloc.prefbox.put("update", true);
      }
    } catch (e) {
      print("failed to parse url $e");
    }
  }
}
