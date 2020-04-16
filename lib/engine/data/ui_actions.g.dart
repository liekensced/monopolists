// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_actions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
      ..shouldMove = fields[0] as bool
      ..showDealScreen = fields[1] as bool;
  }

  @override
  void write(BinaryWriter writer, UIActionsData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.shouldMove)
      ..writeByte(1)
      ..write(obj.showDealScreen);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UIActionsData _$UIActionsDataFromJson(Map<String, dynamic> json) {
  return UIActionsData()
    ..shouldMove = json['shouldMove'] as bool
    ..showDealScreen = json['showDealScreen'] as bool;
}

Map<String, dynamic> _$UIActionsDataToJson(UIActionsData instance) =>
    <String, dynamic>{
      'shouldMove': instance.shouldMove,
      'showDealScreen': instance.showDealScreen,
    };
