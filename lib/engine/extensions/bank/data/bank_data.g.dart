// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BankDataAdapter extends TypeAdapter<BankData> {
  @override
  final typeId = 11;

  @override
  BankData read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BankData()
      ..expendature = fields[0] as int
      ..expandatureList = (fields[1] as List)?.cast<int>()
      ..bullPoints = fields[3] as int
      ..volatility = fields[4] as int
      ..worldStock = fields[5] as Stock;
  }

  @override
  void write(BinaryWriter writer, BankData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.expendature)
      ..writeByte(1)
      ..write(obj.expandatureList)
      ..writeByte(3)
      ..write(obj.bullPoints)
      ..writeByte(4)
      ..write(obj.volatility)
      ..writeByte(5)
      ..write(obj.worldStock);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankData _$BankDataFromJson(Map<String, dynamic> json) {
  return BankData()
    ..expendature = json['expendature'] as int
    ..expandatureList =
        (json['expandatureList'] as List)?.map((e) => e as int)?.toList()
    ..bullPoints = json['bullPoints'] as int
    ..volatility = json['volatility'] as int
    ..worldStock = json['worldStock'] == null
        ? null
        : Stock.fromJson(json['worldStock'] as Map<String, dynamic>);
}

Map<String, dynamic> _$BankDataToJson(BankData instance) => <String, dynamic>{
      'expendature': instance.expendature,
      'expandatureList': instance.expandatureList,
      'bullPoints': instance.bullPoints,
      'volatility': instance.volatility,
      'worldStock': instance.worldStock?.toJson(),
    };
