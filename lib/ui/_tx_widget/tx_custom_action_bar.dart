import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_action_bar_menu_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_navigator_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXCustomActionBar extends StatelessWidget {
  final Widget leading;
  final Function onLeadingTap;
  final String title;
  final List<TXActionBarMenuWidget> actions;
  final Color actionBarColor;
  final Widget body;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool showLeading;

  const TXCustomActionBar(
      {Key key,
      this.leading,
      this.onLeadingTap,
      this.title,
      this.actions = const [],
      this.actionBarColor,
      this.body,
      this.scaffoldKey,
      this.showLeading = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: actionBarColor,
      appBar: AppBar(
        titleSpacing: 0.0,
        centerTitle: true,
        elevation: 0,
        backgroundColor: actionBarColor,
        automaticallyImplyLeading: false,
        title: Container(
          margin: EdgeInsets.only(left: 10),
          child: Row(
            children: <Widget>[
              showLeading
                  ? leading ??
                      TXIconNavigatorWidget(
                        onTap: onLeadingTap ?? () {
                          NavigationUtils.pop(context);
                        },
                        text: R.string.back.toLowerCase(),
                      )
                  : Container(),
              Expanded(
                child: TXTextWidget(
                  text: title,
                  color: Colors.white,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Row(
                  children: actions,
                ),
              )
            ],
          ),
        ),
      ),
      body: body,
    );
  }
}
