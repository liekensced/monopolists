import '../../data/extensions.dart';
import '../../data/info.dart';
import '../../data/map.dart';
import '../../data/player.dart';
import '../../kernel/core_actions.dart';
import '../../kernel/main.dart';
import '../../ui/alert.dart';
import 'bank.dart';
import 'data/loan.dart';

class BankMain {
  static get enabled => Game.data.extensions.contains(Extension.bank);

  static BankExtension get bank => Game.bank;

  static List<Contract> getAllLoans() {
    return getLoans();
  }

  static double _checkLoan(Contract loan, int playerIndex) {
    if (loan.waitingTurns == 0) {
      Game.data.players[playerIndex].money += loan.amount;
      return loan.amount;
    }
    return 0;
  }

  static onNewTurnPlayer(int playerIndex) {
    double totalInterest = 0;
    double totalReceived = 0;
    Game.data.players[playerIndex].loans
        .asMap()
        .forEach((int index, Contract loan) {
      if (loan.waitingTurns > 0) {
        Game.data.players[playerIndex].loans[index].waitingTurns--;
        totalReceived += _checkLoan(loan, playerIndex);
      } else {
        Game.data.players[playerIndex].money -= loan.interest * loan.amount;
        totalInterest += loan.interest * loan.amount;
      }
    });
    if (totalReceived != 0)
      Game.addInfo(
          UpdateInfo(
              title: "Received loan(s): +£$totalReceived", leading: "bank"),
          playerIndex);
    if (totalInterest != 0)
      Game.addInfo(
          UpdateInfo(
              title: "Total interest: -£$totalInterest", leading: "bank"),
          playerIndex);
  }

  static rent() {
    if (!enabled) return;
    double rent = Game.data.player.money * 0.10;
    Game.data.player.money += rent;
    Game.addInfo(UpdateInfo(title: "Received rent: +£${rent.floor()}"));
  }

  static Alert payLoan(Contract loan) {
    Alert alert = Game.act.pay(PayType.bank, loan.amount.toInt());
    if (alert != null) return alert;
    Game.data.player.loans.remove(loan);
    Game.data.player.debt -= loan.amount;
    Game.save();
    return alert;
  }

  static List<Contract> getLoans([Player player]) {
    if (player == null) player = Game.data.player;
    return standardLoans;
  }

  static Alert lend(Contract loan, [Player player]) {
    if (player == null) player = Game.data.player;
    Alert alert;
    if (lendingRoom(player) < loan.amount && loan.countToCap)
      return Alert("Lend amount to high",
          "You do not posses enough assets. Try a smaller loan.");
    if (!loan.countToCap) {
      player.loans.forEach((Contract l) {
        if (l == loan) {
          alert = Alert("You already have this loan",
              "You can buy this loan only once. ");
          return;
        }
      });
    }

    if (alert != null) return alert;

    if (loan.countToCap) Game.data.player.debt += loan.amount;
    Game.act.pay(PayType.bank, (loan.amount * loan.fee).toInt());
    Game.data.player.loans.add(Contract.copy(loan));
    _checkLoan(loan, player.index);
    Game.save();
    return Alert.snackBar("Loan available in ${loan.waitingTurns} turn(s).");
  }

  static double lendingCap([Player player]) {
    if (player == null) player = Game.data.player;
    return (netMoney(player) * 2) +
        propertiesValue(player) +
        stocksValue(player);
  }

  static netMoney(Player player) {
    double willReceive = 0;
    player.loans.forEach((Contract c) {
      if (c.waitingTurns != 0) willReceive += c.amount;
    });

    return player.money + willReceive - player.debt;
  }

  static double lendingRoom([Player player]) {
    if (player == null) player = Game.data.player;
    return lendingCap(player) - player.debt;
  }

  static double stocksValue([Player player]) {
    if (player == null) player = Game.data.player;
    double stocksValue = 0;
    player.stock.forEach((key, int amount) {
      stocksValue += Game.data.bankData.worldStock.value * amount;
    });
    return stocksValue;
  }

  static double propertiesValue([Player player]) {
    if (player == null) player = Game.data.player;
    double propertiesValue = 0;
    player.properties.forEach((int index) {
      Tile tile = Game.data.gmap[index];
      propertiesValue += tile.price;
      propertiesValue += tile.level * (tile.housePrice ?? 0);
      if (tile.mortaged) propertiesValue -= tile.hyp;
    });
    return propertiesValue;
  }
}
