import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';

class TXBackgroundWidget extends StatelessWidget {
  final Widget child;
  final String iconRes;

  const TXBackgroundWidget({Key key, @required this.child, this.iconRes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: ExactAssetImage(iconRes),
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.1), BlendMode.dstATop)))),
//          Container(
//            child: Center(
//              child: Icon(
//                widget.icon ?? Icons.local_florist,
//                color: Colors.blueGrey[50],
//                size: MediaQuery.of(context).size.width,
//              ),
//            ),
//          ),
          child
        ],
      ),
    );
  }
}
