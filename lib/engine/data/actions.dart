import '../kernel/main.dart';

class CardAction {
  String text;
  Function func;
  CardAction(this.text, this.func);
}

List<CardAction> events = [
  CardAction("You win a game: +£100", () => Game.data.player.money += 100),
  CardAction("You get payed from insurance: +150",
      () => Game.data.player.money += 150),
  CardAction("Pay new clothes: -£150", () => Game.data.player.money -= 150),
  CardAction("Go to prison", () => Game.helper.jail(Game.data.currentPlayer)),
  CardAction("Free out of prison card", () => Game.data.player.goojCards++),
  CardAction("Reverse three steps", () => Game.data.player.position -= 3),
  CardAction("Fine: -£15", () => Game.data.player.money += 15),
  CardAction("You get a divident: +£50", () => Game.data.player.money += 50),
  CardAction("Repare your houses", () => Game.helper.repareHouses()),
  CardAction("Insure your houses",
      () => Game.helper.repareHouses(houseFactor: 40, hotelFactor: 115)),
  CardAction("Go to the start",
      () => Game.move(40 - Game.data.player.position - 1, 0)),
  CardAction("You get fined: -20", () => Game.data.player.money -= 20),
];
List<CardAction> findings = [
  CardAction("Go to prison", () => Game.helper.jail(Game.data.currentPlayer)),
  CardAction("You win a game: +£100", () => Game.data.player.money += 100),
  CardAction("You win a bet: +50", () => Game.data.player.money += 50),
  CardAction("You win a bet: +25", () => Game.data.player.money += 25),
  CardAction(
      "The bank makes a mistake: +200", () => Game.data.player.money += 200),
  CardAction("You inherit: +100", () => Game.data.player.money += 100),
  CardAction("Free out of prison card", () => Game.data.player.goojCards++),
  CardAction("Hospital bill: -100", () => Game.data.player.money -= 100),
  CardAction("Pay a fine: -10", () => Game.data.player.money -= 10),
  CardAction("Insurance bill: -50", () => Game.data.player.money -= 50),
  CardAction("Doctor bill: -50", () => Game.data.player.money -= 50),
  CardAction(
      "You win a drawing contest: +10", () => Game.data.player.money += 10),
  CardAction("It's your birthday: +10 from every player",
      () => Game.helper.birthDay()),
  CardAction(
      "Go to the start", () => Game.move(40 - Game.data.player.position, 0)),
  CardAction("Deducting taxes: +20", () => Game.data.player.money += 20),
];
