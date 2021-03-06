import 'package:flutter/material.dart';
import 'package:plutopoly/bloc/game_listener.dart';
import 'package:plutopoly/bloc/ui_bloc.dart';

import 'eager_inkwell.dart';

class MyCard extends StatefulWidget {
  final String title;
  final bool smallTitle;
  final bool listen;
  final bool show;
  final List<Widget> children;
  final Color color;
  final Function onTap;
  final double maxWidth;
  final bool animate;
  final Widget leading;
  final bool seperated;
  final bool shrinkwrap;
  final double elevation;
  final Color shadowColor;
  final bool center;
  final Widget action;
  const MyCard(
      {Key key,
      this.title,
      this.listen: false,
      @required this.children,
      this.smallTitle,
      this.color,
      this.onTap,
      this.maxWidth,
      this.animate: true,
      this.leading,
      this.seperated: false,
      this.show: true,
      this.shrinkwrap: false,
      this.shadowColor,
      this.elevation,
      this.center: true,
      this.action})
      : super(key: key);

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    if (!widget.show) return Container(width: 0);
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
    return Container(
      constraints: BoxConstraints(maxWidth: widget.maxWidth ?? UIBloc.maxWidth),
      child: Stack(
        children: [
          EagerInkWell(
            onTap: widget.onTap,
            child: widget.center
                ? Center(
                    child: buildCard(),
                  )
                : buildCard(),
          ),
          if (widget.action != null)
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Material(
                  color: Theme.of(context).cardColor,
                  child: widget.action,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Card buildCard() {
    return Card(
        shadowColor: widget.shadowColor,
        elevation: widget.elevation,
        clipBehavior: Clip.hardEdge,
        color: widget.color,
        child: Container(
          constraints:
              BoxConstraints(maxWidth: widget.maxWidth ?? UIBloc.maxWidth),
          child: Column(
            mainAxisSize:
                widget.shrinkwrap ? MainAxisSize.min : MainAxisSize.max,
            children: <Widget>[
              widget.title == null
                  ? Container()
                  : Container(
                      key: Key("title key"),
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.title,
                        style:
                            !(widget.smallTitle ?? (widget.title.length > 10))
                                ? Theme.of(context).textTheme.headline3
                                : Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.start,
                      ),
                    ),
              animatedSizeWrapper(),
            ],
          ),
        ));
  }

  Widget animatedSizeWrapper() {
    try {
      if (!widget.animate) return buildCardChild();
      return AnimatedSize(
        vsync: this,
        duration: Duration(milliseconds: 200),
        child: buildCardChild(),
      );
    } catch (e) {
      return ListTile(
        title: Text("Something went wrong :/"),
        trailing: IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    title: Text("Card failed to load"),
                    content: Text(e.toString()),
                    actions: [
                      MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "close",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )),
                      MaterialButton(
                          onPressed: () {
                            _launchURL();
                            Navigator.pop(context);
                          },
                          child: Text(
                            "report",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ))
                    ]);
              },
            );
          },
        ),
      );
    }
  }

  _launchURL() async {
    const url = 'mailto:filoruxonline+bug@gmail.com';
    UIBloc.launchUrl(context, url);
  }

  Widget buildCardChild() {
    return buildColumn();
  }

  Widget buildColumn() {
    return Column(
      children: widget.children,
    );
  }
}
