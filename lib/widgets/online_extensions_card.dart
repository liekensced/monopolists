import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/ui_bloc.dart';
import '../helpers/online_extensions.dart';
// import '../screens/online_extension_page.dart';
import 'my_card.dart';

class OnlineExtensionsCard extends StatelessWidget {
  final bool hide;

  const OnlineExtensionsCard({Key key, this.hide: false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Bot> bots = OnlineExtensions.getBots();
    if (bots.isEmpty && hide) return Container();
    List<Widget> children = [];
    bots.forEach((bot) {
      children.add(InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return Container(
                constraints: BoxConstraints(maxWidth: UIBloc.maxWidth),
                child: AlertDialog(
                    title: Text("Online extension"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(bot.name),
                          subtitle: Text(bot.projectName),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(bot.description),
                        ),
                        ListTile(
                          title: Text("author"),
                          subtitle: Text(bot.author),
                        ),
                        bot.version == null
                            ? Container()
                            : ListTile(
                                title: Text("version"),
                                subtitle: Text(bot.version),
                              ),
                        bot.website == null
                            ? Container()
                            : ListTile(
                                title: Text(bot.website),
                                trailing: IconButton(
                                  icon: Icon(Icons.open_in_new),
                                  onPressed: () {
                                    _launchURL(bot.website);
                                  },
                                ),
                              ),
                        RaisedButton(
                          color: bot.active ? Colors.red : Colors.green,
                          onPressed: () {
                            OnlineExtensions.disableBot(bot);
                            Navigator.pop(context);
                          },
                          child: Text(
                            bot.active ? "Disable" : "Activate",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    actions: [
                      MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "close",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ))
                    ]),
              );
            },
          );
        },
        child: ListTile(
          leading: bot.active
              ? Container(
                  width: 0,
                )
              : Icon(Icons.sync_disabled),
          title: Text(bot.name),
          subtitle: Text(bot.projectName),
          trailing: Icon(Icons.info_outline),
        ),
      ));
    });
    if (children.isEmpty) {
      return Container();
      // children.add(InkWell(
      //   onTap: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (c) {
      //       return OnlineExtensionPage();
      //     }));
      //   },
      //   child: Padding(
      //     padding: const EdgeInsets.all(12.0),
      //     child: Text(
      //         "You can add third party, online, extensions to make your game even better. Tap for more information."),
      //   ),
      // ));
    }
    return MyCard(
      title: "Online extensions",
      smallTitle: true,
      children: children,
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
