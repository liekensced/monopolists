import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plutopoly/engine/data/tip.dart';
import 'package:plutopoly/store/preset.dart';

import '../bloc/ad_bloc.dart';
import '../bloc/main_bloc.dart';
import '../bloc/recent.dart';
import '../bloc/ui_bloc.dart';
import '../engine/ai/ai.dart';
import '../engine/ai/ai_type.dart';
import '../engine/data/deal_data.dart';
import '../engine/data/extensions.dart';
import '../engine/data/update_info.dart';
import '../engine/data/main_data.dart';
import '../engine/data/map.dart';
import '../engine/data/player.dart';
import '../engine/data/settings.dart';
import '../engine/data/ui_actions.dart';
import '../engine/extensions/bank/data/bank_data.dart';
import '../engine/extensions/bank/data/loan.dart';
import '../engine/extensions/bank/data/stock.dart';

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
    Hive.registerAdapter(AISettingsAdapter());
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
      accentColor: accentColor,
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(),
      ));
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
}
