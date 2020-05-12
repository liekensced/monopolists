import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/extensions.dart';
import '../../data/tip.dart';
import '../extension_data.dart';

class StockExtension {
  static ExtensionData data = ExtensionData(
      ext: Extension.stock,
      name: "Stock 1",
      description:
          "This extension adds a global stock index based on in-game parameters.",
      icon: ({double size: 30}) {
        return FaIcon(
          FontAwesomeIcons.chartLine,
          size: size,
        );
      },
      getInfo: () {
        return [Info("World Stock", "__WS__", InfoType.rule)];
      },
      dependencies: [Extension.bank]);
}
