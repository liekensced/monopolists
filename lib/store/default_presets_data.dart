import 'package:flutter/material.dart';

buildTrain(int index, [Color color]) {
  return {
    "type": "trainstation",
    "color": null,
    "idPrefix": "T",
    "name": "Trainstation $index",
    "price": 200,
    "hyp": 100,
    "housePrice": null,
    "rent": [25, 50, 100, 200],
    "level": 0,
    "idIndex": index,
    "mortaged": false,
    "description": null,
    "transportationPrice": 200,
  };
}

Map<String, dynamic> presetsData = {
  "default.trainstations": {
    "preset": "default.trainstations",
    "running": false,
    "players": [
      {
        "name": "Ricardo",
        "money": 1000,
        "position": 0,
        "color": Colors.cyan.value,
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
        "money": 1000,
        "position": 0,
        "color": Colors.blueGrey.value,
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
        "money": 1000,
        "position": 0,
        "color": Colors.deepPurple.value,
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
        "description": "This is the start tile of the game.",
        "transportationPrice": 200,
        "backgroundColor": null,
      },
      {
        "type": "land",
        "color": 4294951175,
        "idPrefix": "Y",
        "name": "Wallworth",
        "price": 350,
        "hyp": 130,
        "housePrice": 150,
        "rent": [22, 110, 330, 800, 975, 1150],
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description": "A big city. Known for it's oil lamps.",
        "transportationPrice": 200,
        "backgroundColor": null,
      },
      {
        "type": "tax",
        "color": null,
        "idPrefix": "tax",
        "name": null,
        "price": -100,
        "hyp": null,
        "housePrice": null,
        "rent": null,
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description": "You bring in a bounty +£100!",
        "transportationPrice": 200,
        "backgroundColor": null,
      },
      {
        "type": "land",
        "color": 4294951175,
        "idPrefix": "Y",
        "name": "Delinosa",
        "price": 350,
        "hyp": 130,
        "housePrice": 150,
        "rent": [22, 110, 330, 800, 975, 1150],
        "level": 0,
        "idIndex": 2,
        "mortaged": false,
        "description":
            "A pretty large city. It had the first railway connection with Berbury.",
        "transportationPrice": 200,
        "backgroundColor": null,
      },
      buildTrain(1, Colors.grey),
      buildTrain(2, Colors.grey),
      {
        "type": "land",
        "color": 4294951175,
        "idPrefix": "Y",
        "name": "Hastter",
        "price": 380,
        "hyp": 140,
        "housePrice": 150,
        "rent": [24, 120, 360, 850, 1025, 1200],
        "level": 0,
        "idIndex": 3,
        "mortaged": false,
        "description":
            "The capital of the yellow street. Known for it's banking services.",
        "transportationPrice": 200,
        "backgroundColor": null,
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
        "backgroundColor": 4294922834,
      },
      {
        "type": "land",
        "color": 4283215696,
        "idPrefix": "G",
        "name": "Greenworth",
        "price": 400,
        "hyp": 150,
        "housePrice": 200,
        "rent": [26, 130, 390, 900, 1100, 1275],
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description":
            "A big city with a giant central park. Known for its cotton industry",
        "transportationPrice": 200,
        "backgroundColor": null,
      },
      buildTrain(3, Colors.grey),
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
        "backgroundColor": null,
      },
      {
        "type": "land",
        "color": 4283215696,
        "idPrefix": "G",
        "name": "Tulman",
        "price": 400,
        "hyp": 150,
        "housePrice": 200,
        "rent": [26, 130, 390, 900, 1100, 1250],
        "level": 0,
        "idIndex": 2,
        "mortaged": false,
        "description": "A grey city known for it's metal industry.",
        "transportationPrice": 200,
        "backgroundColor": null,
      },
      {
        "type": "chest",
        "idPrefix": "CC",
        "name": null,
        "price": null,
        "hyp": null,
        "housePrice": null,
        "rent": null,
        "level": 0,
        "idIndex": 0,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": 4279060385,
      },
      {
        "type": "land",
        "color": 4283215696,
        "idPrefix": "G",
        "name": "Berbury",
        "price": 450,
        "hyp": 160,
        "housePrice": 200,
        "rent": [28, 150, 450, 1000, 1200, 1400],
        "level": 0,
        "idIndex": 3,
        "mortaged": false,
        "description":
            "A pretty large city. It had the first railway connection with Delinosa.",
        "transportationPrice": 200,
        "backgroundColor": null,
      },
      buildTrain(4, Colors.grey),
      buildTrain(5, Colors.grey),
      {
        "type": "company",
        "color": Colors.black.value,
        "idPrefix": "C",
        "name": "South coal mine",
        "icon": "bolt",
        "price": 150,
        "hyp": 75,
        "housePrice": null,
        "rent": [5, 10, 15, 30, 50],
        "level": 0,
        "idIndex": 0,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
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
        "backgroundColor": null,
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
        "description": "You've been robbed by a bandid.",
        "transportationPrice": 200,
        "backgroundColor": null,
      },
      {
        "type": "company",
        "color": null,
        "idPrefix": "C",
        "name": "Dry Water company",
        "rent": [4, 8, 15, 30, 50],
        "price": 150,
        "hyp": 75,
        "housePrice": null,
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description":
            "Best water company in the world. You have to do the rent times the dice eyes.",
        "transportationPrice": 200,
        "backgroundColor": null,
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
        "idIndex": 3,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
        "backgroundColor": null,
      },
      {
        "type": "land",
        "color": Colors.brown.value,
        "idPrefix": "O",
        "name": "Twin Scar 1",
        "price": 100,
        "hyp": 90,
        "housePrice": 100,
        "rent": [10, 20, 35, 50, 60, 70, 100, 200, 550, 750, 950],
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description":
            "Twin scar is a rural outpost. It does have potential given enough funding.",
        "transportationPrice": 200,
        "backgroundColor": null,
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
        "backgroundColor": null,
      },
      {
        "type": "land",
        "color": Colors.brown.value,
        "idPrefix": "O",
        "name": "Twin Scar 2",
        "price": 100,
        "hyp": 90,
        "housePrice": 100,
        "rent": [10, 20, 35, 50, 60, 70, 100, 200, 550, 750, 950],
        "level": 0,
        "idIndex": 2,
        "mortaged": false,
        "description":
            "Twin scar is a rural town full of coal miners. It does have potential given enough funding.",
        "transportationPrice": 200,
        "backgroundColor": null,
      },
      {
        "type": "company",
        "idPrefix": "C",
        "color": Colors.black.value,
        "name": "West coal mine",
        "icon": "bolt",
        "price": 150,
        "hyp": 75,
        "housePrice": null,
        "rent": [5, 10, 15, 30, 50],
        "level": 0,
        "idIndex": 5,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
      },
      buildTrain(6, Colors.yellow[700]),
      {
        "type": "company",
        "color": Colors.black.value,
        "idPrefix": "C",
        "name": "North coal mine",
        "price": 150,
        "hyp": 75,
        "housePrice": null,
        "rent": [5, 10, 15, 30, 50],
        "level": 0,
        "icon": "bolt",
        "idIndex": 6,
        "mortaged": false,
        "description": null,
        "transportationPrice": 200,
      },
      {
        "type": "chest",
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
        "backgroundColor": 4279060385,
      },
      {
        "type": "company",
        "color": null,
        "idPrefix": "C",
        "name": "Upper Water Company",
        "price": 150,
        "hyp": 75,
        "housePrice": null,
        "rent": [4, 8, 15, 30, 50],
        "level": 0,
        "idIndex": 7,
        "mortaged": false,
        "description":
            "Epic water company in the world. You have to do the rent times the dice eyes.",
        "transportationPrice": 200,
        "backgroundColor": null,
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
        "description": "You are having a stare battle with the sheriff.",
        "transportationPrice": 200,
        "backgroundColor": null,
      },
      {
        "type": "chest",
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
        "backgroundColor": 4279060385,
      },
      {
        "type": "tax",
        "color": null,
        "idPrefix": "tax",
        "name": null,
        "price": -200,
        "hyp": null,
        "housePrice": null,
        "rent": null,
        "level": 0,
        "idIndex": 4,
        "mortaged": false,
        "description": "You stuck gold and receive £200!",
        "transportationPrice": 200,
      },
      {
        "type": "land",
        "color": Colors.red.value,
        "idPrefix": "DB",
        "name": "Crow's Canyon",
        "price": 100,
        "hyp": 175,
        "housePrice": 150,
        "rent": [10, 20, 35, 50, 60, 70, 90, 175, 500, 1100, 1300, 1500],
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description":
            "Crow's Ville is a rural town next to a canyon. It does have potential given enough funding.",
        "transportationPrice": 200,
        "backgroundColor": null,
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
        "backgroundColor": null,
      },
      {
        "type": "land",
        "color": Colors.red.value,
        "idPrefix": "DB",
        "name": "Crow's Ville",
        "price": 100,
        "hyp": 200,
        "housePrice": 150,
        "rent": [50, 10, 20, 35, 50, 60, 70, 90, 200, 600, 1400, 1700, 2000],
        "level": 0,
        "idIndex": 2,
        "mortaged": false,
        "description":
            "Crow's Ville is a rural town next to a canyon. It does have potential given enough funding.",
        "transportationPrice": 200,
        "backgroundColor": null,
      }
    ],
    "settings": {
      "name": "Game 1",
      "remotelyBuild": true,
      "goBonus": 200,
      "maxTurnes": 99999,
      "mustAuction": false,
      "startingMoney": 1500,
      "hackerScreen": false,
      "interest": 10,
      "dtlPrice": 1500,
      "startProperties": 0,
      "transportPassGo": false,
      "allowDiceSelect": false,
      "allowPriceChanges": false,
      "generateNames": false,
    },
    "extensions": ["transportation"],
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
      "dealer": null,
    },
    "bankData": null,
    "version": "0.4.2",
    "lostPlayers": [],
    "bot": false,
    "transported": false
  }
};
