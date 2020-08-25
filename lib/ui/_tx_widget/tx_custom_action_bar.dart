import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_action_bar_menu_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_fade_animated_text.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_navigator_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class TXCustomActionBar extends StatefulWidget {
  final Widget leading;
  final Function onLeadingTap;
  final String title;
  final List<TXActionBarMenuWidget> actions;
  final Color actionBarColor;
  final Widget body;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool showLeading;
  final int showGifInfo;

  const TXCustomActionBar({
    Key key,
    this.leading,
    this.onLeadingTap,
    this.title,
    this.actions = const [],
    this.actionBarColor,
    this.body,
    this.scaffoldKey,
    this.showLeading = true,
    this.showGifInfo = 0,
  }) : super(key: key);

  @override
  _TXCustomActionBarState createState() => _TXCustomActionBarState();
}

class _TXCustomActionBarState extends State<TXCustomActionBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      backgroundColor: widget.actionBarColor,
      appBar: AppBar(
        titleSpacing: 0.0,
        centerTitle: true,
        elevation: 0,
        backgroundColor: widget.actionBarColor,
        automaticallyImplyLeading: false,
        title: Container(
          margin: EdgeInsets.only(left: 10),
          child: Row(
            children: <Widget>[
              widget.showLeading
                  ? widget.leading ??
                      TXIconNavigatorWidget(
                        onTap: widget.onLeadingTap ??
                            () {
                              NavigationUtils.pop(context);
                            },
                        text: R.string.back.toLowerCase(),
                      )
                  : Container(),
              Expanded(
                child: ((widget.showGifInfo ?? 0) > 0)
                    ? InkWell(
                        onTap: () {
                          launch(
                              "https://book.timify.com/?accountId=5f420e4b846bcf12c3140046&fullscreen=1&hideCloseButton=1");
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: TXFadeAnimatedText(),
                        ))
                    : TXTextWidget(
                        text: widget.title,
                        color: Colors.white,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Row(
                  children: widget.actions,
                ),
              )
            ],
          ),
        ),
      ),
      body: widget.body,
    );
  }
}
