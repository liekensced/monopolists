import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plutopoly/bloc/ad_bloc.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';

class MainHelper {
  static Future main() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (!kIsWeb) {
      var dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
    }
    AdBloc.init();

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
