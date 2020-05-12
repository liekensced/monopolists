import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:plutopoly/engine/extensions/bank/bank.dart';
import 'package:plutopoly/engine/extensions/bank/stock_extension.dart';
import 'package:plutopoly/engine/extensions/extension_data.dart';
import 'package:plutopoly/engine/extensions/jurisdiction.dart';

part 'extensions.g.dart';

@HiveType(typeId: 6)
enum Extension {
  @HiveField(0)
  bank,
  @HiveField(1)
  transportation,

  @HiveField(2)
  legislation,
  @HiveField(3)
  stock
}

class ExtensionsMap {
  static Map<Extension, ExtensionData> call() {
    return {
      Extension.bank: BankExtension.data,
      Extension.stock: StockExtension.data,
      Extension.legislation: LegislationExtension.data,
      Extension.transportation: ExtensionData(
          ext: Extension.transportation,
          name: "Transportation",
          description: "Adds transportation",
          icon: ({double size: 30}) => Icon(
                Icons.train,
                size: size,
              ),
          getInfo: () => [])
    };
  }
}
