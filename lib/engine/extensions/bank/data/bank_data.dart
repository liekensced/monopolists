import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

import 'stock.dart';

part 'bank_data.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 11)
class BankData {
  @HiveField(0)
  int expendature = 0;
  @HiveField(1)
  List<int> expandatureList = [500];
  @HiveField(3)
  int bullPoints = 0;
  @HiveField(4)
  int volatility = 5;
  @HiveField(5)
  Stock worldStock = Stock.world();

  BankData() {
    bullPoints = Random().nextInt(200) - 100;
  }

  factory BankData.fromJson(Map json) => _$BankDataFromJson(json);
  Map<String, dynamic> toJson() => _$BankDataToJson(this);
}
