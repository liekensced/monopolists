import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/helpers/progress_helper.dart';

class GameIconHelper {
  static const String gameIconKey = "selectedgameIcon";
  static const String ownedGameIconsKey = "ownedGameIcons";

  static List<String> get ownedGameIcons => box
      .get(ownedGameIconsKey, defaultValue: <String>["circle"]).cast<String>();
  static PlayerIcon addGameIcon() {
    PlayerIcon newGameIcon =
        commonGameIcons[Random().nextInt(commonGameIcons.length)];

    ProgressHelper.tickets -= 50;

    if (!ownedGameIcons.contains(newGameIcon.id))
      box.put(ownedGameIconsKey, [...ownedGameIcons, newGameIcon.id]);

    return newGameIcon;
  }

  static Box get box => Hive.box(MainBloc.ACCOUNTBOX);
  static PlayerIcon get selectedGameIcon => commonGameIcons.firstWhere(
      (element) =>
          element.id ==
          box.get(gameIconKey, defaultValue: commonGameIcons.first.id),
      orElse: () => commonGameIcons.first);
  static set selectedGameIcon(PlayerIcon value) {
    box.put(gameIconKey, value.id);
  }
}

class PlayerIcon {
  final String name;
  // Should never change!
  final String id;
  final IconData data;
  const PlayerIcon({
    @required this.id,
    @required this.name,
    @required this.data,
  });
}

List<PlayerIcon> commonGameIcons = [
  PlayerIcon(
    name: "Circle",
    id: "circle",
    data: FontAwesomeIcons.circle,
  ),
  PlayerIcon(
    name: "Apple",
    id: "apple",
    data: FontAwesomeIcons.appleAlt,
  ),
  PlayerIcon(
    name: "Atom",
    id: "atom",
    data: FontAwesomeIcons.atom,
  ),
  PlayerIcon(
    name: "Cyclist",
    id: "bike",
    data: FontAwesomeIcons.biking,
  ),
  PlayerIcon(
    name: "Magical** Broom",
    id: "broom",
    data: FontAwesomeIcons.broom,
  ),
  PlayerIcon(
    name: "Meow",
    id: "cat",
    data: FontAwesomeIcons.cat,
  ),
  PlayerIcon(
    name: "Intentional bug",
    id: "bug",
    data: FontAwesomeIcons.bug,
  ),
  PlayerIcon(
    name: "Car",
    id: "car",
    data: FontAwesomeIcons.carSide,
  ),
  PlayerIcon(
    name: "Caravan",
    id: "caravan",
    data: FontAwesomeIcons.caravan,
  ),
  PlayerIcon(
    name: "Chess bishop",
    id: "chessBishop",
    data: FontAwesomeIcons.chessBishop,
  ),
  PlayerIcon(
    name: "Chess king",
    id: "chessKing",
    data: FontAwesomeIcons.chessKing,
  ),
  PlayerIcon(
    name: "Chess knight",
    id: "chessKnight",
    data: FontAwesomeIcons.chessKnight,
  ),
  PlayerIcon(
    name: "Chess pawn",
    id: "chessPawn",
    data: FontAwesomeIcons.chessPawn,
  ),
  PlayerIcon(
    name: "Chess Queen",
    id: "chessQueen",
    data: FontAwesomeIcons.chessQueen,
  ),
  PlayerIcon(
    name: "Chess Rook",
    id: "chessRook",
    data: FontAwesomeIcons.chessRook,
  ),
  PlayerIcon(
    name: "Dog",
    id: "dog",
    data: FontAwesomeIcons.dog,
  ),
  PlayerIcon(
    name: "Bird",
    id: "dove",
    data: FontAwesomeIcons.dove,
  ),
  PlayerIcon(
    name: "Fighter Jet",
    id: "fighterJet",
    data: FontAwesomeIcons.fighterJet,
  ),
  PlayerIcon(name: "Blub", id: "fish", data: FontAwesomeIcons.fish),
  PlayerIcon(name: "Ghost", id: "ghost", data: FontAwesomeIcons.ghost),
  PlayerIcon(
      name: "Apache Helicopter",
      id: "helicopter",
      data: FontAwesomeIcons.helicopter),
  PlayerIcon(name: "Hippo", id: "hippo", data: FontAwesomeIcons.hippo),
  PlayerIcon(name: "Horsey", id: "horseHead", data: FontAwesomeIcons.horseHead),
  PlayerIcon(
      name: "Ice Cream", id: "iceCream", data: FontAwesomeIcons.iceCream),
  PlayerIcon(
      name: "Motorcycle", id: "motorcycle", data: FontAwesomeIcons.motorcycle),
  PlayerIcon(
      name: "The best plane",
      id: "paperPlane",
      data: FontAwesomeIcons.paperPlane),
  PlayerIcon(name: "Plane", id: "plane", data: FontAwesomeIcons.plane),
  PlayerIcon(name: "Snowplow", id: "snowplow", data: FontAwesomeIcons.snowplow),
  PlayerIcon(name: "Tractor", id: "tractor", data: FontAwesomeIcons.tractor),
  PlayerIcon(
      name: "Truck Monster",
      id: "truckMonster",
      data: FontAwesomeIcons.truckMonster),
  PlayerIcon(name: "Just a breeze", id: "wind", data: FontAwesomeIcons.wind),
];
