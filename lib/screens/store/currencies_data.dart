import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/helpers/progress_helper.dart';

class CurrencyHelper {
  static const String currencyKey = "selectedCurrency";
  static const String ownedCurrenciesKey = "ownedCurrencies";

  static List<String> get ownedCurrencies =>
      box.get(ownedCurrenciesKey, defaultValue: ["£"]);
  static Currency addCurrency() {
    Currency newCurrency =
        commonCurrencies[Random().nextInt(commonCurrencies.length)];

    ProgressHelper.tickets -= 20;

    if (!ownedCurrencies.contains(newCurrency.name))
      box.put(ownedCurrenciesKey, [...ownedCurrencies, newCurrency.icon]);

    return newCurrency;
  }

  static Box get box => Hive.box(MainBloc.ACCOUNTBOX);
  static Currency get selectedCurrency => commonCurrencies.firstWhere(
      (element) =>
          element.icon ==
          box.get(currencyKey, defaultValue: commonCurrencies.first.icon),
      orElse: () => commonCurrencies.first);
  static set selectedCurrency(Currency value) {
    box.put(currencyKey, value.icon);
  }
}

class Currency {
  final String name;
  final String icon;
  final bool placeCurrencyInFront;
  const Currency({
    @required this.icon,
    @required this.name,
    this.placeCurrencyInFront: true,
  });
}

const List<Currency> commonCurrencies = [
  Currency(icon: "£", name: "pounds"),
  Currency(icon: "€", name: "euro"),
  Currency(icon: "₠", name: "euro currency sign"),
  Currency(icon: "лв", name: "Bulgarian lev"),
  Currency(icon: "₾", name: "Georgian lari"),
  Currency(icon: "₽", name: "Russian ruble"),
  Currency(icon: "₺", name: "Turkish lira"),
  Currency(icon: "₴", name: "Ukrainian hryvna"),
  Currency(icon: "₪", name: "Israeli shekel"),
  Currency(icon: "₦", name: "Nigerian naira"),
  Currency(icon: "\$", name: "dollar"),
  Currency(icon: "৳", name: "Bangladeshi taka"),
  Currency(icon: "¥", name: "yuan"),
  Currency(icon: "₹", name: "rupee"),
  Currency(icon: "₱", name: "Philippine peso"),
  Currency(icon: "₩", name: "South Korean won"),
  Currency(icon: "฿", name: "Thai baht"),
  Currency(icon: "₫", name: "Vietnamese dong"),
  Currency(icon: "د.إ", name: "Emirati dirham"),
  Currency(icon: ".د.م", name: "Moroccan dirham"),
  //emoji
  Currency(icon: "🌀", name: "Hurricanes", placeCurrencyInFront: false),
  Currency(icon: "✨", name: "sparkles", placeCurrencyInFront: false),
  Currency(icon: "❇️", name: "sparkles", placeCurrencyInFront: false),
  Currency(icon: "‼", name: "important money!", placeCurrencyInFront: false),
  Currency(icon: "💲", name: "The real dollar."),
  Currency(
      icon: "©", name: "Copyright everything", placeCurrencyInFront: false),
  Currency(
      icon: "™",
      name: "Build your trademark imperium",
      placeCurrencyInFront: false),
  Currency(icon: "🉐", name: "bargains", placeCurrencyInFront: false),
  Currency(icon: "🔪", name: "Knives", placeCurrencyInFront: false),
  Currency(icon: "🧱", name: "Superb bricks", placeCurrencyInFront: false),
  Currency(
      icon: "🎉",
      name: "Confetti is the real value in life",
      placeCurrencyInFront: false),
  Currency(icon: "💎", name: "gems", placeCurrencyInFront: false),
  Currency(
      icon: "🪕",
      name: "To play some outer wilds music",
      placeCurrencyInFront: false),
  Currency(
      icon: "📱",
      name: "Earn phones on your phone",
      placeCurrencyInFront: false),
  Currency(icon: "📠", name: "Fax machines", placeCurrencyInFront: false),
  Currency(icon: "💰", name: "Money bags", placeCurrencyInFront: false),
  Currency(icon: "💴", name: "cool Yen", placeCurrencyInFront: false),
  Currency(icon: "💵", name: "cool dollar", placeCurrencyInFront: false),
  Currency(icon: "💶", name: "cool euro", placeCurrencyInFront: false),
  Currency(icon: "💷", name: "cool pounds", placeCurrencyInFront: false),
  Currency(icon: "💸", name: "flying", placeCurrencyInFront: false),
  Currency(icon: "💳", name: "magic cards", placeCurrencyInFront: false),
  Currency(icon: "🧾", name: "reverse psychology", placeCurrencyInFront: false),
  Currency(icon: "🖊", name: "pens", placeCurrencyInFront: false),
  Currency(icon: "🧹", name: "Let's fly", placeCurrencyInFront: false),
  Currency(icon: "🔑", name: "keys to nowhere", placeCurrencyInFront: false),
  Currency(icon: "🗿", name: "Like rai stones"),
  Currency(icon: "🌋", name: "volcanos", placeCurrencyInFront: false),
  Currency(icon: "🏨", name: "hotels", placeCurrencyInFront: false),
  Currency(icon: "🏰", name: "castles", placeCurrencyInFront: false),
  Currency(icon: "🎡", name: "Ferres wheels", placeCurrencyInFront: false),
  Currency(icon: "🎢", name: "Roller coasters", placeCurrencyInFront: false),
  Currency(icon: "✈", name: "planes", placeCurrencyInFront: false),
  Currency(icon: "🛰", name: "satellites", placeCurrencyInFront: false),
  Currency(icon: "🚂", name: "Trains", placeCurrencyInFront: false),
  Currency(icon: "🌌", name: "Milky ways", placeCurrencyInFront: false),
  Currency(icon: "🪐", name: "Planets", placeCurrencyInFront: false),
  Currency(icon: "🌕", name: "Moons", placeCurrencyInFront: false),
  Currency(icon: "☕", name: "Coffee", placeCurrencyInFront: false),
  Currency(icon: "🧲", name: "How do they work?", placeCurrencyInFront: false),
];
