import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';

class TXBackgroundWidget extends StatelessWidget {
  final Widget child;
  final String iconRes;
  final String imageUrl;

  const TXBackgroundWidget(
      {Key key, @required this.child, this.iconRes, this.imageUrl})
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
                      image: (imageUrl == null || imageUrl.isEmpty)
                          ? ExactAssetImage(iconRes)
                          : NetworkImage(imageUrl),
                      colorFilter: new ColorFilter.mode(
                          Colors.white.withOpacity(0.1), BlendMode.dstATop)))),
          Center(
            child: Container(
              height: 200,
              width: 200,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.white.withOpacity(0.1),
                  child: Text(
                    "Blur Background Image in Flutter",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          child
        ],
      ),
    );
  }
}
