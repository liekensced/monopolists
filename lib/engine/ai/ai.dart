import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import 'package:plutopoly/engine/ai/ai_type.dart';

part 'ai.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 16)
class AI {
  @HiveField(0)
  AIType type;
  @HiveField(1)
  @JsonKey(name: "aiSettings")
  AISettings _aiSettings;
  @HiveField(2)
  String description;

  AISettings get aiSettings {
    if (_aiSettings == null) return AISettings();
    if (_aiSettings.chances.length < defaultChances.length) {
      _aiSettings.chances = defaultChances;
    }
    return _aiSettings;
  }

  AI(this.type, {bool hard = false}) {
    if (hard) {
      _aiSettings = AISettings.hard();
      description = "Hard BOT";
    }
  }

  AI.player() {
    type = AIType.player;
  }

  factory AI.fromJson(Map json) => _$AIFromJson(json);
  Map<String, dynamic> toJson() => _$AIToJson(this);
}

const List<double> defaultChances = [
  0.9,
  0.8,
  0,
  0.3,
  1,
];

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 20)
class AISettings {
  @HiveField(0)

  /// 0 Get pot, 1 buy land, 2 buy property offset, 3 build house break chance, 4 remotely build house factor
  List<double> chances = defaultChances;

  @HiveField(1)
  double dealFactor = 1;
  @HiveField(2)
  bool smart = false;
  @HiveField(3)
  bool canTrade = true;
  @HiveField(4)
  bool idle = false;

  AISettings();
  AISettings.hard() {
    chances = [
      1,
      0.9,
      0,
      0.2,
      1,
    ];
    smart = true;
  }

  factory AISettings.fromJson(Map json) => _$AISettingsFromJson(json);
  Map<String, dynamic> toJson() => _$AISettingsToJson(this);
}
