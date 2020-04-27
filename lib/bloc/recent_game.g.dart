// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_game.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentGameAdapter extends TypeAdapter<RecentGame> {
  @override
  final typeId = 13;

  @override
  RecentGame read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentGame()
      ..pin = fields[0] as String
      ..name = fields[1] as String
      ..owner = fields[2] as String;
  }

  @override
  void write(BinaryWriter writer, RecentGame obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.pin)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.owner);
  }
}
