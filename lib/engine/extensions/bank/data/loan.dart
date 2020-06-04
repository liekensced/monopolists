import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'loan.g.dart';

@JsonSerializable()
@HiveType(typeId: 10)
class Contract {
  @HiveField(0)
  double interest = 0.05;
  @HiveField(1)
  double amount = 0;
  @HiveField(2)
  int waitingTurns;
  @HiveField(3)
  bool countToCap;
  @HiveField(4)
  double fee;
  @HiveField(5)
  String id = "";
  @HiveField(6)
  String position;

  String get fullId => id + ":$waitingTurns:$amount";

  Contract({
    this.interest,
    @required this.amount,
    this.waitingTurns,
    @required this.id,
    this.fee: 0,
    this.countToCap: true,
    this.position,
  });
  @override
  bool operator ==(o) => o is Contract && o.fullId == fullId;

  Contract.copy(Contract contract) {
    interest = contract.interest;
    amount = contract.amount;
    waitingTurns = contract.waitingTurns;
    id = contract.id;
    fee = contract.fee ?? 0;
    countToCap = contract.countToCap ?? true;
  }

  factory Contract.fromJson(Map<String, dynamic> json) =>
      _$ContractFromJson(json);
  Map<String, dynamic> toJson() => _$ContractToJson(this);
}
