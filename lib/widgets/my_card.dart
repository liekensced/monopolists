import 'package:flutter/material.dart';
import 'package:plutopoly/bloc/main_bloc.dart';

import 'eager_inkwell.dart';

class MyCard extends StatelessWidget {
  final String title;
  final bool smallTitle;
  final bool listen;
  final List<Widget> children;
  final Color color;
  final Function onTap;
  final double maxWidth;

  const MyCard({
    Key key,
    this.title,
    this.listen: false,
    @required this.children,
    this.smallTitle: false,
    this.color,
    this.onTap,
    this.maxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (title != null) {
      if (children[0].key != Key("title key")) {
        children.insert(
          0,
          Container(
            key: Key("title key"),
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: !smallTitle
                  ? Theme.of(context).textTheme.headline3
                  : Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.start,
            ),
          ),
        );
      }
    }

    if (listen) {
      return GameListener(
        builder: (BuildContext context, __, _) {
          return buildCenter();
        },
      );
    }
    return buildCenter();
  }

  Widget buildCenter() {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? MainBloc.maxWidth),
        child: Card(
            clipBehavior: Clip.hardEdge, color: color, child: buildCardChild()),
      ),
    );
  }

  Widget buildCardChild() {
    if (onTap == null) {
      return Column(
        children: children,
      );
    }
    return EagerInkWell(
      onTap: onTap,
      child: Column(
        children: children,
      ),
    );
  }
}
