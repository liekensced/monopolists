import '../data/main_data.dart';
import '../data/player.dart';
import '../data/update_info.dart';
import '../extensions/bank/bank.dart';
import '../extensions/transportation.dart';
import 'main.dart';

class GameEvents {
  static GameData get data => Game.data;

  static onNewTurn() {
    BankExtension.onNewTurn();
    TransportationBloc.data.onNewTurn();
    data.turn++;
    //after here
    data.players.asMap().forEach((int i, _) {
      Player mapPlayer = data.players[i];
      Game.addInfo(UpdateInfo(title: "turn ${data.turn}", leading: "time"), i);

      BankExtension.onNewTurnPlayer(i);

      data.players[i].moneyHistory.add(mapPlayer.money);
    });
  }

  static onPassGo() {
    int _goBonus = Game.data.settings.goBonus;
    data.player.money += _goBonus;

    Game.addInfo(UpdateInfo(title: "Received go bonus: $_goBonus"),
        Game.data.currentPlayer);

    BankExtension.onPassGo();
  }
}
