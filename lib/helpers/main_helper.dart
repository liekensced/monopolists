import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plutopoly/bloc/ad_bloc.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/bloc/recent.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/engine/ai/ai.dart';
import 'package:plutopoly/engine/ai/ai_type.dart';
import 'package:plutopoly/engine/data/deal_data.dart';
import 'package:plutopoly/engine/data/extensions.dart';
import 'package:plutopoly/engine/data/info.dart';
import 'package:plutopoly/engine/data/main_data.dart';
import 'package:plutopoly/engine/data/map.dart';
import 'package:plutopoly/engine/data/player.dart';
import 'package:plutopoly/engine/data/settings.dart';
import 'package:plutopoly/engine/data/ui_actions.dart';
import 'package:plutopoly/engine/extensions/bank/data/bank_data.dart';
import 'package:plutopoly/engine/extensions/bank/data/loan.dart';
import 'package:plutopoly/engine/extensions/bank/data/stock.dart';

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
    return Color(
        Hive.box(MainBloc.PREFBOX).get("primaryColor") ?? Colors.teal.value);
  }

  static Color get accentColor {
    return Color(
        Hive.box(MainBloc.PREFBOX).get("accentColor") ?? Colors.cyan.value);
  }
}
