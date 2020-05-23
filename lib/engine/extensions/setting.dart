import 'package:flutter/cupertino.dart';

class Setting<T> {
  String title;
  Function(T) onChanged;
  String subtitle = "";
  T Function() value;
  bool showLead = false;
  Setting({
    @required this.title,
    @required this.onChanged,
    @required this.value,
    this.subtitle = "",
    this.showLead: false,
  });
}
