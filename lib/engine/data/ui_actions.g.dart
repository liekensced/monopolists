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
    return UIActionsData()..shouldMove = fields[0] as bool;
  }

  @override
  void write(BinaryWriter writer, UIActionsData obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.shouldMove);
  }
}
