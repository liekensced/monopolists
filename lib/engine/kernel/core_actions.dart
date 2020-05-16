import 'package:flutter/foundation.dart';
import 'package:plutopoly/bloc/main_bloc.dart';

import '../data/info.dart';
import '../data/main.dart';
import '../data/map.dart';
import '../data/player.dart';
import '../ui/alert.dart';
import 'main.dart';

enum PayType { rent, bank, pot, pay }

class CoreActions {
  GameData get data => Game.data;
  CoreActions();

  Alert mortage(int tileIndex) {
    Alert alert;
    Tile tile = data.gmap[tileIndex];
    if (tile.hyp == null)
      return Alert("Couldn't mortage", "You can't mortage this tile.");
    bool _mortaged = tile.mortaged;
    if (_mortaged) {
      alert = pay(PayType.bank, (tile.hyp * 1.1).toInt(), shouldSave: false);
      if (alert != null) return alert;
      tile.mortaged = false;
      alert = Alert.snackBar("Lifted mortaged " + tile.name);
    } else {
      pay(PayType.bank, -tile.hyp);
      tile.mortaged = true;
      alert = Alert.snackBar("Mortaged " + tile.name);
    }
    Game.save(
        exclude: [SaveData.dealData.toString(), SaveData.settings.toString()]);
    return alert;
  }

  /// Doesn't update gmap, lostPlayers, dealData,
  Alert pay(PayType type, int amount,
      {int receiver,
      bool count: false,
      bool force: false,
      bool shouldSave: true}) {
    if (!force) {
      if (amount > 0) {
        if (data.player.money < amount) return Alert.funds();
      } else if (amount < 0 && receiver != null) {
        Player _player = data.players[receiver];
        if (_player.money < -amount) return Alert.funds(_player);
      }
    }
    if (count) Game.bank.onCountedPay(amount);
    if (receiver != null) data.players[receiver].money += amount;
    data.player.money -= amount;
    switch (type) {
      case PayType.rent:
        data.rentPayed = true;
        Game.addInfo(
            UpdateInfo(
                title: "Rent received from ${data.player.name}: £$amount",
                leading: "rent"),
            receiver);
        break;
      case PayType.pot:
        data.rentPayed = true;
        data.pot += amount;
        break;
      default:
    }
    if (shouldSave) {
      Game.save(excludeBasic: true);
    }
    return null;
  }

  Alert clearPot() {
    data.player.money += data.pot;
    data.pot = 0;
    Game.save(only: [SaveData.players.toString(), "pot"]);
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
    Game.save(only: [SaveData.players.toString(), "doublesThrown"]);
    return null;
  }

  Alert buyOutJail() {
    Alert alert = pay(PayType.pot, 50, shouldSave: false);
    if (alert == null) {
      Game.helper.undoubleDices();
      data.doublesThrown = 0;
      data.player.jailed = false;
      Game.save(excludeBasic: true);
    }

    return alert;
  }

  Alert payRent(int tileIndex, [int payPrice, bool force = false]) {
    Tile tile = data.gmap[tileIndex];
    int price = payPrice ?? tile.currentRent;
    int receiver = tile.owner.index;
    return pay(PayType.rent, price,
        receiver: receiver, count: true, force: force);
  }

  Alert deal({
    int payAmount: 0,
    List<int> payProperties: const <int>[],
    List<int> receiveProperties: const <int>[],
    @required int dealer,
  }) {
    if (payAmount != null) {
      Alert alert =
          pay(PayType.pay, payAmount, receiver: dealer, shouldSave: false);
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
    Game.save(excludeBasic: true);
    return null;
  }

  Alert buy([int price, int prop]) {
    Alert alert;
    if (prop == null) prop = data.player.position;
    if (price == null) price = data.gmap[prop].price;
    if (data.gmap[prop].owner != null) {
      return Alert("Couldn't buy", "The property is already owned");
    }
    if (data.gmap[prop].type == TileType.land ||
        data.gmap[prop].type == TileType.trainstation ||
        data.gmap[prop].type == TileType.company) {
      alert = pay(PayType.bank, price, count: true, shouldSave: false);
      if (alert != null) return alert;
      data.player.properties.add(prop);
      data.player.properties.sort();
      Game.save(exclude: [
        SaveData.settings.toString(),
        SaveData.dealData.toString(),
        SaveData.lostPlayers.toString(),
      ]);
    } else {
      return Alert("Couldn't buy", "The property is from the wrong type.");
    }
    return null;
  }
}
