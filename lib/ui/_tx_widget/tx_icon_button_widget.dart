import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';

class TXIconButtonWidget extends StatelessWidget {
  final Widget icon;
  final Function onPressed;
  final double iconSize;

  const TXIconButtonWidget({Key key, this.icon, this.onPressed, this.iconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      child: IconButton(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        padding: EdgeInsets.all(0),
        constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
        icon: icon,
        onPressed: onPressed,
        iconSize: iconSize ?? 20,
        color: Colors.white,
      ),
    );
  }
}
