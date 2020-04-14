import 'package:flutter/material.dart';
import 'package:plutopoly/bloc/main_bloc.dart';

class MyCard extends StatelessWidget {
  final String title;
  final bool smallTitle;
  final bool listen;
  final List<Widget> children;
  final Color color;

  const MyCard({
    Key key,
    this.title,
    this.listen: false,
    this.children: const [],
    this.smallTitle: false,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (title != null) {
      children.insert(
        0,
        Container(
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
        constraints: BoxConstraints(maxWidth: MainBloc.maxWidth),
        child: Card(
          color: color,
          child: Column(
            children: children,
          ),
        ),
      ),
    );
  }
}
