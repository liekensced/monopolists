// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preset.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PresetAdapter extends TypeAdapter<Preset> {
  @override
  final typeId = 17;

  @override
  Preset read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Preset()
      ..title = fields[0] as String
      ..description = fields[1] as String
      ..author = fields[2] as String
      ..projectName = fields[3] as String
      ..version = fields[4] as String
      ..data = fields[5] as GameData;
  }

  @override
  void write(BinaryWriter writer, Preset obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.projectName)
      ..writeByte(4)
      ..write(obj.version)
      ..writeByte(5)
      ..write(obj.data);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preset _$PresetFromJson(Map<String, dynamic> json) {
  return Preset()
    ..title = json['title'] as String
    ..description = json['description'] as String
    ..author = json['author'] as String
    ..projectName = json['projectName'] as String
    ..version = json['version'] as String
    ..data = json['data'] == null
        ? null
        : GameData.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$PresetToJson(Preset instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'author': instance.author,
      'projectName': instance.projectName,
      'version': instance.version,
      'data': instance.data?.toJson(),
    };
