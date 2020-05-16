import 'package:plutopoly/engine/kernel/main.dart';

import '../bloc/main_bloc.dart';

class OnlineExtensions {
  static Map<String, dynamic> extensionsData = {};

  static setData(Map<String, dynamic> data) {
    if (data == null) return;
    extensionsData = data["bots"] ?? {};
  }

  static List<Bot> getBots() {
    if (extensionsData == {} || extensionsData == null || !MainBloc.online)
      return [];
    List<Bot> bots = [];
    extensionsData.forEach((key, value) {
      Map<String, dynamic> meta = value["meta"] ?? {};
      List<String> split = key.split(".");
      try {
        bots.add(Bot(key)
          ..author = meta["author"] ?? split[0]
          ..name = meta["name"] ?? split[1]
          ..description = meta["description"] ?? "unknown"
          ..website = meta["website"] ?? null
          ..active = meta["active"] ?? true
          ..version = meta["version"] ?? "");
      } catch (e) {
        print("couldn't parse bot data \n$e");
      }
    });
    return bots;
  }

  static disableBot(Bot bot) {
    if (extensionsData[bot.projectName]["meta"] == null) return;
    extensionsData[bot.projectName]["meta"]["active"] = false;
    MainBloc.save(Game.data, bots: extensionsData);
  }
}

class Bot {
  String projectName;
  String author;
  String name;
  String description;
  String website;
  bool active;
  String version;
  Bot(this.projectName);
}
