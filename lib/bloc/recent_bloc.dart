import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:plutopoly/bloc/recent.dart';
import 'package:plutopoly/engine/data/main.dart';

import 'main_bloc.dart';

class RecentBloc {
  static checkRecent() {
    getRecent().forEach((gameId, Recent recent) async {
      DocumentReference ref;
      DocumentSnapshot snapshot;
      try {
        ref = Firestore.instance.document("/games/$gameId");
        snapshot = await ref.get();
        if (snapshot == null || !snapshot.exists) {
          return;
        }
        List players = snapshot.data["players"];
        if (players != null) {
          if (players[snapshot.data["currentPlayer"]]["code"] ==
              MainBloc.code) {
            recent.idle = false;
            recent.save();
          }
        }
      } catch (e) {
        return;
      }
    });
  }

  static addToRecent(String newGameId, [String name]) {
    List<String> recent = Hive.box(MainBloc.METABOX)
        .get("listRecent", defaultValue: []).cast<String>();
    if (!recent.contains(newGameId)) recent.add(newGameId);
    Hive.box(MainBloc.METABOX).put("listRecent", recent);
  }

  static Map<String, Recent> getRecent() {
    return Hive.box(MainBloc.RECENTBOX).toMap().cast<String, Recent>() ?? {};
  }

  static update(GameData data) {
    if (data.players.isEmpty) return;
    Hive.box(MainBloc.RECENTBOX).put(
        MainBloc.gameId,
        Recent(data.settings.name, data.players.first.name, data.turn,
            data.ui.idle));
  }
}
