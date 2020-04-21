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
  final bool animate;

  const MyCard({
    Key key,
    this.title,
    this.listen: false,
    @required this.children,
    this.smallTitle: false,
    this.color,
    this.onTap,
    this.maxWidth,
    this.animate: true,
  }) : super(key: key);

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
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
          child: EagerInkWell(
            onTap: widget.onTap,
            child: Card(
                clipBehavior: Clip.hardEdge,
                color: widget.color,
                child: Column(
                  children: <Widget>[
                    widget.title == null
                        ? Container()
                        : Container(
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
                    animatedSizeWrapper(),
                  ],
                )),
          )),
    );
  }

  Widget animatedSizeWrapper() {
    if (!widget.animate) return buildCardChild();
    return AnimatedSize(
      vsync: this,
      duration: Duration(milliseconds: 200),
      child: buildCardChild(),
    );
  }

  Widget buildCardChild() {
    return buildColumn();
  }

  Widget buildColumn() {
    return Column(
      children: widget.children,
    );
  }

  Widget buildTitle() {
    if (widget.title != null) {
      return Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          widget.title,
          style: !widget.smallTitle
              ? Theme.of(context).textTheme.headline3
              : Theme.of(context).textTheme.headline4,
          textAlign: TextAlign.start,
        ),
      );
    }
    return Container();
  }
}
