import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';

class TXDiscoverBackgroundWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: CustomPaint(
        painter: _TXCustomPaint(),
      ),
    );
  }
}

class _TXCustomPaint extends CustomPainter {
  Rect area;
  Paint backgroundColor;

  _TXCustomPaint() {
    backgroundColor = Paint()..color = R.color.discover_background;
  }

  @override
  void paint(Canvas canvas, Size size) {
    area = Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height));
    canvas.drawRect(area, backgroundColor);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
