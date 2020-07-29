import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_discover_background_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';

class TXVideoIntroWidget extends StatelessWidget {
  final String title;
  final Function onSeeVideo;
  final Function onSkip;

  const TXVideoIntroWidget({Key key, this.title, this.onSeeVideo, this.onSkip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          TXDiscoverBackgroundWidget(),
          Center(
            child: Container(
              width: 300,
              height: 300,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    R.image.plani1,
                    width: 80,
                    height: 80,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TXTextLinkWidget(
                          title: title,
                          fontWeight: FontWeight.bold,
                          textColor: Colors.white,
                          textDecoration: TextDecoration.none,
                          fontSize: 18,
                          onTap: null,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TXButtonWidget(
                          title: "Ver video",
                          onPressed: onSeeVideo,
                          mainColor: R.color.button_color,
                        ),
                        TXTextLinkWidget(
                          title: "Saltar",
                          onTap: onSkip,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
