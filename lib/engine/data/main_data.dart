import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:plutopoly/engine/ai/ai_type.dart';

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
  List<Tile> gmap = List.of(defaultMap);
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
  @HiveField(21)
  String preset = "";

  GameData() {
    version = MainBloc.version;
  }

  factory GameData.fromJson(Map json) => _$GameDataFromJson(json);
  Map<String, dynamic> toJson() => _$GameDataToJson(this);

  Player get nextRealPlayer {
    for (int i = 0; i < players.length; i++) {
      int index = (i + currentPlayer) % players.length;
      if (players[index].ai?.type == AIType.player) {
        return players[index];
      }
    }
    if (players.isEmpty) return Player();

    return players.first;
  }

  Tile get tile {
    return player.positionTile;
  }

  Player get player {
    if (players.isEmpty) return Player(money: double.infinity);
    if (currentPlayer >= players.length) return players.first;
    if (currentPlayer < 0) {
      currentPlayer = players.last.index;
    }
    return players[currentPlayer];
  }
}
