import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'deal_data.g.dart';

@JsonSerializable()
@HiveType(typeId: 8)
class DealData extends HiveObject {
  @HiveField(0)
  int payAmount = 0;
  @HiveField(1)
  List<int> receivableProperties = [];
  @HiveField(2)
  List<int> receiveProperties = [];
  @HiveField(3)
  List<int> payableProperties = [];
  @HiveField(4)
  List<int> payProperties = [];

  @HiveField(5)
  int price = 0;
  @HiveField(6)
  List<bool> valid = [true, true];

  @HiveField(7)
  bool playerChecked = false;
  @HiveField(8)
  bool dealerChecked = false;
  @HiveField(9)
  int dealer = 0;
  DealData();
  factory DealData.fromJson(Map<String, dynamic> json) =>
      _$DealDataFromJson(json);
  Map<String, dynamic> toJson() => _$DealDataToJson(this);
}
