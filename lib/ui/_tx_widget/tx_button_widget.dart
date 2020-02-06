import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TXButtonWidget extends StatelessWidget {
  final VoidCallback action;
  final String title;
  final Color mainColor;
  final Color splashColor;
  final Color textColor;
  final FontWeight fontWeight;
  final double fontSize;
  final bool avoidPadding;

  const TXButtonWidget({
    @required this.action,
    @required this.title,
    @required this.mainColor,
    this.splashColor,
    this.fontWeight = FontWeight.normal,
    this.textColor = Colors.white,
    this.fontSize = 14,
    this.avoidPadding = false
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: avoidPadding ? EdgeInsets.all(0): null,
      color: mainColor,
      splashColor: splashColor,
      onPressed: action,
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
      ),

      disabledColor: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
    );
  }
}
