import 'dart:ui';

import 'package:flutter/material.dart';

class TXBlurWidget extends StatelessWidget {
  final double opacity;
  final double blurry;
  final Color shade;
  final Widget child;

  const TXBlurWidget(
      {Key key,
      this.opacity = .2,
      this.blurry = .5,
      this.shade = Colors.white,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurry, sigmaY: blurry),
          child: Container(
            decoration: BoxDecoration(color: shade.withOpacity(opacity)),
            child: child ?? Container(),
          ),
        ),
      ),
    );
  }
}
