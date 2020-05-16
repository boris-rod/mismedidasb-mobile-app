import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXStatWidget extends StatelessWidget {
  final String title;
  final String value;
  final Color titleColor;
  final Color valueColor;
  final double titleSize;
  final double valueSize;

  const TXStatWidget(
      {Key key,
      this.title,
      this.value,
      this.titleColor,
      this.valueColor,
      this.titleSize = 12,
      this.valueSize = 30})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TXTextWidget(
            text: value,
            size: valueSize,
            color: valueColor ?? Colors.amber[800],
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          TXTextWidget(
            text: title,
            size: titleSize,
            fontWeight: FontWeight.bold,
            color: titleColor ?? Colors.black,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
