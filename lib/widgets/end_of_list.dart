import 'package:flutter/material.dart';

class EndOfList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.expand_less,
            color: Colors.grey,
          ),
          Text(
            "This is the end",
            style: TextStyle(color: Colors.grey),
          ),
          Container(
            height: 10,
          )
        ],
      ),
    );
  }
}
