import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../bloc/ad_bloc.dart';
import '../bloc/main_bloc.dart';
import '../bloc/recent.dart';
import '../bloc/ui_bloc.dart';
import '../engine/ai/ai.dart';
import '../engine/ai/ai_type.dart';
import '../engine/data/deal_data.dart';
import '../engine/data/extensions.dart';
import '../engine/data/game_action.dart';
import '../engine/data/main_data.dart';
import '../engine/data/map.dart';
import '../engine/data/player.dart';
import '../engine/data/settings.dart';
import '../engine/data/tip.dart';
import '../engine/data/ui_actions.dart';
import '../engine/data/update_info.dart';
import '../engine/extensions/bank/data/bank_data.dart';
import '../engine/extensions/bank/data/loan.dart';
import '../engine/extensions/bank/data/stock.dart';
import '../store/adventure/adventure_data.dart';
import '../store/preset.dart';

class MainHelper {
  static Future main() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (!kIsWeb) {
      var dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
    }
    AdBloc.init();

    Hive.registerAdapter(GameDataAdapter());
    Hive.registerAdapter(TileAdapter());
    Hive.registerAdapter(TileTypeAdapter());
    Hive.registerAdapter(PlayerAdapter());
    Hive.registerAdapter(SettingsAdapter());
    Hive.registerAdapter(UIActionsDataAdapter());
    Hive.registerAdapter(ExtensionAdapter());
    Hive.registerAdapter(UpdateInfoAdapter());
    Hive.registerAdapter(DealDataAdapter());
    Hive.registerAdapter(MapConfigurationAdapter());
    Hive.registerAdapter(BankDataAdapter());
    Hive.registerAdapter(ContractAdapter());
    Hive.registerAdapter(StockAdapter());
    Hive.registerAdapter(RecentAdapter());
    Hive.registerAdapter(AITypeAdapter());
    Hive.registerAdapter(ScreenAdapter());
    Hive.registerAdapter(AIAdapter());
    Hive.registerAdapter(PresetAdapter());
    Hive.registerAdapter(InfoAdapter());
    Hive.registerAdapter(InfoTypeAdapter());
    Hive.registerAdapter(GameActionAdapter());
    Hive.registerAdapter(LevelProgressAdapter());
    Hive.registerAdapter(AISettingsAdapter());
    Hive.registerAdapter(DiceTypeAdapter());
    await Hive.openBox(MainBloc.PREFBOX);

    return null;
  }

  static ThemeData get themeData => ThemeData(
      brightness: UIBloc.darkMode ? Brightness.dark : Brightness.light,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        },
      ),
      primaryColor: primaryColor,
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(),
      ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColor));
  static Color get primaryColor {
    Color savedColor = Color(
        Hive.box(MainBloc.PREFBOX).get("primaryColor") ?? Colors.teal.value);
    if (savedColor.alpha != 0xFF) {
      Hive.box(MainBloc.PREFBOX).delete("primaryColor");
      return Colors.teal;
    }
    return savedColor;
  }

  static Color get accentColor {
    Color savedColor = Color(
        Hive.box(MainBloc.PREFBOX).get("accentColor") ?? Colors.cyan.value);
    if (savedColor.alpha != 0xFF) {
      Hive.box(MainBloc.PREFBOX).delete("accentColor");
      return Colors.cyan;
    }
    return savedColor;
  }

  static openBoxes() async {
    await openBox(MainBloc.METABOX, "Some meta data failed to load in");
    await openBox(
        MainBloc.UPDATEBOX,
        "Some data failed to load in"
        "Press delete to fix.");
    await openBox(MainBloc.MAPCONFBOX, "Map configuration data failed");
    await openBox(MainBloc.ACCOUNTBOX, "Account data failed",
        "Your account data (name, color, authcode) failed to load in. Do you want to delete the data?");
    await openBox(MainBloc.RECENTBOX, "Recents data failed",
        "Your recent online keys data failed to load in. Do you want to delete the data?");
    await openBox(MainBloc.MOVEBOX, "Move preferences data failed");
    await openBox(MainBloc.STATBOX, "Statistics Data failed",
        "The statistics data failed to load in. Do you want to delete the data?");
    await openBox(MainBloc.GAMESBOX, "Game Data failed",
        "The games data failed to load in. This contains your open games. Do you want to delete the data?");

    try {
      await Hive.openBox<Preset>(MainBloc.PRESETSBOX);
    } catch (e) {
      throw DataError(
          "Presets failed",
          "The presets data failed to load in. Do you want to delete the data?",
          MainBloc.PRESETSBOX);
    }
    try {
      await Hive.openBox<GameData>(MainBloc.PRESETGAMESBOX);
    } catch (e) {
      throw DataError(
          "Preset Games Data failed",
          "The games data from presets failed to load in. This contains your open games. Do you want to delete the data?",
          MainBloc.PRESETGAMESBOX);
    }
  }
}

Future openBox(String box, String title,
    [String content = "Do you want to delete the data?"]) async {
  try {
    await Hive.openBox(box);
  } catch (e) {
    throw DataError(title, content, box);
  }
}

class DataError {
  String title;
  String body;
  String box;
  DataError(
    this.title,
    this.body,
    this.box,
  );
}
