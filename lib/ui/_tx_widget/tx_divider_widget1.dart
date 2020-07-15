import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';

class TXDividerWidget1 extends StatelessWidget {
  final double height;

  const TXDividerWidget1({Key key, this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Image.asset(
        R.image.divider_icon_yellow,
        height: 2,
        width: double.infinity,
        fit: BoxFit.fill,
      ),
    );
  }
}
