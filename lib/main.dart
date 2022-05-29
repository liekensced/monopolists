import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
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
          SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(statusBarColor: MainHelper.primaryColor));
          return OverlaySupport(
            child: MaterialApp(
              navigatorKey: UIBloc.navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'Plutopoly',
              onGenerateRoute: RouteHelper.onGenerateRoute,
              theme: MainHelper.themeData,
              home: HomeWidget(),
            ),
          );
        });
  }
}

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (MainBloc.initialized) return MyHomePage();
    return FutureBuilder(
        future: MainHelper.openBoxes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.error != null) {
              print(snapshot.error);

              return Scaffold(body: DataErrorScreen(error: snapshot.error));
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
                    Text(messages[Random().nextInt(messages.length - 1)]),
                  ],
                ),
              ),
            );
          }
        });
  }
}

class DataErrorScreen extends StatelessWidget {
  final Object error;
  const DataErrorScreen({
    Key key,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Something went wrong :/\n\nIf this keeps happening, reset all app data in settings.',
          textAlign: TextAlign.center,
        ),
        error is DataError ? hiveDataErrorTile(error) : Container()
      ],
    ));
  }

  static Widget hiveDataErrorTile(DataError err) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: ListTile(
        title: Text(err.title),
        subtitle: Text(err.body),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            Hive.deleteBoxFromDisk(err.box);
            MainBloc.prefbox.put("update", true);
          },
        ),
      ),
    );
  }
}

List<String> messages = const [
  "Looking at flowers",
  "Looking at flowers",
  "Looking at flowers",
  "Starting up",
  "Starting up",
  "Starting up",
  "Starting up",
  "Wash your hands",
  "Very cool text",
  "Je ne sais pas quoi dire",
  "jag är trött",
  "Starting a hive",
  "gfyn gb gur zbba",
  "gfyn gb gur zbba",
  "Future.wait(Duration(seconds:2))",
  "This is fine.",
  "easter egg",
];
