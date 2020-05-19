import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';
import 'package:plutopoly/helpers/main_helper.dart';

import 'bloc/main_bloc.dart';
import 'helpers/route_helper.dart';
import 'screens/home/home_screen.dart';

Future<void> main() async {
  await MainHelper.main();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(MainBloc.PREFBOX).listenable(),
        builder: (context, Box box, _) {
          return MaterialApp(
            navigatorKey: UIBloc.navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Plutopoly',
            onGenerateRoute: RouteHelper.onGenerateRoute,
            theme: MainHelper.themeData,
            home: FutureBuilder(
                future: Future.wait([
                  Hive.openBox(MainBloc.GAMESBOX),
                  Hive.openBox(MainBloc.METABOX),
                  Hive.openBox(MainBloc.UPDATEBOX),
                  Hive.openBox(MainBloc.MAPCONFBOX),
                  Hive.openBox(MainBloc.ACCOUNTBOX),
                  Hive.openBox(MainBloc.RECENTBOX),
                  Hive.openBox(MainBloc.MOVEBOX),
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
