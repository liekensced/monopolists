import 'package:flutter/material.dart';

class AdventureScreen extends StatefulWidget {
  @override
  _AdventureScreenState createState() => _AdventureScreenState();
}

class _AdventureScreenState extends State<AdventureScreen> {
  var top = 0.0;
  var top2 = 0.0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("adventure"),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          reverse: true,
          children: [
            Image.asset(
              "assets/map.png",
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 1.5,
            ),
          ],
        ),
      ),
    );
  }
}
