// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiceTypeAdapter extends TypeAdapter<DiceType> {
  @override
  final typeId = 26;

  @override
  DiceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DiceType.one;
      case 1:
        return DiceType.two;
      case 2:
        return DiceType.three;
      case 3:
        return DiceType.random;
      case 4:
        return DiceType.choose;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, DiceType obj) {
    switch (obj) {
      case DiceType.one:
        writer.writeByte(0);
        break;
      case DiceType.two:
        writer.writeByte(1);
        break;
      case DiceType.three:
        writer.writeByte(2);
        break;
      case DiceType.random:
        writer.writeByte(3);
        break;
      case DiceType.choose:
        writer.writeByte(4);
        break;
    }
  }
}

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
      ..hackerScreen = fields[6] as bool
      ..interest = fields[7] as int
      ..dtlPrice = fields[8] as int
      ..startProperties = fields[9] as int
      ..transportPassGo = fields[10] as bool
      ..allowDiceSelect = fields[11] as bool
      ..allowPriceChanges = fields[12] as bool
      ..generateNames = fields[13] as bool
      ..receiveProperties = fields[14] as bool
      ..receiveRentInJail = fields[15] as bool
      ..doubleBonus = fields[16] as bool
      ..diceType = fields[17] as DiceType;
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(18)
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
      ..write(obj.hackerScreen)
      ..writeByte(7)
      ..write(obj.interest)
      ..writeByte(8)
      ..write(obj.dtlPrice)
      ..writeByte(9)
      ..write(obj.startProperties)
      ..writeByte(10)
      ..write(obj.transportPassGo)
      ..writeByte(11)
      ..write(obj.allowDiceSelect)
      ..writeByte(12)
      ..write(obj.allowPriceChanges)
      ..writeByte(13)
      ..write(obj.generateNames)
      ..writeByte(14)
      ..write(obj.receiveProperties)
      ..writeByte(15)
      ..write(obj.receiveRentInJail)
      ..writeByte(16)
      ..write(obj.doubleBonus)
      ..writeByte(17)
      ..write(obj.diceType);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map json) {
  return Settings()
    ..name = json['name'] as String
    ..remotelyBuild = json['remotelyBuild'] as bool
    ..goBonus = json['goBonus'] as int
    ..maxTurnes = json['maxTurnes'] as int
    ..mustAuction = json['mustAuction'] as bool
    ..startingMoney = json['startingMoney'] as int
    ..hackerScreen = json['hackerScreen'] as bool
    ..interest = json['interest'] as int ?? 5
    ..dtlPrice = json['dtlPrice'] as int ?? 2000
    ..startProperties = json['startProperties'] as int ?? 0
    ..transportPassGo = json['transportPassGo'] as bool ?? true
    ..allowDiceSelect = json['allowDiceSelect'] as bool ?? false
    ..allowPriceChanges = json['allowPriceChanges'] as bool ?? false
    ..generateNames = json['generateNames'] as bool ?? true
    ..receiveProperties = json['receiveProperties'] as bool
    ..receiveRentInJail = json['receiveRentInJail'] as bool
    ..doubleBonus = json['doubleBonus'] as bool
    ..diceType = _$enumDecodeNullable(_$DiceTypeEnumMap, json['diceType']) ??
        DiceType.two;
}

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'name': instance.name,
      'remotelyBuild': instance.remotelyBuild,
      'goBonus': instance.goBonus,
      'maxTurnes': instance.maxTurnes,
      'mustAuction': instance.mustAuction,
      'startingMoney': instance.startingMoney,
      'hackerScreen': instance.hackerScreen,
      'interest': instance.interest,
      'dtlPrice': instance.dtlPrice,
      'startProperties': instance.startProperties,
      'transportPassGo': instance.transportPassGo,
      'allowDiceSelect': instance.allowDiceSelect,
      'allowPriceChanges': instance.allowPriceChanges,
      'generateNames': instance.generateNames,
      'receiveProperties': instance.receiveProperties,
      'receiveRentInJail': instance.receiveRentInJail,
      'doubleBonus': instance.doubleBonus,
      'diceType': _$DiceTypeEnumMap[instance.diceType],
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

const _$DiceTypeEnumMap = {
  DiceType.one: 'one',
  DiceType.two: 'two',
  DiceType.three: 'three',
  DiceType.random: 'random',
  DiceType.choose: 'choose',
};
