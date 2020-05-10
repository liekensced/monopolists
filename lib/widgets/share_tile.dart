import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plutopoly/bloc/main_bloc.dart';
import 'package:plutopoly/engine/ui/alert.dart';
import 'package:share/share.dart';

class ShareTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Share the game id"),
      subtitle: Text(MainBloc.gameId ?? ""),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.content_copy),
            onPressed: () {
              try {
                Clipboard.setData(ClipboardData(
                    text: MainBloc.gameId ?? "Something went wrong :/"));
              } catch (e) {
                Alert.handle(
                    () => Alert("Could not copy",
                        "Did you give permission?\n" + e.toString()),
                    context);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              if (MainBloc.gameId == null) {
                Alert.handle(
                    () => Alert("Couldn't share", "Game ping was null?"),
                    context);
                return;
              }
              String text =
                  "https://plutopoly.web.app/?gamepin=" + MainBloc.gameId;
              if (kIsWeb) {
                try {
                  Clipboard.setData(
                      ClipboardData(text: text ?? "Something went wrong :/"));
                } catch (e) {
                  Alert.handle(
                      () => Alert("Could not copy",
                          "Did you give permission?\n" + e.toString()),
                      context);
                }
              } else {
                Share.share(text, subject: "Join my Plutopoly game!");
              }
            },
          ),
        ],
      ),
    );
  }
}
