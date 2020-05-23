import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../bloc/main_bloc.dart';
import '../data/extensions.dart';
import '../extensions/bank/data/bank_data.dart';
import 'deal_data.dart';
import 'map.dart';
import 'player.dart';
import 'settings.dart';
import 'ui_actions.dart';

part 'main_data.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 0)
class GameData extends HiveObject {
  @HiveField(0)
  bool running;
  @HiveField(1)
  List<Player> players = [];
  @HiveField(2)
  int currentPlayer = 0;
  @HiveField(3)
  int turn = 1;
  @HiveField(4)
  List<int> currentDices = [1, -1];
  @HiveField(5)
  int doublesThrown = 0;
  @HiveField(6)
  double pot = 0;
  @HiveField(7)
  List<Tile> gmap = defaultMap;
  @HiveField(8)
  Settings settings = Settings();
  @HiveField(9)
  List<Extension> extensions = [];
  @HiveField(10)
  UIActionsData ui = UIActionsData();
  @HiveField(11)
  bool rentPayed = false;
  @HiveField(12)
  int findingsIndex = 0;
  @HiveField(13)
  int eventIndex = 0;
  @HiveField(14)
  String mapConfiguration = "classic";
  @HiveField(15)
  DealData dealData = DealData();
  @HiveField(16)
  BankData bankData;
  @HiveField(17)
  String version = "0";
  @HiveField(18)
  List<Player> lostPlayers = [];
  @HiveField(19)
  bool bot = false;
  @HiveField(20)
  @JsonKey(defaultValue: false)
  bool transported = false;

  GameData() {
    version = MainBloc.version;
  }

  factory GameData.fromJson(Map<String, dynamic> json) =>
      _$GameDataFromJson(json);
  Map<String, dynamic> toJson() => _$GameDataToJson(this);

  Tile get tile {
    return player.positionTile;
  }

  Player get player {
    if (currentPlayer >= players.length) return players.first;
    if (currentPlayer < 0) {
      currentPlayer = players.last.index;
    }
    return players[currentPlayer];
  }
}
