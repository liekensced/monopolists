import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'loan.g.dart';

@JsonSerializable()
@HiveType(typeId: 10)
class Loan extends HiveObject {
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

  String get fullId => id + ":$waitingTurns:$amount";

  Loan(
      {@required this.interest,
      @required this.amount,
      @required this.waitingTurns,
      @required this.id,
      this.fee: 0,
      this.countToCap: true});
  @override
  bool operator ==(o) => o is Loan && o.fullId == fullId;

  Loan.copy(Loan loan) {
    interest = loan.interest;
    amount = loan.amount;
    waitingTurns = loan.waitingTurns;
    id = loan.id;
    fee = loan.fee ?? 0;
    countToCap = loan.countToCap ?? true;
  }

  factory Loan.fromJson(Map<String, dynamic> json) => _$LoanFromJson(json);
  Map<String, dynamic> toJson() => _$LoanToJson(this);
}
