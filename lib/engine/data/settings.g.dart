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
      ..startingMoney = fields[5] as int
      ..hackerScreen = fields[6] as bool;
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
      ..write(obj.startingMoney)
      ..writeByte(6)
      ..write(obj.hackerScreen);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) {
  return Settings()
    ..name = json['name'] as String
    ..remotelyBuild = json['remotelyBuild'] as bool
    ..goBonus = json['goBonus'] as int
    ..maxTurnes = json['maxTurnes'] as int
    ..mustAuction = json['mustAuction'] as bool
    ..startingMoney = json['startingMoney'] as int
    ..hackerScreen = json['hackerScreen'] as bool;
}

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'name': instance.name,
      'remotelyBuild': instance.remotelyBuild,
      'goBonus': instance.goBonus,
      'maxTurnes': instance.maxTurnes,
      'mustAuction': instance.mustAuction,
      'startingMoney': instance.startingMoney,
      'hackerScreen': instance.hackerScreen,
    };
