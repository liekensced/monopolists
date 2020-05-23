// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContractAdapter extends TypeAdapter<Contract> {
  @override
  final typeId = 10;

  @override
  Contract read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Contract(
      interest: fields[0] as double,
      amount: fields[1] as double,
      waitingTurns: fields[2] as int,
      id: fields[5] as String,
      fee: fields[4] as double,
      countToCap: fields[3] as bool,
      position: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Contract obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.interest)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.waitingTurns)
      ..writeByte(3)
      ..write(obj.countToCap)
      ..writeByte(4)
      ..write(obj.fee)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.position);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contract _$ContractFromJson(Map<String, dynamic> json) {
  return Contract(
    interest: (json['interest'] as num)?.toDouble(),
    amount: (json['amount'] as num)?.toDouble(),
    waitingTurns: json['waitingTurns'] as int,
    id: json['id'] as String,
    fee: (json['fee'] as num)?.toDouble(),
    countToCap: json['countToCap'] as bool,
    position: json['position'] as String,
  );
}

Map<String, dynamic> _$ContractToJson(Contract instance) => <String, dynamic>{
      'interest': instance.interest,
      'amount': instance.amount,
      'waitingTurns': instance.waitingTurns,
      'countToCap': instance.countToCap,
      'fee': instance.fee,
      'id': instance.id,
      'position': instance.position,
    };
