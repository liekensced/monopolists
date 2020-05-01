// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentAdapter extends TypeAdapter<Recent> {
  @override
  final typeId = 14;

  @override
  Recent read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recent(
      fields[1] as String,
      fields[3] as String,
      fields[4] as int,
      fields[5] as bool,
    )..pin = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, Recent obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.pin)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.owner)
      ..writeByte(4)
      ..write(obj.turn)
      ..writeByte(5)
      ..write(obj.idle);
  }
}
