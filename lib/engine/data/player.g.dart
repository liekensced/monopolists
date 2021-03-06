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
      ai: fields[15] as AI,
      playerIcon: fields[16] as String,
    )
      ..properties = (fields[5] as List)?.cast<String>()
      ..jailed = fields[6] as bool
      ..jailTries = fields[7] as int
      ..goojCards = fields[8] as int
      ..info = (fields[9] as List)?.cast<UpdateInfo>()
      ..moneyHistory = (fields[10] as List)?.cast<double>()
      ..debt = fields[12] as double
      ..loans = (fields[13] as List)?.cast<Contract>()
      ..stock = (fields[14] as Map)?.cast<String, int>();
  }

  @override
  void write(BinaryWriter writer, Player obj) {
    writer
      ..writeByte(16)
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
      ..write(obj.loans)
      ..writeByte(14)
      ..write(obj.stock)
      ..writeByte(15)
      ..write(obj.ai)
      ..writeByte(16)
      ..write(obj.playerIcon);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map json) {
  return Player(
    money: (json['money'] as num)?.toDouble(),
    color: json['color'] as int,
    position: json['position'] as int,
    name: json['name'] as String,
    code: json['code'] as int,
    ai: json['ai'] == null ? null : AI.fromJson(json['ai'] as Map),
    playerIcon: json['playerIcon'] as String,
  )
    ..properties =
        (json['properties'] as List)?.map((e) => e as String)?.toList()
    ..jailed = json['jailed'] as bool
    ..jailTries = json['jailTries'] as int
    ..goojCards = json['goojCards'] as int
    ..info = (json['info'] as List)
        ?.map((e) => e == null ? null : UpdateInfo.fromJson(e as Map))
        ?.toList()
    ..moneyHistory = (json['moneyHistory'] as List)
        ?.map((e) => (e as num)?.toDouble())
        ?.toList()
    ..debt = (json['debt'] as num)?.toDouble()
    ..loans = (json['loans'] as List)
        ?.map((e) => e == null ? null : Contract.fromJson(e as Map))
        ?.toList()
    ..stock = (json['stock'] as Map)?.map(
      (k, e) => MapEntry(k as String, e as int),
    );
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
      'info': instance.info?.map((e) => e?.toJson())?.toList(),
      'moneyHistory': instance.moneyHistory,
      'code': instance.code,
      'debt': instance.debt,
      'loans': instance.loans?.map((e) => e?.toJson())?.toList(),
      'stock': instance.stock,
      'ai': instance.ai?.toJson(),
      'playerIcon': instance.playerIcon,
    };
