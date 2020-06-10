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
    this.subtitle,
    this.showLead: false,
  });
}

class ValueSetting<T> {
  String title;
  String subtitle;
  T value;
  bool showLead = false;
  Function(T) onChanged;
  bool allowNull = false;
  ValueSetting({
    @required this.title,
    @required this.value,
    this.onChanged,
    this.subtitle,
    this.allowNull: false,
    this.showLead: false,
  });
}
