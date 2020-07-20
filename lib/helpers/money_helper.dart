import '../engine/kernel/main.dart';

String mon(num amount) {
  String icon = Game.data?.currency ?? "£";
  amount ??= 0;

  if (Game.data?.placeCurrencyInFront ?? true) {
    return '$icon${amount.floor()}';
  } else {
    return '${amount.floor()}$icon';
  }
}
