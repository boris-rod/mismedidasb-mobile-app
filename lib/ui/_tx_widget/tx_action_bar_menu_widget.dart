import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TXActionBarMenuWidget extends StatelessWidget {
  final Widget icon;
  final Function onTap;

  const TXActionBarMenuWidget({Key key, this.icon, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(5),
        child: icon,
      ),
      onTap: onTap,
    );
  }
}
