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
    );
  }

  @override
  void write(BinaryWriter writer, AI obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.type);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AI _$AIFromJson(Map<String, dynamic> json) {
  return AI(
    _$enumDecodeNullable(_$AITypeEnumMap, json['type']),
  );
}

Map<String, dynamic> _$AIToJson(AI instance) => <String, dynamic>{
      'type': _$AITypeEnumMap[instance.type],
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
