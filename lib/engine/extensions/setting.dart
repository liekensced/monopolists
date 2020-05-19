import 'package:flutter/cupertino.dart';

class Setting<T> {
  String title;
  Function(T) onChanged;
  String subtitle = "";
  T Function() value;
  Setting({
    @required this.title,
    @required this.onChanged,
    @required this.value,
    this.subtitle = "",
  });
}
