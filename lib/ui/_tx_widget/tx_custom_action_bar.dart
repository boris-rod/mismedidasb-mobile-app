import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textfield_widget.dart';

class TXCustomActionBar extends StatelessWidget {
  final Widget leading;
  final Function onLeadingTap;
  final String title;
  final List<TXIconButtonWidget> actions;
  final Color actionBarColor;

  const TXCustomActionBar(
      {Key key,
      this.leading,
      this.onLeadingTap,
      this.title,
      this.actions = const [],
      this.actionBarColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: actionBarColor ?? R.color.primary_color,
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          leading,
          Expanded(
            child: TXTextWidget(
              text: title,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
              color: Colors.white,
            ),
          ),
          ...actions
        ],
      ),
    );
  }
}
