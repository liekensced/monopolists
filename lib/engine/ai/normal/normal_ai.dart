import 'dart:math';

import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/engine/commands/parser.dart';
import 'package:plutopoly/engine/data/extensions.dart';
import 'package:plutopoly/engine/extensions/lake_drain_extension.dart';

import '../../data/actions.dart';
import '../../data/map.dart';
import '../../data/player.dart';
import '../../kernel/core_actions.dart';
import '../../kernel/main.dart';
import '../../ui/alert.dart';
import '../ai.dart';
import '../ai_type.dart';
import '../../data/main_data.dart';

class NormalAI {
  static Tile get tile => Game.data.tile;
  static Player get player => Game.data.player;
  static bool get isOwner => player.properties.contains(player.positionTile.id);
  static AISettings get aiSettings => player.ai.aiSettings;
  static bool get isSmart => aiSettings.smart ?? false;

  static onDealUpdate() {
    AISettings settings =
        Game.data.players[Game.data.dealData.dealer].ai.aiSettings;
    double price = 0;

    /// Properties ai will pay
    Game.data.dealData.receiveProperties.forEach((String index) {
      price += max(
                  value(index, Game.data.players[Game.data.dealData.dealer],
                      settings),
                  value(index, player)) *
              settings.dealFactor ??
          1.05;
    });

    /// Properties ai will receive
    Game.data.dealData.payProperties.forEach((String index) {
      price -=
          value(index, Game.data.players[Game.data.dealData.dealer], settings);
    });
    Game.data.dealData.price = price.floor();
    Game.data.dealData.dealerChecked = true;
  }

  static int value(String prop, Player play, [AISettings settings]) {
    Tile property = Game.data.gmap.firstWhere((element) => element.id == prop);
    double value;
    value = property.price * (Game.data.turn / 40 + 1);
    if (property.level != null && property.housePrice != null) {
      value += property.level * property.housePrice;
    }
    if (Game.data.extensions.contains(Extension.transportation)) {
      value *= 1.5;
      if (Game.data.settings.transportPassGo) {
        value += Game.data.settings.goBonus;
      }
    }

    int missing = play.missing(property.idPrefix);
    switch (missing) {
      case 0:
        value *= 20;
        break;
      case 1:
        value *= 1.5;
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

  static extensions() {
    if (Game.data.extensions.contains(Extension.stock)) {
      if (isSmart) player.money *= 1.02;
    }
    if (Game.data.extensions.contains(Extension.drainTheLake) &&
        LakeDrain.canDrain) {
      if (chance((player.money / Game.data.settings.dtlPrice) - 2.2)) {
        print(LakeDrain.drain());
      }
    }
  }

  static onPlayerTurn() async {
    try {
      if (aiSettings.idle ?? false) throw 'idle';
      Game.save(force: true);
      //check wheter the game has changed
      GameData check = Game.data;
      if (!Game.testing) await Future.delayed(Duration(milliseconds: 1000));
      if (check != Game.data && !MainBloc.online) return;

      Random r = Random();
      Game.move(r.nextInt(6) + 1, r.nextInt(6) + 1);

      onTile();
      remotelyBuild();
      if (aiSettings?.canTrade ?? true) trade();
      checkJail();
      mortage();
      extensions();
      player.money *= aiSettings.moneyFactor ?? 1;
    } catch (e) {
      print(e);
    } finally {
      Game.save(force: true);
      if (!Game.testing) await Future.delayed(Duration(seconds: 1));

      Alert nextAlert = Game.next();
      if (nextAlert?.failed ?? false) {
        Game.next(force: true);
        print("Normal AI forced next:");
        print(nextAlert);
      }
    }
  }

  static void onTile() {
    if (tile.owner != null && !isOwner) {
      Game.act.payRent(player.position, null, true);
    } else {
      switch (Game.data.tile.type) {
        case TileType.action:
          if ((tile.actionRequired ?? true) ||
              chance(0.5) && tile.actions.isNotEmpty) {
            CommandParser.parse(
              tile.actions[Random().nextInt(tile.actions.length)].command,
              true,
            );
          }
          break;
        case TileType.land:
          onLand();
          break;
        case TileType.company:
          if (!isOwner) {
            if (player.money > tile.price) {
              if (chance(player.ai.aiSettings.chances[1]))
                print(Game.act.buy());
            }
          }
          break;
        case TileType.trainstation:
          if (!isOwner) {
            if (player.money > tile.price) {
              if (chance(player.ai.aiSettings.chances[1])) {
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
          if (chance((aiSettings.smart ?? false) ? 0 : 0.1)) {
            Game.act.pay(PayType.pot, 50, force: true);
          }
          Game.executeEvent(action.func);
          if (!Game.data.rentPayed) onTile();
          break;
        case TileType.tax:
          Game.act.pay(PayType.pot, tile.price, force: true);
          break;
        case TileType.chance:
          CardAction action = events[Game.data.eventIndex];
          if (chance((player.ai.aiSettings.smart ?? false) ? 0 : 0.1)) {
            Game.act.pay(PayType.pot, 100, force: true);
          }
          Game.executeEvent(action.func);
          if (!Game.data.rentPayed) onTile();

          break;
        case TileType.jail:
          break;
        case TileType.parking:
          if (chance(player.ai.aiSettings.chances[0] ?? 0.9))
            Game.act.clearPot();
          break;
        case TileType.police:
          Game.helper.jail(Game.data.player, shouldSave: true);
          break;
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

        if (property.hyp == null) return false;
        if (property.mortaged) return false;
        if (!player.hasAll(property.idPrefix)) return false;
        return true;
      }).toList();
      if (streetless.isEmpty && streets.isEmpty) {
        Game.setup.defaultPlayer(player, false);
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
        if (chance(player.ai.aiSettings.chances[3])) break;
        print(Game.build());
      }
    }
  }

  static onLand() {
    if (isOwner) {
      buildHouses(tile);
      return;
    }
    if (tile.price * 2 < player.money) {
      if (chance(0.9 - aiSettings.chances[2])) print(Game.act.buy());
      return;
    }
    if (tile.price + 100 < player.money) {
      if (chance(0.6 - aiSettings.chances[2])) print(Game.act.buy);
      return;
    }
    if (tile.price < player.money) {
      if (chance(0.4 - aiSettings.chances[2])) print(Game.act.buy);
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
            return !player.properties.contains(t.id);
          })
          .toList()
          .forEach((Tile prop) {
            Player owner = prop.owner;
            if (owner == null) return;
            if (owner.ai.type == AIType.player) return;
            if (!(owner.ai.aiSettings.canTrade ?? true)) return;
            if (owner.hasAll(prop.idPrefix)) return;
            int price = max(value(prop.id, player), value(prop.id, prop.owner));
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
      Game.data.gmap.forEach((property) {
        if (!player.properties.contains(property.id)) return;
        if (property.housePrice == null || property.rent.isEmpty) return;
        if (player.hasAll(property.idPrefix)) {
          if (player.money < property.housePrice) return;
          while (player.money > property.housePrice) {
            if (chance(player.money /
                    property.housePrice *
                    4 *
                    player.ai.aiSettings.chances[4]) &&
                chance(0.9)) {
              Alert alert = Game.build(property);
              if (alert?.failed ?? false) return;
            } else
              return;
          }
        }
      });
    }
  }
}
