import 'package:flutter/material.dart';
import 'package:plutopoly/widgets/my_card.dart';

class StoreList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: PageController(viewportFraction: 0.8),
      children: [
        MyCard(
          title: "test",
          children: [],
        )
      ],
    );
  }
}
