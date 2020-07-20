// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AIAdapter extends TypeAdapter<AI> {
  @override
  final typeId = 16;

  @override
  AI read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AI(
      fields[0] as AIType,
    )
      ..aiSettingsCache = fields[1] as AISettings
      ..description = fields[2] as String;
  }

  @override
  void write(BinaryWriter writer, AI obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.aiSettingsCache)
      ..writeByte(2)
      ..write(obj.description);
  }
}

class AISettingsAdapter extends TypeAdapter<AISettings> {
  @override
  final typeId = 20;

  @override
  AISettings read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AISettings()
      ..chances = (fields[0] as List)?.cast<double>()
      ..dealFactor = fields[1] as double
      ..smart = fields[2] as bool
      ..canTrade = fields[3] as bool
      ..idle = fields[4] as bool
      ..moneyFactor = fields[5] as double;
  }

  @override
  void write(BinaryWriter writer, AISettings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.chances)
      ..writeByte(1)
      ..write(obj.dealFactor)
      ..writeByte(2)
      ..write(obj.smart)
      ..writeByte(3)
      ..write(obj.canTrade)
      ..writeByte(4)
      ..write(obj.idle)
      ..writeByte(5)
      ..write(obj.moneyFactor);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AI _$AIFromJson(Map json) {
  return AI(
    _$enumDecodeNullable(_$AITypeEnumMap, json['type']),
  )
    ..aiSettingsCache = json['aiSettingsCache'] == null
        ? null
        : AISettings.fromJson(json['aiSettingsCache'] as Map)
    ..description = json['description'] as String;
}

Map<String, dynamic> _$AIToJson(AI instance) => <String, dynamic>{
      'type': _$AITypeEnumMap[instance.type],
      'aiSettingsCache': instance.aiSettingsCache?.toJson(),
      'description': instance.description,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$AITypeEnumMap = {
  AIType.player: 'player',
  AIType.normal: 'normal',
};

AISettings _$AISettingsFromJson(Map json) {
  return AISettings()
    ..chances =
        (json['chances'] as List)?.map((e) => (e as num)?.toDouble())?.toList()
    ..dealFactor = (json['dealFactor'] as num)?.toDouble()
    ..smart = json['smart'] as bool
    ..canTrade = json['canTrade'] as bool
    ..idle = json['idle'] as bool
    ..moneyFactor = (json['moneyFactor'] as num)?.toDouble();
}

Map<String, dynamic> _$AISettingsToJson(AISettings instance) =>
    <String, dynamic>{
      'chances': instance.chances,
      'dealFactor': instance.dealFactor,
      'smart': instance.smart,
      'canTrade': instance.canTrade,
      'idle': instance.idle,
      'moneyFactor': instance.moneyFactor,
    };
