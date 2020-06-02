import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';

class TXDividerWidget extends StatelessWidget {
  final double height;

  const TXDividerWidget({Key key, this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height ?? .5,
      color: R.color.gray,
    );
  }
}
