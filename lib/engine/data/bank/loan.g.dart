// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoanAdapter extends TypeAdapter<Loan> {
  @override
  final typeId = 10;

  @override
  Loan read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Loan(
      interest: fields[0] as double,
      amount: fields[1] as double,
      waitingTurns: fields[2] as int,
      fee: fields[4] as double,
      countToCap: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Loan obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.interest)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.waitingTurns)
      ..writeByte(3)
      ..write(obj.countToCap)
      ..writeByte(4)
      ..write(obj.fee);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Loan _$LoanFromJson(Map<String, dynamic> json) {
  return Loan(
    interest: (json['interest'] as num)?.toDouble(),
    amount: (json['amount'] as num)?.toDouble(),
    waitingTurns: json['waitingTurns'] as int,
    fee: (json['fee'] as num)?.toDouble(),
    countToCap: json['countToCap'] as bool,
  );
}

Map<String, dynamic> _$LoanToJson(Loan instance) => <String, dynamic>{
      'interest': instance.interest,
      'amount': instance.amount,
      'waitingTurns': instance.waitingTurns,
      'countToCap': instance.countToCap,
      'fee': instance.fee,
    };
