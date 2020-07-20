import 'package:plutopoly/engine/kernel/main.dart';

import '../../preset.dart';
import '../adventure_data.dart';
import 'default_adventure_data.dart';

List<AdventureLand> classicAdventureLands = [
  AdventureLand(
      parent: "default",
      open: true,
      name: "Classic isle",
      description:
          "Welcome to the classic isle. This island is to oldest place known to humans and the birthplace of plutocracy.",
      levels: [
        Level.adventure(
          description: "A classic game.",
          presetCache: Preset.fromJson(DefaultAdventureData.land1[0]),
          title: "Standard classic",
          turnsNeeded: 40,
          index: 0,
        ),
        Level.adventure(
          presetCache: Preset.fromJson(DefaultAdventureData.land1[1]),
          description:
              "Changed rent prices with lower house prices. Added bank to get a loan.",
          title: "Tight on cash",
          turnsNeeded: 60,
          index: 0,
        ),
        Level.adventure(
          presetCache: Preset.fromJson(DefaultAdventureData.land1[2]),
          description: "An expensive world with a bad investor.",
          title: "Expensive high world",
          turnsNeeded: 50,
          index: 0,
        ),
        Level.adventure(
          index: 0,
          presetCache: Preset.fromJson(DefaultAdventureData.land1[0]),
          description: "A shuffled world.",
          onLaunch: () {
            Game.data.gmap.shuffle();
            return null;
          },
          title: "Random",
          turnsNeeded: 40,
        ),
        Level.adventure(
          index: 0,
          presetCache: Preset.fromJson(DefaultAdventureData.land1[4]),
          description: "A big map with a lot of players.",
          title: "Omega map",
          turnsNeeded: 60,
        ),
      ]),
  AdventureLand(
      name: "The midlands",
      parent: "default",
      description:
          "A giant landmass with lot's of people. The first stock market was invented here.",
      levels: [
        Level.adventure(
          description: "A lot of small countries.",
          title: "Islands",
          presetCache: Preset.fromJson(DefaultAdventureData.land2[0]),
          turnsNeeded: 40,
          index: 1,
        ),
        Level.adventure(
          description: "Invest your money wisely.",
          title: "Investors",
          presetCache: Preset.fromJson(DefaultAdventureData.land2[1]),
          index: 1,
          turnsNeeded: 40,
        ),
        Level.adventure(
          description: "Should you stay in prison or not.",
          title: "High security",
          presetCache: Preset.fromJson(DefaultAdventureData.land2[2]),
          index: 1,
          turnsNeeded: 40,
        ),
        Level.adventure(
          description: "The first 2 maps shuffled together.",
          title: "Giant shuffle",
          presetCache: DefaultAdventureData.landShuffle,
          onLaunch: () {
            Game.data.gmap.shuffle();
            return null;
          },
          index: 1,
        ),
        Level.adventure(
          description: "A very tight property market.",
          title: "Presonal properties",
          presetCache: Preset.fromJson(DefaultAdventureData.land2[4]),
          index: 1,
        ),
      ]),
  AdventureLand(
      parent: "default",
      name: "The new lands",
      description:
          "A fresh new world recently discovered. The industrial complex is in full swing here.",
      levels: [
        Level.adventure(
          description: "A world full of trainstations and companies.",
          title: "A new world",
          presetCache: Preset.fromJson(DefaultAdventureData.land3[0]),
          index: 2,
        ),
        Level.adventure(
          description: "More maps are coming",
          title: "Coming soon",
          presetCache: Preset(),
          index: 2,
        ),
      ]),
  AdventureLand(
      parent: "default",
      name: "Outer space",
      description:
          "Build a rocket and fly to outer space. This is under development :/.",
      levels: []),
];
