import 'package:flutter/material.dart';
import 'package:plutopoly/bloc/main_bloc.dart';

import 'eager_inkwell.dart';

class MyCard extends StatefulWidget {
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
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    if (widget.title != null) {
      widget.children.insert(
        0,
        Container(
          key: Key("title key"),
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            widget.title,
            style: !widget.smallTitle
                ? Theme.of(context).textTheme.headline3
                : Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.start,
          ),
        ),
      );
    }

    if (widget.listen) {
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
        constraints:
            BoxConstraints(maxWidth: widget.maxWidth ?? MainBloc.maxWidth),
        child: Card(
            clipBehavior: Clip.hardEdge,
            color: widget.color,
            child: AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 200),
              child: buildCardChild(),
            )),
      ),
    );
  }

  Widget buildCardChild() {
    if (widget.onTap == null) {
      return Column(
        children: widget.children,
      );
    }
    return EagerInkWell(
      onTap: widget.onTap,
      child: Column(
        children: widget.children,
      ),
    );
  }
}
