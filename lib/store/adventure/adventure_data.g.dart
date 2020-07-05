// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adventure_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdventureLandAdapter extends TypeAdapter<AdventureLand> {
  @override
  final typeId = 21;

  @override
  AdventureLand read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdventureLand(
      name: fields[0] as String,
      description: fields[1] as String,
      levels: (fields[2] as List)?.cast<Level>(),
    );
  }

  @override
  void write(BinaryWriter writer, AdventureLand obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.levels);
  }
}

class LevelAdapter extends TypeAdapter<Level> {
  @override
  final typeId = 22;

  @override
  Level read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Level(
      turnsNeeded: fields[2] as int,
      presetCache: fields[3] as Preset,
      presetName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Level obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.presetName)
      ..writeByte(2)
      ..write(obj.turnsNeeded)
      ..writeByte(3)
      ..write(obj.presetCache);
  }
}

class LevelProgressAdapter extends TypeAdapter<LevelProgress> {
  @override
  final typeId = 23;

  @override
  LevelProgress read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LevelProgress()
      ..stars = fields[0] as int
      ..best = fields[1] as int;
  }

  @override
  void write(BinaryWriter writer, LevelProgress obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.stars)
      ..writeByte(1)
      ..write(obj.best);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdventureLand _$AdventureLandFromJson(Map json) {
  return AdventureLand(
    name: json['name'] as String,
    description: json['description'] as String,
    levels: (json['levels'] as List)
        ?.map((e) => e == null
            ? null
            : Level.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
  );
}

Map<String, dynamic> _$AdventureLandToJson(AdventureLand instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'levels': instance.levels?.map((e) => e?.toJson())?.toList(),
    };

Level _$LevelFromJson(Map json) {
  return Level(
    turnsNeeded: json['turnsNeeded'] as int,
    presetCache: json['presetCache'] == null
        ? null
        : Preset.fromJson(json['presetCache'] as Map),
    presetName: json['presetName'] as String,
  );
}

Map<String, dynamic> _$LevelToJson(Level instance) => <String, dynamic>{
      'presetName': instance.presetName,
      'turnsNeeded': instance.turnsNeeded,
      'presetCache': instance.presetCache?.toJson(),
    };

LevelProgress _$LevelProgressFromJson(Map json) {
  return LevelProgress()
    ..stars = json['stars'] as int
    ..best = json['best'] as int;
}

Map<String, dynamic> _$LevelProgressToJson(LevelProgress instance) =>
    <String, dynamic>{
      'stars': instance.stars,
      'best': instance.best,
    };
