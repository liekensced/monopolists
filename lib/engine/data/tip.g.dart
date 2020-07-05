// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tip.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InfoTypeAdapter extends TypeAdapter<InfoType> {
  @override
  final typeId = 19;

  @override
  InfoType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InfoType.rule;
      case 1:
        return InfoType.alert;
      case 2:
        return InfoType.tip;
      case 3:
        return InfoType.setting;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, InfoType obj) {
    switch (obj) {
      case InfoType.rule:
        writer.writeByte(0);
        break;
      case InfoType.alert:
        writer.writeByte(1);
        break;
      case InfoType.tip:
        writer.writeByte(2);
        break;
      case InfoType.setting:
        writer.writeByte(3);
        break;
    }
  }
}

class InfoAdapter extends TypeAdapter<Info> {
  @override
  final typeId = 18;

  @override
  Info read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Info(
      fields[0] as String,
      fields[1] as String,
      fields[2] as InfoType,
      color: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Info obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.color);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Info _$InfoFromJson(Map json) {
  return Info(
    json['title'] as String,
    json['content'] as String,
    _$enumDecodeNullable(_$InfoTypeEnumMap, json['type']),
    color: json['color'] as int,
  );
}

Map<String, dynamic> _$InfoToJson(Info instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  writeNotNull('content', instance.content);
  writeNotNull('type', _$InfoTypeEnumMap[instance.type]);
  writeNotNull('color', instance.color);
  return val;
}

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

const _$InfoTypeEnumMap = {
  InfoType.rule: 'rule',
  InfoType.alert: 'alert',
  InfoType.tip: 'tip',
  InfoType.setting: 'setting',
};
