import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:plutopoly/engine/extensions/lake_drain_extension.dart';
import 'package:plutopoly/engine/kernel/main.dart';
import 'package:plutopoly/engine/ui/alert.dart';
import 'package:plutopoly/helpers/money_helper.dart';
import 'package:plutopoly/widgets/my_card.dart';

class DrainTheLakeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyCard(
      title: "Drain the lake",
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "You can drain a lake for a large amount of money. This will add 2 properties to the map that you will own and can upgrade.",
          ),
        ),
        Tooltip(
          message: "Available from turn 15",
          child: RaisedButton(
            onPressed: LakeDrain.canDrain
                ? () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ColorDialog();
                      },
                    );
                  }
                : null,
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: Text("Drain for ${mon(Game.data.settings.dtlPrice)}"),
          ),
        )
      ],
    );
  }
}

class ColorDialog extends StatefulWidget {
  const ColorDialog({
    Key key,
  }) : super(key: key);

  @override
  _ColorDialogState createState() => _ColorDialogState();
}

class _ColorDialogState extends State<ColorDialog> {
  int color;

  @override
  void initState() {
    color = Game.data.player.color;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Drain the lake"),
        content: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    title: Text("Pick a color"),
                    content: MaterialColorPicker(
                      shrinkWrap: true,
                      onColorChange: (Color pickedColor) {
                        color = pickedColor.value;
                      },
                    ),
                    actions: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "select",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ]);
              },
            ).then((value) => setState(() {}));
          },
          child: ListTile(
              title: Text("Change color"),
              subtitle: Text("Change the color of the new street."),
              trailing: CircleColor(
                color: Color(color),
                circleSize: 35,
              )),
        ),
        actions: [
          MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "close",
                style: TextStyle(color: Theme.of(context).primaryColor),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                Alert.handle(() => LakeDrain.drain(color), context);
              },
              child: Text(
                "drain",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ))
        ]);
  }
}
