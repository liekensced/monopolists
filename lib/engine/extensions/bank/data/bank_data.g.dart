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
      ..worldStockPrice = (fields[2] as List)?.cast<int>()
      ..bullPoints = fields[3] as int
      ..volatility = fields[4] as int;
  }

  @override
  void write(BinaryWriter writer, BankData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.expendature)
      ..writeByte(1)
      ..write(obj.expandatureList)
      ..writeByte(2)
      ..write(obj.worldStockPrice)
      ..writeByte(3)
      ..write(obj.bullPoints)
      ..writeByte(4)
      ..write(obj.volatility);
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
    ..worldStockPrice =
        (json['worldStockPrice'] as List)?.map((e) => e as int)?.toList()
    ..bullPoints = json['bullPoints'] as int
    ..volatility = json['volatility'] as int;
}

Map<String, dynamic> _$BankDataToJson(BankData instance) => <String, dynamic>{
      'expendature': instance.expendature,
      'expandatureList': instance.expandatureList,
      'worldStockPrice': instance.worldStockPrice,
      'bullPoints': instance.bullPoints,
      'volatility': instance.volatility,
    };
