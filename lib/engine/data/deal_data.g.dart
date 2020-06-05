// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deal_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DealDataAdapter extends TypeAdapter<DealData> {
  @override
  final typeId = 8;

  @override
  DealData read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DealData()
      ..payAmount = fields[0] as int
      ..receivableProperties = (fields[1] as List)?.cast<String>()
      ..receiveProperties = (fields[2] as List)?.cast<String>()
      ..payableProperties = (fields[3] as List)?.cast<String>()
      ..payProperties = (fields[4] as List)?.cast<String>()
      ..price = fields[5] as int
      ..valid = (fields[6] as List)?.cast<bool>()
      ..playerChecked = fields[7] as bool
      ..dealerChecked = fields[8] as bool
      ..dealer = fields[9] as int;
  }

  @override
  void write(BinaryWriter writer, DealData obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.payAmount)
      ..writeByte(1)
      ..write(obj.receivableProperties)
      ..writeByte(2)
      ..write(obj.receiveProperties)
      ..writeByte(3)
      ..write(obj.payableProperties)
      ..writeByte(4)
      ..write(obj.payProperties)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.valid)
      ..writeByte(7)
      ..write(obj.playerChecked)
      ..writeByte(8)
      ..write(obj.dealerChecked)
      ..writeByte(9)
      ..write(obj.dealer);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DealData _$DealDataFromJson(Map json) {
  return DealData()
    ..payAmount = json['payAmount'] as int
    ..receivableProperties = (json['receivableProperties'] as List)
        ?.map((e) => e as String)
        ?.toList()
    ..receiveProperties =
        (json['receiveProperties'] as List)?.map((e) => e as String)?.toList()
    ..payableProperties =
        (json['payableProperties'] as List)?.map((e) => e as String)?.toList()
    ..payProperties =
        (json['payProperties'] as List)?.map((e) => e as String)?.toList()
    ..price = json['price'] as int
    ..valid = (json['valid'] as List)?.map((e) => e as bool)?.toList()
    ..playerChecked = json['playerChecked'] as bool
    ..dealerChecked = json['dealerChecked'] as bool
    ..dealer = json['dealer'] as int;
}

Map<String, dynamic> _$DealDataToJson(DealData instance) => <String, dynamic>{
      'payAmount': instance.payAmount,
      'receivableProperties': instance.receivableProperties,
      'receiveProperties': instance.receiveProperties,
      'payableProperties': instance.payableProperties,
      'payProperties': instance.payProperties,
      'price': instance.price,
      'valid': instance.valid,
      'playerChecked': instance.playerChecked,
      'dealerChecked': instance.dealerChecked,
      'dealer': instance.dealer,
    };
