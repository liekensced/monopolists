import 'package:flutter/material.dart';

class AnimatedCount extends ImplicitlyAnimatedWidget {
  final int count;
  final TextStyle style;

  AnimatedCount(
      {Key key,
      @required this.count,
      @required Duration duration,
      this.style,
      Curve curve = Curves.linear})
      : super(duration: duration, curve: curve, key: key);

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _AnimatedCountState();
}

class _AnimatedCountState extends AnimatedWidgetBaseState<AnimatedCount> {
  IntTween _count;

  @override
  Widget build(BuildContext context) {
    return new Text(_count.evaluate(animation).toString(), style: widget.style);
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    _count = visitor(_count, widget.count, (dynamic value) {
      return IntTween(begin: value);
    });
  }
}

class AnimatedLinear extends ImplicitlyAnimatedWidget {
  final int count;

  AnimatedLinear(
      {Key key,
      @required this.count,
      @required Duration duration,
      Curve curve = Curves.linear})
      : super(duration: duration, curve: curve, key: key);

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _AnimatedLinearState();
}

class _AnimatedLinearState extends AnimatedWidgetBaseState<AnimatedLinear> {
  IntTween _count;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: _count.evaluate(animation) / 1000,
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    _count = visitor(_count, widget.count, (dynamic value) {
      return IntTween(begin: value);
    });
  }
}
