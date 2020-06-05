// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_actions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScreenAdapter extends TypeAdapter<Screen> {
  @override
  final typeId = 13;

  @override
  Screen read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Screen.idle;
      case 1:
        return Screen.move;
      case 2:
        return Screen.active;
      case 3:
        return Screen.parlement;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, Screen obj) {
    switch (obj) {
      case Screen.idle:
        writer.writeByte(0);
        break;
      case Screen.move:
        writer.writeByte(1);
        break;
      case Screen.active:
        writer.writeByte(2);
        break;
      case Screen.parlement:
        writer.writeByte(3);
        break;
    }
  }
}

class UIActionsDataAdapter extends TypeAdapter<UIActionsData> {
  @override
  final typeId = 5;

  @override
  UIActionsData read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UIActionsData()
      ..screenState = fields[0] as Screen
      ..showDealScreen = fields[1] as bool
      ..shouldMove = fields[2] as bool;
  }

  @override
  void write(BinaryWriter writer, UIActionsData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.screenState)
      ..writeByte(1)
      ..write(obj.showDealScreen)
      ..writeByte(2)
      ..write(obj.shouldMove);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UIActionsData _$UIActionsDataFromJson(Map json) {
  return UIActionsData()
    ..screenState = _$enumDecodeNullable(_$ScreenEnumMap, json['screenState'])
    ..showDealScreen = json['showDealScreen'] as bool
    ..shouldMove = json['shouldMove'] as bool;
}

Map<String, dynamic> _$UIActionsDataToJson(UIActionsData instance) =>
    <String, dynamic>{
      'screenState': _$ScreenEnumMap[instance.screenState],
      'showDealScreen': instance.showDealScreen,
      'shouldMove': instance.shouldMove,
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

const _$ScreenEnumMap = {
  Screen.idle: 'idle',
  Screen.move: 'move',
  Screen.active: 'active',
  Screen.parlement: 'parlement',
};
