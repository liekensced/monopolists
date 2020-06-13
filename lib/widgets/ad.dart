import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';

import '../bloc/ad_bloc.dart';
import '../bloc/ui_bloc.dart';
import '../jokes.dart';

class ADView extends StatefulWidget {
  final bool large;
  final NativeAdmobController controller;

  const ADView({Key key, this.large: false, this.controller}) : super(key: key);

  @override
  _ADViewState createState() => _ADViewState();
}

class _ADViewState extends State<ADView> {
  @override
  Widget build(BuildContext context) {
    final NativeAdmobController _controller =
        widget.controller ?? (kIsWeb ? null : NativeAdmobController());
    bool dark = UIBloc.darkMode;
    NativeTextStyle textStyle =
        NativeTextStyle(color: dark ? Colors.white : Colors.black);
    return Center(
      child: Container(
        height: widget.large ? 350 : 100,
        width: widget.large ? UIBloc.maxWidth * 1.2 : UIBloc.maxWidth,
        child: Card(
          child: kIsWeb
              ? buildJoke(context)
              : NativeAdmob(
                  error: buildJoke(context),
                  adUnitID: AdBloc.nativeAdUID,
                  controller: _controller,
                  type: widget.large
                      ? NativeAdmobType.full
                      : NativeAdmobType.banner,
                  options: NativeAdmobOptions(
                    showMediaContent: true,
                    headlineTextStyle: textStyle,
                    bodyTextStyle: textStyle,
                    adLabelTextStyle: textStyle,
                    advertiserTextStyle: textStyle,
                    priceTextStyle: textStyle,
                    storeTextStyle: textStyle,
                    ratingColor: Colors.cyan,
                  ),
                ),
        ),
      ),
    );
  }

  buildJoke(context) {
    Map<String, dynamic> joke = jokes[Random().nextInt(jokes.length)];
    return Center(
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: Text("Joke rating: " + joke["rating"].toString()),
                  content: Text(joke["body"]),
                  actions: [
                    MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "close",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ))
                  ]);
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Ad replacement:\n" + joke["body"],
            maxLines: widget.large ? 100 : 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
