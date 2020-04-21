import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'bank_data.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 11)
class BankData extends HiveObject {
  @HiveField(0)
  int expendature = 0;
  @HiveField(1)
  List<int> expandatureList = [];
  @HiveField(2)
  List<int> worldStockPrice = [];
  @HiveField(3)
  int bullPoints = 0;
  @HiveField(4)
  int volatility = 5;

  BankData();

  factory BankData.fromJson(Map<String, dynamic> json) =>
      _$BankDataFromJson(json);
  Map<String, dynamic> toJson() => _$BankDataToJson(this);
}
