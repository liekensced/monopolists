// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final typeId = 4;

  @override
  Settings read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings()
      ..name = fields[0] as String
      ..remotelyBuild = fields[1] as bool
      ..goBonus = fields[2] as int
      ..maxTurnes = fields[3] as int
      ..mustAuction = fields[4] as bool
      ..allowOneDice = fields[5] as bool
      ..dontBuyFirstRound = fields[6] as bool;
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.remotelyBuild)
      ..writeByte(2)
      ..write(obj.goBonus)
      ..writeByte(3)
      ..write(obj.maxTurnes)
      ..writeByte(4)
      ..write(obj.mustAuction)
      ..writeByte(5)
      ..write(obj.allowOneDice)
      ..writeByte(6)
      ..write(obj.dontBuyFirstRound);
  }
}
