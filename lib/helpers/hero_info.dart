import 'package:flutter/material.dart';

class HeroInfo extends InheritedWidget {
  final String heroBaseTag;

  HeroInfo({
    @required this.heroBaseTag,
    @required Widget child,
    Key key,
  })  : assert(child != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static HeroInfo of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HeroInfo>();
}
