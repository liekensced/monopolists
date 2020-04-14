import 'package:flutter/foundation.dart';

import '../data/info.dart';
import '../data/main.dart';
import '../data/map.dart';
import '../data/player.dart';
import '../ui/alert.dart';
import 'main.dart';

enum payType { rent, bank, pot, pay }

class CoreActions {
  GameData get data => Game.data;
  CoreActions();
  Alert pay(payType type, int amount, [int receiver]) {
    if (amount > 0) {
      if (data.player.money < amount) return Alert.funds();
    } else if (amount < 0) {
      Player _player = data.players[receiver];
      if (_player.money < -amount) return Alert.funds(_player);
    }
    data.player.money -= amount;
    switch (type) {
      case payType.rent:
        data.rentPayed = true;
        data.players[receiver].money += amount;
        data.players[receiver].info[data.turn].add(Info(
            title: "Rent received from ${data.player.name}: £$amount",
            leading: "rent"));
        break;
      case payType.pot:
        data.rentPayed = true;
        data.pot += amount;
        break;
      default:
    }
    Game.save();
    return null;
  }

  Alert clearPot() {
    data.player.money += data.pot;
    data.pot = 0;
    Game.save();
    return Alert.snackBar("Emptied pot");
  }

  Alert useGoojCard() {
    if (Game.data.player.goojCards <= 0)
      return Alert("No prison card",
          "You don't have a get out of prison card. Try to throw a double or buy yourself out.");
    data.player.goojCards--;
    Game.helper.undoubleDices();
    data.doublesThrown = 0;
    data.player.jailed = false;
    Game.save();
    return null;
  }

  Alert buyOutJail() {
    Alert alert = pay(payType.pot, 50);
    if (alert == null) {
      Game.helper.undoubleDices();
      data.doublesThrown = 0;
      data.player.jailed = false;
      Game.save();
    }

    return alert;
  }

  Alert payRent(int tileIndex, [int payPrice]) {
    Tile tile = data.gmap[tileIndex];
    int price = payPrice ?? tile.currentRent;
    int receiver = tile.owner.index;
    return pay(payType.rent, price, receiver);
  }

  Alert deal({
    int payAmount: 0,
    List<int> payProperties: const <int>[],
    List<int> receiveProperties: const <int>[],
    @required int dealer,
  }) {
    if (payAmount != null) {
      Alert alert = pay(payType.pay, payAmount, dealer);
      if (alert != null) {
        return alert;
      }
    }
    if (payProperties != null) {
      for (int i = 0; i < payProperties.length | 0; i++) {
        data.player.properties.remove(payProperties[i]);
        data.players[dealer].properties.add(payProperties[i]);
      }
    }
    if (receiveProperties != null) {
      for (int i = 0; i < receiveProperties.length; i++) {
        data.players[dealer].properties.remove(receiveProperties[i]);
        data.player.properties.add(receiveProperties[i]);
      }
    }
    data.player.properties.sort();
    data.players[dealer].properties.sort();
    Game.save();
    return null;
  }

  Alert buy([int price, int prop]) {
    if (prop == null) prop = data.player.position;
    if (price == null) price = data.gmap[prop].price;
    if (data.gmap[prop].owner != null) {
      return Alert("Couldn't buy", "The property is already owned");
    }
    if (data.gmap[prop].type == TileType.land ||
        data.gmap[prop].type == TileType.trainstation ||
        data.gmap[prop].type == TileType.company) {
      data.player.money -= price;
      data.player.properties.add(prop);
      data.player.properties.sort();
      Game.save();
    } else {
      return Alert("Couldn't buy", "The property is from the wrong type.");
    }
    return null;
  }
}
