import 'package:hive/hive.dart';

part 'ai_type.g.dart';

@HiveType(typeId: 15)
enum AIType {
  @HiveField(0)
  player,
  @HiveField(1)
  normal
}
