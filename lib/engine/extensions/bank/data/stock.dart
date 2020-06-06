import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../kernel/main.dart';

part 'stock.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 12)
class Stock {
  @HiveField(0)
  String id = "";
  @HiveField(1)
  double value;
  @HiveField(2)
  int volume;
  @HiveField(3)
  String info;
  @HiveField(4)
  Map<int, double> valueHistory = {0: 100};

  Stock({
    @required this.id,
    @required this.value,
    @required this.volume,
    this.info: "",
  }) : valueHistory = {Game.data?.turn ?? 0: value};

  Stock.world() {
    id = "WORLD_STOCK";
    value = 100;
    volume = 100;
    info =
        "This is a world index fund. It represents the world average stock value. Buying fee: 5%";
  }

  factory Stock.fromJson(Map json) => _$StockFromJson(json);
  Map<String, dynamic> toJson() => _$StockToJson(this);
}
