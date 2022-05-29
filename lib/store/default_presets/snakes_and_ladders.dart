const Map<String, dynamic> snakesAndLaddersData = {
  "title": "snakes and ladders",
  "description": "First at the last tile with £1000 wins!",
  "author": "filorux",
  "projectName": "default.filorux.snakes and ladders",
  "version": "0.2.3",
  "dataCache": {
    "running": null,
    "players": [],
    "currentPlayer": 0,
    "turn": 1,
    "currentDices": [1, -1],
    "doublesThrown": 0,
    "pot": 0.0,
    "gmap": [
      {
        "type": "start",
        "idPrefix": "TileType.start",
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "color": 4294951175,
        "idPrefix": "ac",
        "name": "20 forward",
        "level": 0,
        "idIndex": 8,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": 4278228616,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": true,
        "iconData": {
          "codePoint": 61697,
          "fontFamily": "FontAwesomeSolid",
          "fontPackage": "font_awesome_flutter",
          "matchTextDirection": false
        },
        "actions": [
          {
            "title": "move",
            "command": "mvr 20",
            "alert": null,
            "color": null,
            "allowNext": true
          },
          {
            "title": "Get 200",
            "command": "pay -200",
            "alert": null,
            "color": null,
            "allowNext": true
          }
        ]
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 26,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 9,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 34,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "color": 4294967295,
        "idPrefix": "ac",
        "name": "3 back",
        "level": 0,
        "idIndex": 72,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": 4294924066,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": true,
        "iconData": {
          "codePoint": 61700,
          "fontFamily": "FontAwesomeSolid",
          "fontPackage": "font_awesome_flutter",
          "matchTextDirection": false
        },
        "actions": [
          {
            "title": "move",
            "command": "mvr -3",
            "alert": null,
            "color": null,
            "allowNext": true
          },
          {
            "title": "Pay 50",
            "command": "pay 50",
            "alert": null,
            "color": null,
            "allowNext": true
          }
        ]
      },
      {
        "type": "tax",
        "idPrefix": "tax",
        "price": 50,
        "level": 0,
        "idIndex": 58,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 27,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "color": 4294967295,
        "idPrefix": "ac",
        "name": "5 forward",
        "level": 0,
        "idIndex": 40,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": 4278228616,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": true,
        "iconData": {
          "codePoint": 61697,
          "fontFamily": "FontAwesomeSolid",
          "fontPackage": "font_awesome_flutter",
          "matchTextDirection": false
        },
        "actions": [
          {
            "title": "move",
            "command": "mvr 5",
            "alert": null,
            "color": null,
            "allowNext": true
          },
          {
            "title": "Get 50",
            "command": "pay -50",
            "alert": null,
            "color": null,
            "allowNext": true
          }
        ]
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 3,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 0,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 14,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "color": 4294967295,
        "idPrefix": "ac",
        "name": "5 forward",
        "level": 0,
        "idIndex": 79,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": 4278228616,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": true,
        "iconData": {
          "codePoint": 61697,
          "fontFamily": "FontAwesomeSolid",
          "fontPackage": "font_awesome_flutter",
          "matchTextDirection": false
        },
        "actions": [
          {
            "title": "move",
            "command": "mvr 5",
            "alert": null,
            "color": null,
            "allowNext": true
          },
          {
            "title": "Get 50",
            "command": "pay -50",
            "alert": null,
            "color": null,
            "allowNext": true
          }
        ]
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 37,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "color": 4294967295,
        "idPrefix": "ac",
        "name": "5 back",
        "level": 0,
        "idIndex": 68,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": 4294924066,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": true,
        "iconData": {
          "codePoint": 61696,
          "fontFamily": "FontAwesomeSolid",
          "fontPackage": "font_awesome_flutter",
          "matchTextDirection": false
        },
        "actions": [
          {
            "title": "move",
            "command": "mvr -5",
            "alert": null,
            "color": null,
            "allowNext": true
          },
          {
            "title": "Pay 50",
            "command": "pay 50",
            "alert": null,
            "color": null,
            "allowNext": true
          }
        ]
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 73,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "police",
        "idPrefix": "POL",
        "level": 0,
        "idIndex": 20,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 74,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 11,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "tax",
        "idPrefix": "tax",
        "price": -50,
        "level": 0,
        "idIndex": 60,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 78,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 38,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 31,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "tax",
        "idPrefix": "tax",
        "price": -300,
        "level": 0,
        "idIndex": 24,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "color": 4294967295,
        "idPrefix": "ac",
        "name": "3 forward",
        "level": 0,
        "idIndex": 66,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": 4278228616,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": true,
        "iconData": {
          "codePoint": 61701,
          "fontFamily": "FontAwesomeSolid",
          "fontPackage": "font_awesome_flutter",
          "matchTextDirection": false
        },
        "actions": [
          {
            "title": "move",
            "command": "mvr 3",
            "alert": null,
            "color": null,
            "allowNext": true
          },
          {
            "title": "Get 50",
            "command": "pay -50",
            "alert": null,
            "color": null,
            "allowNext": true
          }
        ]
      },
      {
        "type": "tax",
        "idPrefix": "tax",
        "price": 50,
        "level": 0,
        "idIndex": 57,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "color": 4294967295,
        "idPrefix": "ac",
        "name": "5 back",
        "level": 0,
        "idIndex": 47,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": 4294924066,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": true,
        "iconData": {
          "codePoint": 61696,
          "fontFamily": "FontAwesomeSolid",
          "fontPackage": "font_awesome_flutter",
          "matchTextDirection": false
        },
        "actions": [
          {
            "title": "move",
            "command": "mvr -5",
            "alert": null,
            "color": null,
            "allowNext": true
          },
          {
            "title": "Pay 50",
            "command": "pay 50",
            "alert": null,
            "color": null,
            "allowNext": true
          }
        ]
      },
      {
        "type": "action",
        "color": 4294967295,
        "idPrefix": "ac",
        "name": "10 back",
        "level": 0,
        "idIndex": 67,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": 4294924066,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": true,
        "iconData": {
          "codePoint": 61696,
          "fontFamily": "FontAwesomeSolid",
          "fontPackage": "font_awesome_flutter",
          "matchTextDirection": false
        },
        "actions": [
          {
            "title": "move",
            "command": "mvr -10",
            "alert": null,
            "color": null,
            "allowNext": true
          },
          {
            "title": "Pay 100",
            "command": "pay 100",
            "alert": null,
            "color": null,
            "allowNext": true
          }
        ]
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 12,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 33,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 39,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 41,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "color": 4294967295,
        "idPrefix": "ac",
        "name": "10 forward",
        "level": 0,
        "idIndex": 70,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": 4278228616,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": true,
        "iconData": {
          "codePoint": 61697,
          "fontFamily": "FontAwesomeSolid",
          "fontPackage": "font_awesome_flutter",
          "matchTextDirection": false
        },
        "actions": [
          {
            "title": "move",
            "command": "mvr 10",
            "alert": null,
            "color": null,
            "allowNext": true
          },
          {
            "title": "Get 100",
            "command": "pay -100",
            "alert": null,
            "color": null,
            "allowNext": true
          }
        ]
      },
      {
        "type": "action",
        "color": 4294967295,
        "idPrefix": "ac",
        "name": "10 forward",
        "level": 0,
        "idIndex": 42,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": 4278228616,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": true,
        "iconData": {
          "codePoint": 61697,
          "fontFamily": "FontAwesomeSolid",
          "fontPackage": "font_awesome_flutter",
          "matchTextDirection": false
        },
        "actions": [
          {
            "title": "move",
            "command": "mvr 10",
            "alert": null,
            "color": null,
            "allowNext": true
          },
          {
            "title": "Get 100",
            "command": "pay -100",
            "alert": null,
            "color": null,
            "allowNext": true
          }
        ]
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 2,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "color": 4294967295,
        "idPrefix": "ac",
        "name": "3 forward",
        "level": 0,
        "idIndex": 1,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": 4278228616,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": true,
        "iconData": {
          "codePoint": 61701,
          "fontFamily": "FontAwesomeSolid",
          "fontPackage": "font_awesome_flutter",
          "matchTextDirection": false
        },
        "actions": [
          {
            "title": "move",
            "command": "mvr 3",
            "alert": null,
            "color": null,
            "allowNext": true
          },
          {
            "title": "Get 50",
            "command": "pay -50",
            "alert": null,
            "color": null,
            "allowNext": true
          }
        ]
      },
      {
        "type": "tax",
        "idPrefix": "tax",
        "price": -200,
        "level": 0,
        "idIndex": 43,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "tax",
        "idPrefix": "tax",
        "price": -100,
        "level": 0,
        "idIndex": 59,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "jail",
        "idPrefix": "JAIL",
        "price": 200,
        "level": 0,
        "idIndex": 21,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 4,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 19,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "color": 4294967295,
        "idPrefix": "ac",
        "name": "3 forward",
        "level": 0,
        "idIndex": 44,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": 4278228616,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": true,
        "iconData": {
          "codePoint": 61701,
          "fontFamily": "FontAwesomeSolid",
          "fontPackage": "font_awesome_flutter",
          "matchTextDirection": false
        },
        "actions": [
          {
            "title": "move",
            "command": "mvr 3",
            "alert": null,
            "color": null,
            "allowNext": true
          },
          {
            "title": "Get 50",
            "command": "pay -50",
            "alert": null,
            "color": null,
            "allowNext": true
          }
        ]
      },
      {
        "type": "tax",
        "idPrefix": "tax",
        "price": -100,
        "level": 0,
        "idIndex": 65,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "tax",
        "idPrefix": "tax",
        "price": 100,
        "level": 0,
        "idIndex": 66,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 17,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 52,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "color": 4294967295,
        "idPrefix": "ac",
        "name": "3 back",
        "level": 0,
        "idIndex": 48,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": 4294924066,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": true,
        "iconData": {
          "codePoint": 61700,
          "fontFamily": "FontAwesomeSolid",
          "fontPackage": "font_awesome_flutter",
          "matchTextDirection": false
        },
        "actions": [
          {
            "title": "move",
            "command": "mvr -3",
            "alert": null,
            "color": null,
            "allowNext": true
          },
          {
            "title": "Pay 50",
            "command": "pay 50",
            "alert": null,
            "color": null,
            "allowNext": true
          }
        ]
      },
      {
        "type": "tax",
        "idPrefix": "tax",
        "price": 50,
        "level": 0,
        "idIndex": 62,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 5,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "tax",
        "idPrefix": "tax",
        "price": -150,
        "level": 0,
        "idIndex": 5,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 51,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 13,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "tax",
        "idPrefix": "tax",
        "price": -50,
        "level": 0,
        "idIndex": 61,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 15,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "color": 4294967295,
        "idPrefix": "ac",
        "name": "5 forward",
        "level": 0,
        "idIndex": 76,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": 4278228616,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": true,
        "iconData": {
          "codePoint": 61697,
          "fontFamily": "FontAwesomeSolid",
          "fontPackage": "font_awesome_flutter",
          "matchTextDirection": false
        },
        "actions": [
          {
            "title": "move",
            "command": "mvr 5",
            "alert": null,
            "color": null,
            "allowNext": true
          },
          {
            "title": "Get 50",
            "command": "pay -50",
            "alert": null,
            "color": null,
            "allowNext": true
          }
        ]
      },
      {
        "type": "tax",
        "idPrefix": "tax",
        "price": -200,
        "level": 0,
        "idIndex": 63,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 50,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 25,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "color": 4294967295,
        "idPrefix": "ac",
        "name": "5 forward",
        "level": 0,
        "idIndex": 65,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": 4278228616,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": true,
        "iconData": {
          "codePoint": 61697,
          "fontFamily": "FontAwesomeSolid",
          "fontPackage": "font_awesome_flutter",
          "matchTextDirection": false
        },
        "actions": [
          {
            "title": "move",
            "command": "mvr 5",
            "alert": null,
            "color": null,
            "allowNext": true
          },
          {
            "title": "Get 50",
            "command": "pay -50",
            "alert": null,
            "color": null,
            "allowNext": true
          }
        ]
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 18,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 54,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "color": 4294967295,
        "idPrefix": "ac",
        "name": "10 back",
        "level": 0,
        "idIndex": 45,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": 4294924066,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": true,
        "iconData": {
          "codePoint": 61696,
          "fontFamily": "FontAwesomeSolid",
          "fontPackage": "font_awesome_flutter",
          "matchTextDirection": false
        },
        "actions": [
          {
            "title": "move",
            "command": "mvr -10",
            "alert": null,
            "color": null,
            "allowNext": true
          },
          {
            "title": "Pay 100",
            "command": "pay 100",
            "alert": null,
            "color": null,
            "allowNext": true
          }
        ]
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 53,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "tax",
        "idPrefix": "tax",
        "price": 200,
        "level": 0,
        "idIndex": 55,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 29,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "color": 4294967295,
        "idPrefix": "ac",
        "name": "10 back",
        "level": 0,
        "idIndex": 77,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": 4294924066,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": true,
        "iconData": {
          "codePoint": 61696,
          "fontFamily": "FontAwesomeSolid",
          "fontPackage": "font_awesome_flutter",
          "matchTextDirection": false
        },
        "actions": [
          {
            "title": "move",
            "command": "mvr -10",
            "alert": null,
            "color": null,
            "allowNext": true
          },
          {
            "title": "Pay 100",
            "command": "pay 100",
            "alert": null,
            "color": null,
            "allowNext": true
          }
        ]
      },
      {
        "type": "tax",
        "idPrefix": "tax",
        "price": -100,
        "level": 0,
        "idIndex": 22,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 36,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "tax",
        "idPrefix": "tax",
        "price": 200,
        "level": 0,
        "idIndex": 75,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "color": 4294967295,
        "idPrefix": "ac",
        "name": "3 back",
        "level": 0,
        "idIndex": 69,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": 4294924066,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": true,
        "iconData": {
          "codePoint": 61700,
          "fontFamily": "FontAwesomeSolid",
          "fontPackage": "font_awesome_flutter",
          "matchTextDirection": false
        },
        "actions": [
          {
            "title": "move",
            "command": "mvr -3",
            "alert": null,
            "color": null,
            "allowNext": true
          },
          {
            "title": "Pay 50",
            "command": "pay 50",
            "alert": null,
            "color": null,
            "allowNext": true
          }
        ]
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 28,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "tax",
        "idPrefix": "tax",
        "price": 200,
        "level": 0,
        "idIndex": 76,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "tax",
        "idPrefix": "tax",
        "price": 100,
        "level": 0,
        "idIndex": 77,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 7,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "color": 4294967295,
        "idPrefix": "ac",
        "name": "3 forward",
        "level": 0,
        "idIndex": 71,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": 4278228616,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": true,
        "iconData": {
          "codePoint": 61701,
          "fontFamily": "FontAwesomeSolid",
          "fontPackage": "font_awesome_flutter",
          "matchTextDirection": false
        },
        "actions": [
          {
            "title": "move",
            "command": "mvr 3",
            "alert": null,
            "color": null,
            "allowNext": true
          },
          {
            "title": "Get 50",
            "command": "pay -50",
            "alert": null,
            "color": null,
            "allowNext": true
          }
        ]
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 6,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "idPrefix": "ac",
        "level": 0,
        "idIndex": 30,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "tax",
        "idPrefix": "tax",
        "price": -300,
        "level": 0,
        "idIndex": 64,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": null,
        "tableColor": null,
        "actionRequired": true,
        "onlyOneAction": false
      },
      {
        "type": "action",
        "color": 4294967295,
        "idPrefix": "ac",
        "name": "Win",
        "level": 0,
        "idIndex": 64,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": 4294675456,
        "tableColor": null,
        "actionRequired": false,
        "onlyOneAction": true,
        "iconData": {
          "codePoint": 61610,
          "fontFamily": "FontAwesomeSolid",
          "fontPackage": "font_awesome_flutter",
          "matchTextDirection": false
        },
        "actions": [
          {
            "title": "Win for 1000",
            "command": "pay 1000; win ",
            "alert": null,
            "color": null,
            "allowNext": true
          }
        ]
      },
      {
        "type": "action",
        "color": 4294967295,
        "idPrefix": "ac",
        "name": "Win",
        "level": 0,
        "idIndex": 24,
        "mortaged": false,
        "description": "No info",
        "transportationPrice": 200,
        "backgroundColor": 4294675456,
        "tableColor": null,
        "actionRequired": false,
        "onlyOneAction": true,
        "iconData": {
          "codePoint": 61610,
          "fontFamily": "FontAwesomeSolid",
          "fontPackage": "font_awesome_flutter",
          "matchTextDirection": false
        },
        "actions": [
          {
            "title": "Win for 1000",
            "command": "pay 1000; win ",
            "alert": null,
            "color": null,
            "allowNext": true
          }
        ]
      }
    ],
    "settings": {
      "name": "",
      "remotelyBuild": true,
      "goBonus": 500,
      "maxTurnes": 99999,
      "mustAuction": false,
      "startingMoney": 300,
      "hackerScreen": false,
      "interest": 5,
      "dtlPrice": 2000,
      "startProperties": 0,
      "transportPassGo": true,
      "allowDiceSelect": false,
      "allowPriceChanges": false,
      "generateNames": true,
      "receiveProperties": true,
      "receiveRentInJail": true,
      "doubleBonus": true,
      "diceType": "one"
    },
    "extensions": [],
    "ui": {
      "screenState": "idle",
      "showDealScreen": false,
      "shouldMove": true,
      "finished": false,
      "randomDices": null
    },
    "rentPayed": false,
    "findingsIndex": 0,
    "eventIndex": 0,
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
    "version": "0",
    "lostPlayers": [],
    "bot": false,
    "transported": false,
    "preset": "web.720.Player 43.snakes and ladders",
    "currency": "£",
    "placeCurrencyInFront": true
  },
  "infoCards": [
    {
      "title": "Win",
      "content":
          "To win you have to get to one of the last 2 tiles with at least £1000.",
      "type": "rule"
    },
    {
      "title": "Leave jail price",
      "content": "You have to pay £200 to leave jail.",
      "type": "alert"
    },
    {
      "title": "Preset studio",
      "content": "This has been fully made with the preset studio in-app!",
      "type": "tip"
    }
  ],
  "primaryColor": 4280723098,
  "accentColor": null,
  "template": "classic"
};
