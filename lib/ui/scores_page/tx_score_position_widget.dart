import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:mismedidasb/res/R.dart';

class TXScorePositionWidget extends StatelessWidget {
  final double percentage;

  const TXScorePositionWidget({Key key, this.percentage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Material(
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: 200,
        child: CustomPaint(
          painter: _TXCustomPaint(percentage),
        ),
      ),
    );
  }
}

class _TXCustomPaint extends CustomPainter {
  static double _markWidth = 10;
  final double percentage;
  Paint frontPyramidPaint;
  Paint backPyramidPaint;
  Paint markPaint;
  Paint markShadowPaint;

  Path frontPyramidPath;
  Path backPyramidPath;
  Path markPath;
  Path markShadowPath;

  Offset pyramid1Offset;
  Offset pyramid2Offset;
  Offset pyramid3Offset;
  Offset pyramid4Offset;
  Offset markOffset1;
  Offset markOffset2;
  Offset markOffset3;
  Offset markOffset4;
  Offset markOffset5;
  Offset markOffset6;
  Offset lineYou1;
  Offset lineYou2;

  Rect pyramidRect;

  _TXCustomPaint(this.percentage) {
    frontPyramidPaint = Paint();
    backPyramidPaint = Paint();
    backPyramidPaint = Paint();
    markPaint = Paint();
    markShadowPaint = Paint();

    frontPyramidPath = Path();
    backPyramidPath = Path();
    markPath = Path();
    markShadowPath = Path();

    frontPyramidPaint.color = R.color.gray_light;
    frontPyramidPaint.style = PaintingStyle.fill;

    backPyramidPaint.color = Colors.grey[300];
    backPyramidPaint.style = PaintingStyle.fill;

    markPaint.color = Colors.orange;
    markPaint.style = PaintingStyle.fill;

    markShadowPaint.color = Colors.grey[200];
    markShadowPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    pyramidRect = Rect.fromPoints(Offset(size.width - 170, 20), Offset(size.width - 20, 190));

    pyramid1Offset = Offset(pyramidRect.left, pyramidRect.bottom - 50);
    pyramid2Offset =
        Offset(pyramidRect.left + pyramidRect.left / 2, pyramidRect.bottom);
    pyramid3Offset = Offset(pyramidRect.right, pyramidRect.bottom - 50);
    pyramid4Offset =
        Offset(pyramidRect.left + pyramidRect.left / 2, pyramidRect.top);

    double point1 = math.max(pyramidRect.bottom * (100 - percentage) / 100,
        pyramidRect.top + _markWidth);

    markOffset1 = Offset(pyramidRect.left + pyramidRect.left / 2, point1);
    markOffset2 = Offset(pyramidRect.left, point1 - 50);
    markOffset3 = Offset(pyramidRect.left, point1 - (50 + _markWidth));
    markOffset4 =
        Offset(pyramidRect.left + pyramidRect.left / 2, point1 - _markWidth);
    markOffset5 = Offset(pyramidRect.right, point1 - (50 + _markWidth));
    markOffset6 = Offset(pyramidRect.right, point1 - 50);

    lineYou1 = Offset(markOffset2.dx, markOffset2.dy - 3);
    lineYou2 = Offset(0, markOffset2.dy - 3);

    canvas.drawRect(
        Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)),
        Paint()..style = PaintingStyle.stroke);
    canvas.drawRect(pyramidRect, Paint()..style = PaintingStyle.stroke);
//
//    canvas.drawLine(
//        Offset(pyramid1Offset.dx, pyramid1Offset.dy),
//        Offset(pyramid4Offset.dx, pyramid4Offset.dy),
//        Paint()
//          ..color = Colors.black
//          ..style = PaintingStyle.fill..strokeWidth = 1);

    _drawPyramidFrontPath(canvas, size);
    _drawPyramidBackPath(canvas, size);
    _drawMarkShadow(canvas, size);
    _drawMarkPath(canvas, size);
    _drawLineYou(canvas, size);
//    canvas.drawLine(
//        Offset(markOffset4.dx, markOffset4.dy),
//        Offset(0, 30),
//        Paint()
//          ..color = Colors.black
//          ..style = PaintingStyle.fill..strokeWidth = .5);
  }

  void _drawLineYou(Canvas canvas, Size size) {
    canvas.drawLine(Offset(lineYou1.dx, lineYou1.dy),
        Offset(lineYou2.dx, lineYou2.dy), markPaint);
  }

  void _drawPyramidFrontPath(Canvas canvas, Size size) {
    frontPyramidPath.moveTo(pyramid1Offset.dx, pyramid1Offset.dy);
    frontPyramidPath.lineTo(pyramid2Offset.dx, pyramid2Offset.dy);
    frontPyramidPath.lineTo(pyramid4Offset.dx, pyramid4Offset.dy);
    frontPyramidPath.close();
    canvas.drawPath(frontPyramidPath, frontPyramidPaint);
  }

  void _drawPyramidBackPath(Canvas canvas, Size size) {
    backPyramidPath.moveTo(pyramid2Offset.dx, pyramid2Offset.dy);
    backPyramidPath.lineTo(pyramid3Offset.dx, pyramid3Offset.dy);
    backPyramidPath.lineTo(pyramid4Offset.dx, pyramid4Offset.dy);
    backPyramidPath.close();
    canvas.drawPath(backPyramidPath, backPyramidPaint);
  }

  void _drawMarkShadow(Canvas canvas, Size size) {
    markShadowPath.moveTo(pyramid2Offset.dx, pyramid2Offset.dy);
    markShadowPath.lineTo(pyramid2Offset.dx + 15, size.height);
    markShadowPath.lineTo(size.width, size.height);
    markShadowPath.lineTo(size.width, size.height - 45);
    markShadowPath.lineTo(pyramid3Offset.dx, pyramid3Offset.dy);
    markShadowPath.close();
    canvas.drawPath(markShadowPath, markShadowPaint);
  }

  void _drawMarkPath(Canvas canvas, Size size) {
    double point2X = markOffset2.dx + percentage;
    double point3X = point2X;
    markPath.moveTo(markOffset1.dx, markOffset1.dy);
    markPath.lineTo(point2X, markOffset2.dy);
    markPath.lineTo(point3X, markOffset3.dy);
    markPath.lineTo(markOffset4.dx, markOffset4.dy);
    markPath.lineTo(markOffset5.dx, markOffset5.dy);
    markPath.lineTo(markOffset6.dx, markOffset6.dy);
    markPath.close();
//    canvas.drawPath(markPath, markPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
