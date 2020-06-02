import 'dart:math';

import '../../data/actions.dart';
import '../../data/map.dart';
import '../../data/player.dart';
import '../../kernel/core_actions.dart';
import '../../kernel/main.dart';
import '../../ui/alert.dart';
import '../ai_type.dart';

class NormalAI {
  static Tile get tile => Game.data.tile;
  static Player get player => Game.data.player;
  static bool get isOwner => player.properties.contains(player.positionTile.id);

  static onDealUpdate() {
    double price = 0;

    /// Properties ai will pay
    Game.data.dealData.receiveProperties.forEach((String index) {
      price += max(value(index, Game.data.players[Game.data.dealData.dealer]),
              value(index, Game.data.player)) *
          1.1;
    });

    /// Properties ai will receive
    Game.data.dealData.payProperties.forEach((String index) {
      price -= value(index, Game.data.players[Game.data.dealData.dealer]);
    });
    Game.data.dealData.price = price.floor();
    Game.data.dealData.dealerChecked = true;
  }

  static int value(String prop, Player play) {
    Tile property = Game.data.gmap.firstWhere((element) => element.id == prop);
    double value;
    value = property.price * (Game.data.turn / 20 + 1);
    if (property.level != null && property.housePrice != null) {
      value += property.level * property.housePrice;
    }
    int missing = play.missing(property.idPrefix);
    switch (missing) {
      case 0:
        value *= 20;
        break;
      case 1:
        value *= 1.6;
        value += 250;
        break;
      case 2:
        value *= 1.2;
        value += 100;
        break;
      case 3:
        value * 0.8;
        break;
      default:
    }

    return value.floor();
  }

  static onPlayerTurn() async {
    try {
      Random r = Random();
      Game.move(r.nextInt(6) + 1, r.nextInt(6) + 1);
      Game.save(force: true);
      await Future.delayed(Duration(seconds: 1));

      if (tile.owner != null) {
        Game.act.payRent(player.position, null, true);
      } else {
        switch (Game.data.tile.type) {
          case TileType.land:
            onLand();
            break;
          case TileType.company:
            if (!isOwner) {
              if (player.money > tile.price) {
                if (chance(0.8)) print(Game.act.buy());
              }
            }
            break;
          case TileType.trainstation:
            if (!isOwner) {
              if (player.money > tile.price) {
                if (chance(0.8)) {
                  print(Game.act.buy());
                  tile.transportationPrice = 150 + Random().nextInt(100);
                }
              }
            }
            break;
          case TileType.start:
            break;
          case TileType.chest:
            CardAction action = findings[Game.data.findingsIndex];
            Game.executeEvent(action.func);
            break;
          case TileType.tax:
            Game.act.pay(PayType.pot, tile.price, force: true);
            break;
          case TileType.chance:
            CardAction action = events[Game.data.eventIndex];
            Game.executeEvent(action.func);
            break;
          case TileType.jail:
            break;
          case TileType.parking:
            Game.act.clearPot();
            break;
          case TileType.police:
            break;
        }
      }
      remotelyBuild();
      trade();
      checkJail();

      mortage();
    } finally {
      Alert nextAlert = Game.next();
      if (nextAlert?.failed ?? false) {
        Game.next(force: true);
        print("Normal AI forced next:");
        print(nextAlert);
      }
    }
  }

  static checkJail() {
    if (player.jailed) {
      if (Game.data.turn < 20) {
        if (chance(0.8)) Game.act.buyOutJail();
      } else {
        if (chance(0.2)) Game.act.buyOutJail();
      }
    }
  }

  static mortage() {
    while (player.money < 0) {
      List<String> streetless = player.properties.where((String i) {
        Tile property = Game.data.gmap.firstWhere((element) => element.id == i);
        if (property.hyp == null) return false;
        if (property.mortaged) return false;
        if (player.hasAll(property.idPrefix)) return false;
        return true;
      }).toList();
      List<String> streets = player.properties.where((String i) {
        Tile property = Game.data.gmap.firstWhere((element) => element.id == i);
        ;
        if (property.hyp == null) return false;
        if (property.mortaged) return false;
        if (!player.hasAll(property.idPrefix)) return false;
        return true;
      }).toList();
      if (streetless.isEmpty && streets.isEmpty) {
        Game.setup.defaultPlayer(player);
        return;
      }
      if (streetless.isEmpty) {
        Game.act.mortage(streets[Random().nextInt(streets.length)]);
      } else {
        Game.act.mortage(streetless[Random().nextInt(streetless.length)]);
      }
    }
  }

  static buildHouses(Tile property) {
    if (player.hasAll(tile.idPrefix)) {
      while (property.housePrice < player.money) {
        if (chance(0.1)) break;
        print(Game.build());
      }
    }
  }

  static onLand() {
    if (isOwner) {
      buildHouses(tile);
      return;
    }
    if (tile.price < player.money * 2) {
      if (chance(0.9)) print(Game.act.buy());
      return;
    }
    if (tile.price < player.money + 100) {
      if (chance(0.6)) print(Game.act.buy);
      return;
    }
    if (tile.price < player.money) {
      if (chance(0.4)) print(Game.act.buy);
    }
  }

  static bool chance(double c) {
    if (Random().nextDouble() < c) return true;
    return false;
  }

  static trade() {
    if (Game.data.turn < 5 || chance(1 - player.money / 1000)) {
      return;
    } else
      Game.data.gmap
          .where((Tile t) {
            if (!t.buyable) return false;
            if (t.owner == null) return false;
            return !player.properties.contains(t.id);
          })
          .toList()
          .forEach((Tile prop) {
            if (prop.owner.ai.type == AIType.player) return;
            int price = value(prop.id, player);
            if (player.money > price) {
              int mis = player.missing(prop.idPrefix);
              if (mis == 0) return;
              if (mis == 1) {
                if (chance(0.8)) deal(prop, price);
              } else {
                if (mis == 3) return;
                if (chance(0.1)) {
                  deal(prop, price);
                }
              }
            }
          });
  }

  static deal(Tile prop, int price) {
    if (prop.owner == null) return;
    Game.act.deal(
        dealer: prop.owner.index,
        payAmount: price,
        receiveProperties: [prop.id]);
  }

  static remotelyBuild() {
    if (Game.data.settings.remotelyBuild &&
        ((chance(0.5) && player.money > 200) || player.money > 800)) {
      for (String i in player.properties) {
        Tile property = Game.data.gmap.firstWhere((element) => element.id == i);
        if (property.housePrice == null || property.rent.isEmpty) return;
        if (player.hasAll(property.idPrefix)) {
          if (player.money < property.housePrice) break;
          while (player.money > property.housePrice) {
            if (chance(player.money / property.housePrice * 4) &&
                chance(0.95)) {
              Alert alert = Game.build(property);
              if (alert?.failed ?? false) break;
            } else
              break;
          }
        }
      }
    }
  }
}
