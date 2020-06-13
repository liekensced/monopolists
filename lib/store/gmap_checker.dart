import 'package:plutopoly/engine/data/map.dart';
import 'package:plutopoly/engine/ui/alert.dart';

class GmapChecker {
  static call(List<Tile> map) {
    List<String> usedIds = [];
    map.forEach((Tile element) {
      if (usedIds.contains(element.id)) {
        throw Alert(
            "No unique id", "There are two tiles with the same id:\n$element");
      }
      usedIds.add(element.id);
    });
  }
}
