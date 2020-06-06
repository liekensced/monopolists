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
    return Preset(
      projectName: fields[3] as String,
      title: fields[0] as String,
      description: fields[1] as String,
      author: fields[2] as String,
      version: fields[4] as String,
      dataCache: fields[5] as GameData,
    )
      ..infoCards = (fields[6] as List)?.cast<Info>()
      ..primaryColor = fields[7] as int
      ..accentColor = fields[8] as int;
  }

  @override
  void write(BinaryWriter writer, Preset obj) {
    writer
      ..writeByte(9)
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
      ..write(obj.dataCache)
      ..writeByte(6)
      ..write(obj.infoCards)
      ..writeByte(7)
      ..write(obj.primaryColor)
      ..writeByte(8)
      ..write(obj.accentColor);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preset _$PresetFromJson(Map json) {
  return Preset(
    projectName: json['projectName'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    author: json['author'] as String,
    version: json['version'] as String,
    dataCache: json['dataCache'] == null
        ? null
        : GameData.fromJson(json['dataCache'] as Map),
  )
    ..infoCards = (json['infoCards'] as List)
        ?.map((e) => e == null ? null : Info.fromJson(e as Map))
        ?.toList()
    ..primaryColor = json['primaryColor'] as int
    ..accentColor = json['accentColor'] as int;
}

Map<String, dynamic> _$PresetToJson(Preset instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'author': instance.author,
      'projectName': instance.projectName,
      'version': instance.version,
      'dataCache': instance.dataCache?.toJson(),
      'infoCards': instance.infoCards?.map((e) => e?.toJson())?.toList(),
      'primaryColor': instance.primaryColor,
      'accentColor': instance.accentColor,
    };
