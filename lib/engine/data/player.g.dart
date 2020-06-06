// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map json) {
  if (json['info'] is Map) {
    json['info'] = [];
  }
  return Player(
    money: (json['money'] as num)?.toDouble(),
    color: json['color'] as int,
    position: json['position'] as int,
    name: json['name'] as String,
    code: json['code'] as int,
    ai: json['ai'] == null ? null : AI.fromJson(json['ai'] as Map),
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
    };
