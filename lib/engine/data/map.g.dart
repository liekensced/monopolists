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
      case 10:
        return TileType.action;
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
      case TileType.action:
        writer.writeByte(10);
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
      description: fields[12] as String,
      price: fields[4] as int,
      housePrice: fields[6] as int,
      rent: (fields[7] as List)?.cast<int>(),
      hyp: fields[5] as int,
      mortaged: fields[11] as bool,
      backgroundColor: fields[14] as int,
      icon: fields[15] as String,
      idIndex: fields[10] as int,
    )
      ..level = fields[9] as int
      ..transportationPrice = fields[13] as int
      ..tableColor = fields[16] as int
      ..actionRequired = fields[17] as bool
      ..onlyOneAction = fields[18] as bool
      ..iconData = (fields[19] as Map)?.cast<dynamic, dynamic>()
      ..actions = (fields[20] as List)?.cast<GameAction>();
  }

  @override
  void write(BinaryWriter writer, Tile obj) {
    writer
      ..writeByte(20)
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
      ..write(obj.description)
      ..writeByte(13)
      ..write(obj.transportationPrice)
      ..writeByte(14)
      ..write(obj.backgroundColor)
      ..writeByte(15)
      ..write(obj.icon)
      ..writeByte(16)
      ..write(obj.tableColor)
      ..writeByte(17)
      ..write(obj.actionRequired)
      ..writeByte(18)
      ..write(obj.onlyOneAction)
      ..writeByte(19)
      ..write(obj.iconData)
      ..writeByte(20)
      ..write(obj.actions);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapConfiguration _$MapConfigurationFromJson(Map json) {
  return MapConfiguration()
    ..configuration =
        (json['configuration'] as List)?.map((e) => e as int)?.toList()
    ..width = json['width'] as int;
}

Map<String, dynamic> _$MapConfigurationToJson(MapConfiguration instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('configuration', instance.configuration);
  writeNotNull('width', instance.width);
  return val;
}

Tile _$TileFromJson(Map json) {
  return Tile(
    _$enumDecodeNullable(_$TileTypeEnumMap, json['type']),
    color: json['color'] as int,
    idPrefix: json['idPrefix'] as String,
    name: json['name'] as String,
    description: json['description'] as String ?? 'No info',
    price: json['price'] as int,
    housePrice: json['housePrice'] as int,
    rent: (json['rent'] as List)?.map((e) => e as int)?.toList(),
    hyp: json['hyp'] as int,
    mortaged: json['mortaged'] as bool,
    backgroundColor: json['backgroundColor'] as int,
    icon: json['icon'] as String,
    idIndex: json['idIndex'] as int,
  )
    ..level = json['level'] as int
    ..transportationPrice = json['transportationPrice'] as int ?? 200
    ..tableColor = json['tableColor'] as int
    ..actionRequired = json['actionRequired'] as bool
    ..onlyOneAction = json['onlyOneAction'] as bool
    ..iconData = json['iconData'] as Map
    ..actions = (json['actions'] as List)
        ?.map((e) => e == null
            ? null
            : GameAction.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList();
}

Map<String, dynamic> _$TileToJson(Tile instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('type', _$TileTypeEnumMap[instance.type]);
  writeNotNull('color', instance.color);
  writeNotNull('idPrefix', instance.idPrefix);
  writeNotNull('name', instance.name);
  writeNotNull('price', instance.price);
  writeNotNull('hyp', instance.hyp);
  writeNotNull('housePrice', instance.housePrice);
  writeNotNull('rent', instance.rent);
  writeNotNull('level', instance.level);
  writeNotNull('idIndex', instance.idIndex);
  writeNotNull('mortaged', instance.mortaged);
  writeNotNull('description', instance.description);
  writeNotNull('transportationPrice', instance.transportationPrice);
  val['backgroundColor'] = instance.backgroundColor;
  writeNotNull('icon', instance.icon);
  val['tableColor'] = instance.tableColor;
  writeNotNull('actionRequired', instance.actionRequired);
  writeNotNull('onlyOneAction', instance.onlyOneAction);
  writeNotNull('iconData', instance.iconData);
  writeNotNull('actions', instance.actions?.map((e) => e?.toJson())?.toList());
  return val;
}

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
  TileType.action: 'action',
};
