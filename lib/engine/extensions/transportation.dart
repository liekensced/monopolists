import 'package:plutopoly/engine/data/extensions.dart';
import 'package:plutopoly/engine/data/map.dart';
import 'package:plutopoly/engine/kernel/core_actions.dart';
import 'package:plutopoly/engine/kernel/main.dart';
import 'package:plutopoly/engine/ui/alert.dart';

class TransportationBloc {
  static bool get active =>
      Game.data.extensions.contains(Extension.transportation);
  static Alert move(Tile destination) {
    Tile tile = Game.data.tile;
    int price = tile.transportationPrice;
    if (tile.owner != Game.data.player) {
      if (price == null)
        return Alert("No price specified",
            "Ask the other player to add a transportation price.");
      Alert alert = Game.act.pay(
        PayType.pay,
        price,
        receiver: tile.owner.index,
        shouldSave: false,
      );
      if (alert != null) return alert;
    }
    Game.jump(tile.mapIndex, true, true);
    return null;
  }
}
