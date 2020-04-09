import 'package:hive/hive.dart';
import 'package:monopolists/engine/kernel/main.dart';

part 'ui_actions.g.dart';

@HiveType(typeId: 5)
class UIActionsData extends HiveObject {
  @HiveField(0)
  bool shouldMove = true;

  void loadActionScreen() {}

  int get moveAnimationMillis {
    return (Game.data.currentDices[0] + Game.data.currentDices[1] * 200 + 500);
  }
}
