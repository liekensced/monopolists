import 'package:flutter_test/flutter_test.dart';
import 'package:plutopoly/engine/data/main.dart';
import 'package:plutopoly/engine/data/map.dart';
import 'package:plutopoly/engine/kernel/main.dart';
import 'package:plutopoly/engine/kernel/core_actions.dart';

void main() {
  test('Normal test game', () {
    Game.testing = true;

    Game.loadGame(GameData());
    Game.setup.addPlayer();
    Game.setup.addPlayer();
    Game.setup.addPlayer();
    Game.launch();

    expect(Game.data.extensions.length, 0);

    Game.next();

    Game.move(1, 2);
    Game.act.pay(payType.pot, 100);
    Game.next();

    expect(Game.data.currentPlayer, 0);
    expect(Game.data.players.length, 3);

    Game.move(4, 1);
    Game.act.buy();
    Game.build();
    expect(Game.data.player.positionTile.level, 1, reason: "Build a house");

    expect(Game.data.player.properties[0], 5);

    Game.next();
    Game.move(2, 2);
    Game.next();
    expect(Game.data.currentPlayer, 2);
    Game.move(2, 2);
    Game.next();
    Game.move(2, 2);
    expect(Game.data.player.jailed, true);
    expect(Game.data.currentPlayer, 2);
    expect(Game.data.player.position, 9);

    Game.act.deal(payAmount: 200, receiveProperties: [5], dealer: 1);
    expect(Game.data.players[1].properties.contains(5), false);
    expect(Game.data.player.properties.contains(5), true);

    Game.next();
    expect(Game.data.currentPlayer, 0);
    Game.move(16, 1);

    Game.next();
    expect(Game.data.currentPlayer, 1);
    Game.move(2, 1);

    Game.next();
    expect(Game.data.currentPlayer, 2);
    Game.move(2, 1);
    expect(Game.data.player.jailed, true);

    Game.next();
    expect(Game.data.currentPlayer, 0);
    Game.move(16, 1);

    Game.next();
    expect(Game.data.currentPlayer, 1);

    Game.next();
    expect(Game.data.currentPlayer, 2);
    expect(Game.data.player.jailed, true);
    Game.move(1, 1);
    expect(Game.data.player.jailed, false);
    expect(
        Game.data.player.position,
        Game.data.gmap
                .firstWhere((Tile tile) => tile.idPrefix == "JAIL")
                .index +
            2);

    Game.next();
    expect(Game.data.currentPlayer, 0);
  });
}
