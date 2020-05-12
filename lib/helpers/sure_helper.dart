import 'package:flutter/material.dart';

void sure(BuildContext context, bool test, String message, Function action) {
  if (test) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text("Are you sure"),
            content: Text(message),
            actions: [
              MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "close",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    action();
                  },
                  child: Text(
                    "yes",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )),
            ]);
      },
    );
  } else {
    action();
  }
}
