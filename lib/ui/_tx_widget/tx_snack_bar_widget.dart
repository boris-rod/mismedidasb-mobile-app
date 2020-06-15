import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXSnackBarWidget extends StatelessWidget {
  final String text;
  final SnackBarAction action;

  const TXSnackBarWidget({Key key, this.text, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      backgroundColor: Colors.white,
      content: Row(
        children: <Widget>[
          Container(
            child: Image.asset(
              R.image.logo,
              width: 60,
              height: 60,
            ),
          ),
          Expanded(
              child: TXTextWidget(
                text: text,
              ))
        ],
      ),
      action: action,
    );
  }
}
