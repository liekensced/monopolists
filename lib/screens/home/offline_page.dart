import 'package:flutter/material.dart';

import '../../bloc/main_bloc.dart';
import '../../engine/ui/alert.dart';
import '../../engine/ui/game_navigator.dart';
import '../../widgets/my_card.dart';

class OfflinePage extends StatelessWidget {
  const OfflinePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 10,
        ),
        MyCard(
          title: "You are still connected",
          smallTitle: true,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: RaisedButton(
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                child: Container(
                    width: double.infinity,
                    child: Text(
                      "Rejoin game",
                      textAlign: TextAlign.center,
                    )),
                onPressed: () async {
                  Alert alert = await MainBloc.joinOnline(MainBloc.gameId);
                  if (Alert.handle(() => alert, context)) {
                    GameNavigator.navigate(context);
                  }
                  GameNavigator.navigate(context);
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
