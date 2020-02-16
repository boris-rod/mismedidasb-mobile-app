import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';

class TXTextLinkWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final Color splashColor;
  final Color textColor;
  final FontWeight fontWeight;
  final double fontSize;

  const TXTextLinkWidget({
    @required this.onTap,
    @required this.title,
    this.splashColor,
    this.fontWeight = FontWeight.normal,
    this.textColor = Colors.grey,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onTap,
      child: Text(
        title ?? "",
        style: TextStyle(
            color: textColor ?? R.color.primary_color,
            fontSize: fontSize,
            fontWeight: fontWeight,
            decoration: TextDecoration.underline),
      ),
      splashColor: splashColor,
    );
  }
}
