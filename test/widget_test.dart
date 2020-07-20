import 'dart:math';

void main() {
  String hi = "oef";
  double b = 5;
  for (int a in hi.codeUnits) {
    for (int i in List.generate(5, (index) => index)) {
      b += i + a;
      b -= i - a;
    }
    DateTime coolDate = DateTime.parse("2012-02-27 13:27:00");
    DateTime boringDate = DateTime.utc(
        (1014 + b).abs().floor(), (a % 12).abs(), (b % 30).abs().floor());
    b = sqrt(coolDate.difference(boringDate).inDays.abs());
  }
  print((3 * b).floor());
}
