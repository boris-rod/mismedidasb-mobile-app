import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';

class TXBackgroundWidget extends StatefulWidget {
  final Widget child;
  final IconData icon;

  const TXBackgroundWidget({Key key, @required this.child, this.icon})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TXBackgroundState();
}

class _TXBackgroundState extends State<TXBackgroundWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Container(
            child: Center(
              child: Icon(
                widget.icon ?? Icons.local_florist,
                color: Colors.blueGrey[50],
                size: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          widget.child
        ],
      ),
    );
  }
}
