// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_action.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameActionAdapter extends TypeAdapter<GameAction> {
  @override
  final typeId = 25;

  @override
  GameAction read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameAction()
      ..title = fields[0] as String
      ..command = fields[1] as String
      ..alert = fields[3] as String
      ..color = fields[4] as int
      ..allowNext = fields[5] as bool;
  }

  @override
  void write(BinaryWriter writer, GameAction obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.command)
      ..writeByte(3)
      ..write(obj.alert)
      ..writeByte(4)
      ..write(obj.color)
      ..writeByte(5)
      ..write(obj.allowNext);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameAction _$GameActionFromJson(Map json) {
  return GameAction()
    ..title = json['title'] as String
    ..command = json['command'] as String
    ..alert = json['alert'] as String
    ..color = json['color'] as int
    ..allowNext = json['allowNext'] as bool;
}

Map<String, dynamic> _$GameActionToJson(GameAction instance) =>
    <String, dynamic>{
      'title': instance.title,
      'command': instance.command,
      'alert': instance.alert,
      'color': instance.color,
      'allowNext': instance.allowNext,
    };
