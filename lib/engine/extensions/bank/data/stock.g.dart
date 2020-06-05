// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockAdapter extends TypeAdapter<Stock> {
  @override
  final typeId = 12;

  @override
  Stock read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Stock(
      id: fields[0] as String,
      value: fields[1] as double,
      volume: fields[2] as int,
      info: fields[3] as String,
    )..valueHistory = (fields[4] as Map)?.cast<int, double>();
  }

  @override
  void write(BinaryWriter writer, Stock obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.volume)
      ..writeByte(3)
      ..write(obj.info)
      ..writeByte(4)
      ..write(obj.valueHistory);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stock _$StockFromJson(Map<String, dynamic> json) {
  return Stock(
    id: json['id'] as String,
    value: (json['value'] as num)?.toDouble(),
    volume: json['volume'] as int,
    info: json['info'] as String,
  )..valueHistory = (json['valueHistory'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(int.parse(k), (e as num)?.toDouble()),
    );
}

Map<String, dynamic> _$StockToJson(Stock instance) => <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'volume': instance.volume,
      'info': instance.info,
      'valueHistory':
          instance.valueHistory?.map((k, e) => MapEntry(k.toString(), e)),
    };
