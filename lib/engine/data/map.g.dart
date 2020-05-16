// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TileTypeAdapter extends TypeAdapter<TileType> {
  @override
  final typeId = 2;

  @override
  TileType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TileType.land;
      case 1:
        return TileType.company;
      case 2:
        return TileType.trainstation;
      case 3:
        return TileType.start;
      case 4:
        return TileType.chest;
      case 5:
        return TileType.tax;
      case 6:
        return TileType.chance;
      case 7:
        return TileType.jail;
      case 8:
        return TileType.parking;
      case 9:
        return TileType.police;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, TileType obj) {
    switch (obj) {
      case TileType.land:
        writer.writeByte(0);
        break;
      case TileType.company:
        writer.writeByte(1);
        break;
      case TileType.trainstation:
        writer.writeByte(2);
        break;
      case TileType.start:
        writer.writeByte(3);
        break;
      case TileType.chest:
        writer.writeByte(4);
        break;
      case TileType.tax:
        writer.writeByte(5);
        break;
      case TileType.chance:
        writer.writeByte(6);
        break;
      case TileType.jail:
        writer.writeByte(7);
        break;
      case TileType.parking:
        writer.writeByte(8);
        break;
      case TileType.police:
        writer.writeByte(9);
        break;
    }
  }
}

class MapConfigurationAdapter extends TypeAdapter<MapConfiguration> {
  @override
  final typeId = 9;

  @override
  MapConfiguration read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MapConfiguration()
      ..configuration = (fields[0] as List)?.cast<int>()
      ..width = fields[1] as int;
  }

  @override
  void write(BinaryWriter writer, MapConfiguration obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.configuration)
      ..writeByte(1)
      ..write(obj.width);
  }
}

class TileAdapter extends TypeAdapter<Tile> {
  @override
  final typeId = 1;

  @override
  Tile read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tile(
      fields[0] as TileType,
      color: fields[1] as int,
      idPrefix: fields[2] as String,
      name: fields[3] as String,
      price: fields[4] as int,
      housePrice: fields[6] as int,
      rent: (fields[7] as List)?.cast<int>(),
      hyp: fields[5] as int,
      mortaged: fields[11] as bool,
      idIndex: fields[10] as int,
    )
      ..level = fields[9] as int
      ..description = fields[12] as String;
  }

  @override
  void write(BinaryWriter writer, Tile obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.color)
      ..writeByte(2)
      ..write(obj.idPrefix)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.hyp)
      ..writeByte(6)
      ..write(obj.housePrice)
      ..writeByte(7)
      ..write(obj.rent)
      ..writeByte(9)
      ..write(obj.level)
      ..writeByte(10)
      ..write(obj.idIndex)
      ..writeByte(11)
      ..write(obj.mortaged)
      ..writeByte(12)
      ..write(obj.description);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapConfiguration _$MapConfigurationFromJson(Map<String, dynamic> json) {
  return MapConfiguration()
    ..configuration =
        (json['configuration'] as List)?.map((e) => e as int)?.toList()
    ..width = json['width'] as int;
}

Map<String, dynamic> _$MapConfigurationToJson(MapConfiguration instance) =>
    <String, dynamic>{
      'configuration': instance.configuration,
      'width': instance.width,
    };

Tile _$TileFromJson(Map<String, dynamic> json) {
  return Tile(
    _$enumDecodeNullable(_$TileTypeEnumMap, json['type']),
    color: json['color'] as int,
    idPrefix: json['idPrefix'] as String,
    name: json['name'] as String,
    price: json['price'] as int,
    housePrice: json['housePrice'] as int,
    rent: (json['rent'] as List)?.map((e) => e as int)?.toList(),
    hyp: json['hyp'] as int,
    mortaged: json['mortaged'] as bool,
    idIndex: json['idIndex'] as int,
  )
    ..level = json['level'] as int
    ..description = json['description'] as String ?? 'No info';
}

Map<String, dynamic> _$TileToJson(Tile instance) => <String, dynamic>{
      'type': _$TileTypeEnumMap[instance.type],
      'color': instance.color,
      'idPrefix': instance.idPrefix,
      'name': instance.name,
      'price': instance.price,
      'hyp': instance.hyp,
      'housePrice': instance.housePrice,
      'rent': instance.rent,
      'level': instance.level,
      'idIndex': instance.idIndex,
      'mortaged': instance.mortaged,
      'description': instance.description,
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

const _$TileTypeEnumMap = {
  TileType.land: 'land',
  TileType.company: 'company',
  TileType.trainstation: 'trainstation',
  TileType.start: 'start',
  TileType.chest: 'chest',
  TileType.tax: 'tax',
  TileType.chance: 'chance',
  TileType.jail: 'jail',
  TileType.parking: 'parking',
  TileType.police: 'police',
};
