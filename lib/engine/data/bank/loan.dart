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

  Loan(
      {@required this.interest,
      @required this.amount,
      @required this.waitingTurns,
      this.fee: 0,
      this.countToCap: true});

  factory Loan.fromJson(Map<String, dynamic> json) => _$LoanFromJson(json);
  Map<String, dynamic> toJson() => _$LoanToJson(this);
}
