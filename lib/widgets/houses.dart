import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Houses extends StatelessWidget {
  final int amount;

  const Houses({Key key, @required this.amount}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (amount == 5) {
      return Center(
        child: FaIcon(
          FontAwesomeIcons.hotel,
          color: Colors.red,
        ),
      );
    }
    return ListView.separated(
      separatorBuilder: (_, __) {
        return Container(width: 5);
      },
      itemCount: amount,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, _) {
        return Center(
          child: FaIcon(
            FontAwesomeIcons.home,
            color: Colors.blue,
            size: 30,
          ),
        );
      },
    );
  }
}
