import 'package:flutter/material.dart';
import 'package:plutopoly/engine/commands/parser.dart';

class CommandScreen extends StatefulWidget {
  final bool execute;

  const CommandScreen({Key key, this.execute: true}) : super(key: key);
  @override
  _CommandScreenState createState() => _CommandScreenState();
}

class _CommandScreenState extends State<CommandScreen> {
  TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    List<ListTile> childs = [];
    String title = "";
    String command = (controller.text ?? "").split(";").last.trimLeft();
    if (command.split(" ").length <= 1) {
      commandsInfo.forEach((key, map) {
        childs.add(ListTile(
          title: Text(map.keys.first),
          onTap: () {
            controller.text += key + " ";
            controller.selection =
                TextSelection.collapsed(offset: controller.text.length);
            setState(() {});
          },
        ));
      });
    } else {
      if (commandsInfo.containsKey(command.split(" ").first)) {
        Map info = commandsInfo[command.split(" ").first]
            .values
            .first
            .tryGet(command.split(" ").length - 2);
        if (info == null) {
          title = "done";
          childs.add(ListTile(
            title: Text("Chain with other command"),
            subtitle:
                Text("Add another command to be executed at the same time."),
            onTap: () {
              controller.text = controller.text.trimRight() + "; ";
              controller.selection =
                  TextSelection.collapsed(offset: controller.text.length);

              setState(() {});
            },
          ));
        } else {
          title = info.keys.first;
          info.values.first.forEach((element) {
            childs.add(ListTile(
              title: Text(element.keys.first),
              subtitle: Text(element.values.first),
              onTap: () {
                controller.text += element.values.first + " ";
                controller.selection =
                    TextSelection.collapsed(offset: controller.text.length);

                setState(() {});
              },
            ));
          });
        }
      }
    }
    if (title == "") {
      return Scaffold(
        appBar: AppBar(
          title: Text("New command"),
        ),
        body: buildColumn(title, childs, context),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("New command"),
      ),
      floatingActionButton: title == ""
          ? Container(
              width: 0,
            )
          : FloatingActionButton(
              onPressed: () {
                onDone(controller.text, context);
              },
              child: Icon(
                Icons.done,
                color: Colors.white,
              ),
            ),
      body: buildColumn(title, childs, context),
    );
  }

  Column buildColumn(
      String title, List<ListTile> childs, BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              ListName(
                title: title,
              ),
              ...childs
            ],
          ),
        ),
        TextField(
          autofocus: true,
          controller: controller,
          onChanged: (String val) {
            setState(() {});
          },
          onSubmitted: (String fullCommand) {
            onDone(fullCommand, context);
          },
        )
      ],
    );
  }

  void onDone(String command, BuildContext context) {
    if (widget.execute) CommandParser.parse(command);
    Navigator.pop(context, command);
  }
}

class Autocompleter extends StatelessWidget {
  final String cmd;

  const Autocompleter({
    Key key,
    @required this.cmd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("selecter");
  }
}

class ListName extends StatelessWidget {
  final String title;
  const ListName({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
          child: Text(
        title == "" ? "Select a command" : title,
        textAlign: TextAlign.center,
      )),
    );
  }
}

extension CoolMap on List {
  tryGet(int index) {
    if (index >= length) return null;
    return this[index];
  }
}
