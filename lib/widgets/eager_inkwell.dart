import 'package:flutter/material.dart';

class EagerInkWell extends StatelessWidget {
  final Widget child;
  final Function onTap;

  const EagerInkWell({Key key, this.child, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Theme.of(context).accentColor,
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}
