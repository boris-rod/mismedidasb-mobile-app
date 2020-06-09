import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXIconNavigatorWidget extends StatelessWidget {
  final String text;
  final bool isLeading;
  final Function onTap;

  const TXIconNavigatorWidget(
      {Key key, this.text, this.isLeading = true, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          isLeading ? _getIcon() : Container(),
          Container(
            child: TXTextWidget(
              text: text,
              color: Colors.white,
              size: 16,
            ),
            margin: EdgeInsets.only(
                left: isLeading ? 5 : 0, right: isLeading ? 0 : 5),
          ),
          !isLeading ? _getIcon() : Container(),
        ],
      ),
    );
  }

  Widget _getIcon() {
    return Image.asset(
      isLeading ? R.image.backward : R.image.forward,
      width: 40,
      height: 40,
    );
  }
}
