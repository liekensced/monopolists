import '../../preset.dart';
import 'land1.dart';
import 'land2.dart';
import 'land3.dart';

class DefaultAdventureData {
  static const List<Map<String, dynamic>> land1 = land1Data;
  static const List<Map<String, dynamic>> land2 = land2Data;
  static Preset get landShuffle {
    Preset preset = Preset.fromJson(land2[0]);
    preset.data.gmap.addAll(
        Preset.fromJson(land2[1]).data.gmap.map((e) => e..idIndex += 100));
    preset.data.settings.startProperties = 5;
    preset.data.settings.interest = 0;
    return preset;
  }

  static const List<Map<String, dynamic>> land3 = land3Data;
}
