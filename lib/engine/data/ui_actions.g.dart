// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_actions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UIActionsData _$UIActionsDataFromJson(Map<String, dynamic> json) {
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
