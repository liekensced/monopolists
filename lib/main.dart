import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plutopoly/bloc/recent.dart';
import 'package:plutopoly/engine/ai/ai_type.dart';

import 'bloc/main_bloc.dart';
import 'engine/data/deal_data.dart';
import 'engine/data/extensions.dart';
import 'engine/data/info.dart';
import 'engine/data/main.dart';
import 'engine/data/map.dart';
import 'engine/data/player.dart';
import 'engine/data/settings.dart';
import 'engine/data/ui_actions.dart';
import 'engine/extensions/bank/data/bank_data.dart';
import 'engine/extensions/bank/data/loan.dart';
import 'engine/extensions/bank/data/stock.dart';
import 'screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.teal));
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
  await Hive.openBox(MainBloc.PREFBOX);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(MainBloc.PREFBOX).listenable(),
        builder: (context, Box box, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Plutopoly',
            theme: ThemeData(
                brightness: Hive.box(MainBloc.PREFBOX)
                        .get("boolDark", defaultValue: true)
                    ? Brightness.dark
                    : Brightness.light,
                primaryColor: Colors.teal,
                accentColor: Colors.cyan,
                inputDecorationTheme: InputDecorationTheme(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(),
                )),
            home: FutureBuilder(
                future: Future.wait([
                  Hive.openBox(MainBloc.GAMESBOX),
                  Hive.openBox(MainBloc.METABOX),
                  Hive.openBox(MainBloc.UPDATEBOX),
                  Hive.openBox(MainBloc.MAPCONFBOX),
                  Hive.openBox(MainBloc.ACCOUNTBOX),
                  Hive.openBox(MainBloc.RECENTBOX),
                ]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.error != null) {
                      print(snapshot.error);
                      return Scaffold(
                        body: Center(
                          child: Text(
                            'Something went wrong :/\n\nIf this keeps happening, reset all app data in settings.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      MainBloc.initBloc(context);
                      return MyHomePage();
                    }
                  } else {
                    return Scaffold(
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            Text(messages[
                                Random().nextInt(messages.length - 1)]),
                          ],
                        ),
                      ),
                    );
                  }
                }),
          );
        });
  }
}

List<String> messages = const [
  "Looking at flowers",
  "Looking at flowers",
  "Looking at flowers",
  "Starting up",
  "Starting up",
  "Starting up",
  "Wash your hands",
  "Very cool text",
  "Je ne sais pas quoi dire",
  "jag är trött",
  "gfyn gb gur zbba",
  "Starting a hive",
  "Future.wait(Duration(seconds:2))",
  "This is fine.",
  "easter egg",
  "and that's the way the news goes"
];
