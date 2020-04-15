import 'package:flutter/material.dart';

class SlideFab extends StatefulWidget {
  final bool hide;
  final String title;
  final Function onTap;

  const SlideFab({
    Key key,
    @required this.hide,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  @override
  _SlideFabState createState() => _SlideFabState();
}

class _SlideFabState extends State<SlideFab>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuad,
    ));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hide) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    return SlideTransition(
        position: _offsetAnimation,
        child: AbsorbPointer(
          absorbing: widget.hide,
          child: FloatingActionButton.extended(
            backgroundColor: Theme.of(context).accentColor,
            label: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Center(
                    child: Text(
                  widget.title,
                  style: TextStyle(color: Colors.white),
                ))),
            onPressed: widget.onTap,
          ),
        ));
  }
}
