import 'package:flutter/material.dart';

class TXIconButtonWidget extends StatelessWidget{
  final Widget icon;
  final Function onPressed;

  const TXIconButtonWidget({Key key, this.icon, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      onPressed: onPressed,
      iconSize: 20,
      color: Colors.white,
    );
  }

}