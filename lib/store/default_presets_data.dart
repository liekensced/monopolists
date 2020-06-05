import 'package:flutter/material.dart';

Map<String, dynamic> buildTrainstation(int street, int index) {
  String name = "";
  int color = 0;
  switch (street) {
    case 0:
      name = "Rusty";
      color = Colors.deepOrange.value;
      break;
    case 2:
      name = "Old";
      color = Colors.brown.value;

      break;
    case 1:
      name = "Monochrome";
      color = Colors.black.value;

      break;
    case 2:
      name = "Rural";
      color = Colors.green.value;

      break;
  }
  return {
    "type": "trainstation",
    "color": color,
    "idPrefix": "BTr",
    "name": "$name Trainstation $index",
    "price": 200,
    "hyp": 100,
    "housePrice": null,
    "rent": [25, 50, 100, 200, 400, 800],
    "level": 0,
    "idIndex": index,
    "mortaged": false,
    "description": null,
    "transportationPrice": 200,
    "backgroundColor": null
  };
}

Map<String, dynamic> presetsMap = {
  "default.trainstations": {
    "running": null,
    "players": [
      {
        "name": "Player 1",
        "money": 1500,
        "position": 0,
        "color": 4294198070,
        "properties": [],
        "jailed": false,
        "jailTries": 0,
        "goojCards": 0,
        "info": [],
        "code": -1,
        "debt": 0,
        "loans": [],
        "stock": {},
        "ai": {"type": "player"}
      },
      {
        "name": "Ricardo",
        "money": 1500,
        "position": 0,
        "color": 4293467747,
        "properties": [],
        "jailed": false,
        "jailTries": 0,
        "goojCards": 0,
        "info": [],
        "moneyHistory": [],
        "code": -2,
        "debt": 0,
        "loans": [],
        "stock": {},
        "ai": {"type": "normal"}
      },
      {
        "name": "August",
        "money": 1500,
        "position": 0,
        "color": 4278190080,
        "properties": [],
        "jailed": false,
        "jailTries": 0,
        "goojCards": 0,
        "info": [],
        "moneyHistory": [],
        "code": -2,
        "debt": 0,
        "loans": [],
        "stock": {},
        "ai": {"type": "normal"}
      },
      {
        "name": "Daisy",
        "money": 1500,
        "position": 0,
        "color": 4278190080,
        "properties": [],
        "jailed": false,
        "jailTries": 0,
        "goojCards": 0,
        "info": [],
        "moneyHistory": [],
        "code": -2,
        "debt": 0,
        "loans": [],
        "stock": {},
        "ai": {"type": "normal"}
      }
    ],
    "currentPlayer": 0,
    "turn": 1,
    "currentDices": [1, -1],
    "doublesThrown": 0,
    "pot": 0,
    "gmap": [
      {
        "type": "start",
        "color": null,
        "idPrefix": "TileType.start",
        "name": null,
        "price": null,
        "hyp": null,
        "housePrice": null,
        "rent": null,
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      buildTrainstation(0, 0),
      buildTrainstation(1, 0),
      buildTrainstation(2, 0),
      {
        "type": "land",
        "color": Colors.brown.value,
        "idPrefix": "hq",
        "name": "Aberdeen",
        "price": 60,
        "hyp": 30,
        "housePrice": 50,
        "rent": [2, 10, 30, 90, 160, 250],
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description": "A rural town. Known for it's oil.",
        "transportationPrice": 200,
        "backgroundColor": null
      },
      buildTrainstation(3, 0),
      {
        "type": "chest",
        "color": 4294967295,
        "idPrefix": "CC",
        "name": null,
        "price": null,
        "hyp": null,
        "housePrice": null,
        "rent": null,
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": 4279060385
      },
      {
        "type": "tax",
        "color": null,
        "idPrefix": "tax",
        "name": null,
        "price": 200,
        "hyp": null,
        "housePrice": null,
        "rent": null,
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "chance",
        "color": null,
        "idPrefix": "Ch",
        "name": null,
        "price": null,
        "hyp": null,
        "housePrice": null,
        "rent": null,
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": 4294922834
      },
      {
        "type": "land",
        "color": 4278430196,
        "idPrefix": "LB",
        "name": "Light blue 1",
        "price": 100,
        "hyp": 50,
        "housePrice": 50,
        "rent": [6, 30, 90, 270, 400, 550],
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "land",
        "color": 4278430196,
        "idPrefix": "LB",
        "name": "Light Blue 2",
        "price": 100,
        "hyp": 50,
        "housePrice": 50,
        "rent": [6, 30, 90, 270, 400, 550],
        "level": 0,
        "idIndex": 2,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "land",
        "color": 4278430196,
        "idPrefix": "LB",
        "name": "Light Blue 3",
        "price": 120,
        "hyp": 60,
        "housePrice": 50,
        "rent": [8, 40, 100, 300, 450, 600],
        "level": 0,
        "idIndex": 3,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "jail",
        "color": null,
        "idPrefix": "JAIL",
        "name": null,
        "price": null,
        "hyp": null,
        "housePrice": null,
        "rent": null,
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "land",
        "color": 4288423856,
        "idPrefix": "P",
        "name": "Purple 1",
        "price": 140,
        "hyp": 70,
        "housePrice": 100,
        "rent": [10, 50, 150, 450, 625, 750],
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "company",
        "color": null,
        "idPrefix": "C",
        "name": "Elektric Company",
        "price": 150,
        "hyp": 75,
        "housePrice": null,
        "rent": null,
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "land",
        "color": 4288423856,
        "idPrefix": "P",
        "name": "Purple 2",
        "price": 140,
        "hyp": 70,
        "housePrice": 100,
        "rent": [10, 50, 150, 450, 625, 750],
        "level": 0,
        "idIndex": 2,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "land",
        "color": 4288423856,
        "idPrefix": "P",
        "name": "Purple 3",
        "price": 160,
        "hyp": 80,
        "housePrice": 100,
        "rent": [12, 60, 180, 500, 700, 900],
        "level": 0,
        "idIndex": 3,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "trainstation",
        "color": null,
        "idPrefix": "T",
        "name": "Trainstation 2",
        "price": 200,
        "hyp": null,
        "housePrice": null,
        "rent": [25, 50, 100, 250],
        "level": 0,
        "idIndex": 2,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "land",
        "color": 4294940672,
        "idPrefix": "O",
        "name": "Orange 1",
        "price": 180,
        "hyp": 90,
        "housePrice": 100,
        "rent": [14, 70, 200, 550, 750, 950],
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "chest",
        "color": 4294967295,
        "idPrefix": "CC",
        "name": null,
        "price": null,
        "hyp": null,
        "housePrice": null,
        "rent": null,
        "level": 0,
        "idIndex": 2,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": 4279060385
      },
      {
        "type": "land",
        "color": 4294940672,
        "idPrefix": "O",
        "name": "Orange 2",
        "price": 180,
        "hyp": 90,
        "housePrice": 100,
        "rent": [14, 70, 200, 550, 750, 950],
        "level": 0,
        "idIndex": 2,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "land",
        "color": 4294940672,
        "idPrefix": "O",
        "name": "Orange 3",
        "price": 200,
        "hyp": 100,
        "housePrice": 100,
        "rent": [16, 80, 220, 600, 800, 1000],
        "level": 0,
        "idIndex": 3,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "parking",
        "color": null,
        "idPrefix": "PARK",
        "name": null,
        "price": null,
        "hyp": null,
        "housePrice": null,
        "rent": null,
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "land",
        "color": 4294198070,
        "idPrefix": "R",
        "name": "Red 1",
        "price": 220,
        "hyp": 110,
        "housePrice": 150,
        "rent": [18, 90, 250, 700, 875, 1050],
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "chance",
        "color": null,
        "idPrefix": "Ch",
        "name": null,
        "price": null,
        "hyp": null,
        "housePrice": null,
        "rent": null,
        "level": 0,
        "idIndex": 2,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "land",
        "color": 4294198070,
        "idPrefix": "R",
        "name": "Red 2",
        "price": 220,
        "hyp": 110,
        "housePrice": 150,
        "rent": [18, 90, 250, 700, 875, 1050],
        "level": 0,
        "idIndex": 2,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "land",
        "color": 4294198070,
        "idPrefix": "R",
        "name": "Red 3",
        "price": 240,
        "hyp": 120,
        "housePrice": 150,
        "rent": [20, 100, 300, 750, 925, 1100],
        "level": 0,
        "idIndex": 3,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "trainstation",
        "color": null,
        "idPrefix": "T",
        "name": "Trainstation 3",
        "price": 200,
        "hyp": 100,
        "housePrice": null,
        "rent": [25, 50, 100, 250],
        "level": 0,
        "idIndex": 3,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "land",
        "color": 4294951175,
        "idPrefix": "Y",
        "name": "Yellow 1",
        "price": 260,
        "hyp": 130,
        "housePrice": 150,
        "rent": [22, 110, 330, 800, 975, 1150],
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "land",
        "color": 4294951175,
        "idPrefix": "Y",
        "name": "Yellow 2",
        "price": 260,
        "hyp": 130,
        "housePrice": 150,
        "rent": [22, 110, 330, 800, 975, 1150],
        "level": 0,
        "idIndex": 2,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "company",
        "color": null,
        "idPrefix": "C",
        "name": "Water company",
        "price": 150,
        "hyp": 75,
        "housePrice": null,
        "rent": null,
        "level": 0,
        "idIndex": 2,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "land",
        "color": 4294951175,
        "idPrefix": "Y",
        "name": "Yellow 3",
        "price": 280,
        "hyp": 140,
        "housePrice": 150,
        "rent": [24, 120, 360, 850, 1025, 1200],
        "level": 0,
        "idIndex": 3,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "police",
        "color": null,
        "idPrefix": "POL",
        "name": null,
        "price": null,
        "hyp": null,
        "housePrice": null,
        "rent": null,
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "land",
        "color": 4283215696,
        "idPrefix": "G",
        "name": "Green 1",
        "price": 300,
        "hyp": 150,
        "housePrice": 200,
        "rent": [26, 130, 390, 900, 1100, 1275],
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "land",
        "color": 4283215696,
        "idPrefix": "G",
        "name": "Green 2",
        "price": 300,
        "hyp": 150,
        "housePrice": 200,
        "rent": [26, 130, 390, 900, 1100, 1250],
        "level": 0,
        "idIndex": 2,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "chest",
        "color": 4294967295,
        "idPrefix": "CC",
        "name": null,
        "price": null,
        "hyp": null,
        "housePrice": null,
        "rent": null,
        "level": 0,
        "idIndex": 3,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": 4279060385
      },
      {
        "type": "land",
        "color": 4283215696,
        "idPrefix": "G",
        "name": "Green 3",
        "price": 320,
        "hyp": 160,
        "housePrice": 200,
        "rent": [28, 150, 450, 1000, 1200, 1400],
        "level": 0,
        "idIndex": 3,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "trainstation",
        "color": null,
        "idPrefix": "T",
        "name": "Trainstation 4",
        "price": 200,
        "hyp": 100,
        "housePrice": null,
        "rent": [25, 50, 100, 250],
        "level": 0,
        "idIndex": 4,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "chance",
        "color": null,
        "idPrefix": "Ch",
        "name": null,
        "price": null,
        "hyp": null,
        "housePrice": null,
        "rent": null,
        "level": 0,
        "idIndex": 3,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "land",
        "color": 4279060385,
        "idPrefix": "DB",
        "name": "Dark Blue 1",
        "price": 350,
        "hyp": 175,
        "housePrice": 200,
        "rent": [35, 175, 500, 1100, 1300, 1500],
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "tax",
        "color": null,
        "idPrefix": "tax",
        "name": null,
        "price": 100,
        "hyp": null,
        "housePrice": null,
        "rent": null,
        "level": 0,
        "idIndex": 2,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      },
      {
        "type": "land",
        "color": 4279060385,
        "idPrefix": "DB",
        "name": "Dark Blue 2",
        "price": 400,
        "hyp": 200,
        "housePrice": 200,
        "rent": [50, 200, 600, 1400, 1700, 2000],
        "level": 0,
        "idIndex": 2,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null
      }
    ],
    "settings": {
      "name": "Game 1",
      "remotelyBuild": true,
      "goBonus": 200,
      "maxTurnes": 99999,
      "mustAuction": false,
      "startingMoney": 1500,
      "hackerScreen": true,
      "interest": 10,
      "dtlPrice": 1500,
      "startProperties": 0,
      "transportPassGo": true,
      "allowDiceSelect": false,
      "allowPriceChanges": false
    },
    "extensions": [],
    "ui": {"screenState": "idle", "showDealScreen": false, "shouldMove": true},
    "rentPayed": false,
    "findingsIndex": 1,
    "eventIndex": 5,
    "mapConfiguration": "classic",
    "dealData": {
      "payAmount": 0,
      "receivableProperties": [],
      "receiveProperties": [],
      "payableProperties": [],
      "payProperties": [],
      "price": 0,
      "valid": [true, true],
      "playerChecked": false,
      "dealerChecked": false,
      "dealer": null
    },
    "bankData": null,
    "version": "0.4.2",
    "lostPlayers": [],
    "bot": false,
    "transported": false
  }
};
