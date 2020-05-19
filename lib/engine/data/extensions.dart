import 'package:hive/hive.dart';
import 'package:plutopoly/engine/extensions/bank/bank.dart';
import 'package:plutopoly/engine/extensions/bank/stock_extension.dart';
import 'package:plutopoly/engine/extensions/extension_data.dart';
import 'package:plutopoly/engine/extensions/jurisdiction.dart';
import 'package:plutopoly/engine/extensions/lake_drain_extension.dart';
import 'package:plutopoly/engine/extensions/transportation.dart';
import 'package:plutopoly/engine/kernel/main.dart';

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
  stock,
  @HiveField(4)
  drainTheLake
}

class ExtensionsMap {
  static Map<Extension, ExtensionData> call() {
    return {
      Extension.bank: BankExtension.data,
      Extension.stock: StockExtension.data,
      Extension.legislation: LegislationExtension.data,
      Extension.transportation: TransportationBloc.data,
      Extension.drainTheLake: LakeDrain.data,
    };
  }

  static event(Function Function(ExtensionData data) func) {
    Game.data.extensions.forEach((Extension ext) {
      Function f = func(ExtensionsMap.call()[ext]);
      if (f != null) f();
    });
  }
}
