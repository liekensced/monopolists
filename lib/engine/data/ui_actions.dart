import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../bloc/main_bloc.dart';
import '../kernel/main.dart';

part 'ui_actions.g.dart';

@JsonSerializable()
@HiveType(typeId: 5)
class UIActionsData extends HiveObject {
  @HiveField(0)
  bool shouldMove = true;

  @HiveField(1)
  bool showDealScreen = false;

  bool get idle {
    if (!MainBloc.online) return false;
    return Game.data.player.code != MainBloc.player?.code;
  }

  UIActionsData();

  factory UIActionsData.fromJson(Map<String, dynamic> json) =>
      _$UIActionsDataFromJson(json);
  Map<String, dynamic> toJson() => _$UIActionsDataToJson(this);

  void loadActionScreen() {}

  int get moveAnimationMillis {
    return (Game.data.currentDices[0] + Game.data.currentDices[1] * 200 + 500);
  }
}
