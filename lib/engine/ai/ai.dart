import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import 'package:plutopoly/engine/ai/ai_type.dart';

part 'ai.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 16)
class AI {
  @HiveField(0)
  AIType type;

  AI(this.type);

  AI.player() {
    type = AIType.player;
  }

  factory AI.fromJson(Map json) => _$AIFromJson(json);
  Map<String, dynamic> toJson() => _$AIToJson(this);
}
