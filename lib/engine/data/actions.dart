import 'package:plutopoly/helpers/money_helper.dart';

import '../kernel/core_actions.dart';

import '../kernel/main.dart';

class CardAction {
  String text;
  Function func;
  CardAction(this.text, this.func);
}

List<CardAction> events = [
  CardAction(
      "You win a game: +${mon(100)}", () => Game.data.player.money += 100),
  CardAction(
      "You win a game: +${mon(100)}", () => Game.data.player.money += 100),
  CardAction("You get payed from insurance: +150",
      () => Game.data.player.money += 150),
  CardAction("Pay new clothes: -${mon(150)}",
      () => Game.act.pay(PayType.pot, 150, count: true)),
  CardAction("Go to prison", () => Game.helper.jail(Game.data.player)),
  CardAction("Free out of prison card", () => Game.data.player.goojCards++),
  CardAction("Reverse three steps",
      () => Game.jump(Game.data.player.position - 3, false)),
  CardAction("Fine: -${mon(15)}", () => Game.data.player.money += 15),
  CardAction(
      "You get a divident: +${mon(50)}", () => Game.data.player.money += 50),
  CardAction("Repare your houses", () => Game.helper.repareHouses()),
  CardAction("Insure your houses",
      () => Game.helper.repareHouses(houseFactor: 40, hotelFactor: 115)),
  CardAction("Go to the start", () => Game.jump(0)),
  CardAction("You get fined: -${mon(20)}", () => Game.act.pay(PayType.pot, 20)),
  CardAction("Move to a random tile.", () => Game.jump()),
  CardAction("Move to a random tile.", () => Game.jump()),
  CardAction("Move to a random tile. You don't pass Start",
      () => Game.jump(null, false)),
];
List<CardAction> findings = [
  CardAction("Repare your houses", () => Game.helper.repareHouses()),
  CardAction("Go to prison", () => Game.helper.jail(Game.data.player)),
  CardAction(
      "You win a game: +${mon(100)}", () => Game.data.player.money += 100),
  CardAction(
      "You win a game: +${mon(100)}", () => Game.data.player.money += 100),
  CardAction("You win a bet: +${mon(50)}", () => Game.data.player.money += 50),
  CardAction("You win a bet: +${mon(25)}", () => Game.data.player.money += 25),
  CardAction("The bank makes a mistake: +${mon(200)}",
      () => Game.data.player.money += 200),
  CardAction("You inherit: +${mon(100)}", () => Game.data.player.money += 100),
  CardAction("Free out of prison card", () => Game.data.player.goojCards++),
  CardAction("Hospital bill: -${mon(100)}",
      () => Game.act.pay(PayType.pot, 100, count: true)),
  CardAction("Pay a fine: -${mon(10)}", () => Game.act.pay(PayType.pot, 10)),
  CardAction("Insurance bill: -${mon(50)}",
      () => Game.act.pay(PayType.pot, 50, count: true)),
  CardAction("Doctor bill: -${mon(50)}",
      () => Game.act.pay(PayType.pot, 50, count: true)),
  CardAction("You win a drawing contest: +${mon(10)}",
      () => Game.data.player.money += 10),
  CardAction("It's your birthday: +${mon(50)} from every player",
      () => Game.helper.birthDay()),
  CardAction("Go to the start", () => Game.jump(0)),
  CardAction(
      "Deducting taxes: +${mon(20)}", () => Game.data.player.money += 20),
  CardAction("Move to a random tile. You don't pass Start",
      () => Game.jump(null, false)),
  CardAction("Move to a random tile.", () => Game.jump())
];
