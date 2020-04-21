// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerAdapter extends TypeAdapter<Player> {
  @override
  final typeId = 3;

  @override
  Player read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Player(
      money: fields[1] as double,
      color: fields[4] as int,
      position: fields[2] as int,
      name: fields[0] as String,
      code: fields[11] as int,
    )
      ..properties = (fields[5] as List)?.cast<int>()
      ..jailed = fields[6] as bool
      ..jailTries = fields[7] as int
      ..goojCards = fields[8] as int
      ..info = (fields[9] as Map)?.map((dynamic k, dynamic v) =>
          MapEntry(k as int, (v as List)?.cast<UpdateInfo>()))
      ..moneyHistory = (fields[10] as List)?.cast<double>()
      ..debt = fields[12] as double
      ..loans = (fields[13] as List)?.cast<Contract>();
  }

  @override
  void write(BinaryWriter writer, Player obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.money)
      ..writeByte(2)
      ..write(obj.position)
      ..writeByte(4)
      ..write(obj.color)
      ..writeByte(5)
      ..write(obj.properties)
      ..writeByte(6)
      ..write(obj.jailed)
      ..writeByte(7)
      ..write(obj.jailTries)
      ..writeByte(8)
      ..write(obj.goojCards)
      ..writeByte(9)
      ..write(obj.info)
      ..writeByte(10)
      ..write(obj.moneyHistory)
      ..writeByte(11)
      ..write(obj.code)
      ..writeByte(12)
      ..write(obj.debt)
      ..writeByte(13)
      ..write(obj.loans);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) {
  return Player(
    money: (json['money'] as num)?.toDouble(),
    color: json['color'] as int,
    position: json['position'] as int,
    name: json['name'] as String,
    code: json['code'] as int,
  )
    ..properties = (json['properties'] as List)?.map((e) => e as int)?.toList()
    ..jailed = json['jailed'] as bool
    ..jailTries = json['jailTries'] as int
    ..goojCards = json['goojCards'] as int
    ..info = (json['info'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          int.parse(k),
          (e as List)
              ?.map((e) => e == null
                  ? null
                  : UpdateInfo.fromJson(e as Map<String, dynamic>))
              ?.toList()),
    )
    ..moneyHistory = (json['moneyHistory'] as List)
        ?.map((e) => (e as num)?.toDouble())
        ?.toList()
    ..debt = (json['debt'] as num)?.toDouble()
    ..loans = (json['loans'] as List)
        ?.map((e) =>
            e == null ? null : Contract.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'name': instance.name,
      'money': instance.money,
      'position': instance.position,
      'color': instance.color,
      'properties': instance.properties,
      'jailed': instance.jailed,
      'jailTries': instance.jailTries,
      'goojCards': instance.goojCards,
      'info': instance.info?.map((k, e) =>
          MapEntry(k.toString(), e?.map((e) => e?.toJson())?.toList())),
      'moneyHistory': instance.moneyHistory,
      'code': instance.code,
      'debt': instance.debt,
      'loans': instance.loans?.map((e) => e?.toJson())?.toList(),
    };
