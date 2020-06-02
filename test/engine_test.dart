import 'package:flutter_test/flutter_test.dart';
import 'package:plutopoly/engine/data/main_data.dart';
import 'package:plutopoly/engine/data/map.dart';
import 'package:plutopoly/engine/kernel/main.dart';
import 'package:plutopoly/engine/kernel/core_actions.dart';
import 'package:plutopoly/engine/ui/alert.dart';

void main() {
  test('Normal test game', () {
    Game.testing = true;

    Game.loadGame(GameData());
    Game.setup.addPlayer(name: "1", color: 1, code: 1);
    Game.setup.addPlayer(name: "2", color: 2, code: 1);
    Alert addPlayerAlert = Game.setup.addPlayer(name: "2", color: 2, code: 1);
    expect(addPlayerAlert, isNotNull);
    Game.setup.addPlayer(name: "3", color: 3, code: 1);
    Game.launch();
    expect(Game.data.players.length, 3, reason: "There should be 3 players");

    expect(Game.data.extensions.length, 0);

    expect(Game.data.currentPlayer, 0, reason: "The players turn");
    Game.next();
    expect(Game.data.currentPlayer, 1, reason: "The players turn");

    Game.move(1, 2);
    expect(Game.data.rentPayed, false,
        reason: "rentPayed should be false on new turn.");
    Game.data.player.positionTile.type == TileType.chance;
    Game.act.pay(PayType.pot, 100);
    expect(Game.data.rentPayed, true,
        reason: "PayType.pot should set rentPayed = true");
    Game.next();
    expect(Game.data.currentPlayer, 2, reason: "The players turn");

    Game.move(4, 1);
    Game.act.buy();
    expect(Game.build(), isNotNull,
        reason: "You shouldn't be able to build if you don't have a street");
    expect(Game.data.player.positionTile.level, 0,
        reason: "tile upgraded illegally");

    expect(Game.data.player.properties[0], 5, reason: "Should add property");

    Game.next();
    expect(Game.data.currentPlayer, 0, reason: "The players should loop");

    Game.move(2, 2);
    expect(Game.data.doublesThrown, 0,
        reason: "doublesThrown should be changed after Game.next()");

    expect(Game.next(), isNotNull, reason: "taxes not payed");
    Game.act.pay(PayType.pot, Game.data.player.positionTile.price);
    expect(Game.next(), isNull, reason: "taxes payed");
    expect(Game.data.doublesThrown, 1, reason: "1 double should be thrown");
    expect(Game.data.currentPlayer, 0,
        reason: "doubles should keep currentPlayer after Game.next()");
    Game.move(2, 2);
    Game.next();
    expect(Game.data.doublesThrown, 2, reason: "doubles");

    Game.move(2, 2);
    expect(Game.data.player.jailed, true,
        reason: "after 3 doubles the player should be jailed");
    expect(Game.data.player.position, 10,
        reason: "the player should go to jail when jailed");
    Game.next();
    expect(Game.data.doublesThrown, 0, reason: "doubles");
    Game.move(3, 5);
    Game.next();
    expect(Game.data.currentPlayer, 2);

    double moneyDealer = Game.data.players[1].money;
    double moneyPlayer = Game.data.player.money;
    Game.act.deal(payAmount: 200, dealer: 1);
    expect(Game.data.players[1].properties.contains(5), false, reason: "deal");
    expect(Game.data.player.properties.contains(5), true, reason: "deal");
    expect(Game.data.players[1].money, moneyDealer + 200);
    expect(Game.data.player.money, moneyPlayer - 200);

    Game.next();
    expect(Game.data.currentPlayer, 0);
    Game.move(2, 1);
    expect(Game.data.player.jailed, true);

    Game.next();
    expect(Game.data.currentPlayer, 1);

    Game.next();
    expect(Game.data.currentPlayer, 2);
    Game.move(2, 1);

    Game.next();
    expect(Game.data.currentPlayer, 0);
    expect(Game.data.player.jailed, true);
    Game.move(1, 1);
    expect(Game.data.player.jailed, false);
    expect(
        Game.data.player.position,
        Game.data.gmap
                .firstWhere((Tile tile) => tile.idPrefix == "JAIL")
                .mapIndex +
            2,
        reason: "Player should move from jail");

    Game.next();
    expect(Game.data.currentPlayer, 1);

    Game.next();
    expect(Game.data.currentPlayer, 2);

    Game.next();
    expect(Game.data.currentPlayer, 0);
  });
}
