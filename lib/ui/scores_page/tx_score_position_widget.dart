import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:mismedidasb/res/R.dart';

class TXScorePositionWidget extends StatelessWidget {
  final double percentageBehind;

  const TXScorePositionWidget({Key key, this.percentageBehind})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Material(
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: 210,
        child: CustomPaint(
          painter: _TXCustomPaint(percentageBehind),
        ),
      ),
    );
  }
}

class _TXCustomPaint extends CustomPainter {
  static double _markWidth = 10;
  static double _offsetPyramidBottom = 50;
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

//  Offset markOffset1;
//  Offset markOffset2;
//  Offset markOffset3;
//  Offset markOffset4;
//  Offset markOffset5;
//  Offset markOffset6;
  Offset lineYou1;
  Offset lineYou2;

  Rect pyramidRect;
  List<_MarkPointsModel> marks;
  double percentage = 0;

  _TXCustomPaint(double percentageB) {
    percentage = percentageB;
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

    marks = [];
  }

  @override
  void paint(Canvas canvas, Size size) {
    pyramidRect = Rect.fromPoints(
        Offset(size.width - 170, 25), Offset(size.width - 20, 190));

    pyramid1Offset =
        Offset(pyramidRect.left, pyramidRect.bottom - _offsetPyramidBottom);
    pyramid2Offset =
        Offset(pyramidRect.left + pyramidRect.width / 2, pyramidRect.bottom);
    pyramid3Offset =
        Offset(pyramidRect.right, pyramidRect.bottom - _offsetPyramidBottom);
    pyramid4Offset =
        Offset(pyramidRect.left + pyramidRect.width / 2, pyramidRect.top);

//    double point1 = math.max(pyramidRect.bottom * (100 - percentage) / 100,
//        pyramidRect.top + _markWidth);
//
//    markOffset1 = Offset(pyramidRect.left + pyramidRect.left / 2, point1);
//    markOffset2 = Offset(pyramidRect.left, point1 - _offsetPyramidBottom);
//    markOffset3 =
//        Offset(pyramidRect.left, point1 - (_offsetPyramidBottom + _markWidth));
//    markOffset4 =
//        Offset(pyramidRect.left + pyramidRect.left / 2, point1 - _markWidth);
//    markOffset5 =
//        Offset(pyramidRect.right, point1 - (_offsetPyramidBottom + _markWidth));
//    markOffset6 = Offset(pyramidRect.right, point1 - _offsetPyramidBottom);

//    lineYou1 = Offset(markOffset2.dx, markOffset2.dy - 3);
//    lineYou2 = Offset(0, markOffset2.dy - 3);

//    canvas.drawRect(
//        Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)),
//        Paint()..style = PaintingStyle.stroke);
//    canvas.drawRect(pyramidRect, Paint()..style = PaintingStyle.stroke);
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
//    canvas.drawLine(
//        Offset(pyramid1Offset.dx, pyramid1Offset.dy),
//        Offset(pyramid4Offset.dx, pyramid4Offset.dy),
//        Paint()
//          ..color = Colors.black
//          ..style = PaintingStyle.fill
//          ..strokeWidth = .5);
//
//    canvas.drawLine(
//        Offset(pyramid3Offset.dx, pyramid3Offset.dy),
//        Offset(pyramid4Offset.dx, pyramid4Offset.dy),
//        Paint()
//          ..color = Colors.black
//          ..style = PaintingStyle.fill
//          ..strokeWidth = .5);

    _generateMarksModels(canvas, size);

    canvas.drawRect(
        Rect.fromPoints(Offset(pyramidRect.left, pyramidRect.top),
            Offset(pyramidRect.right, 0)),
        Paint()..color = Colors.white);
    _drawLineYou(canvas, size);
  }

  void _drawLineYou(Canvas canvas, Size size) {
    int pos = 1;
    double yPos = pyramidRect.bottom - _offsetPyramidBottom;
    double xOffset = 0;
    if (percentage <= 10) {
      pos = 1;
      yPos = pyramidRect.bottom - _offsetPyramidBottom;
      xOffset = 0;
    } else if (percentage > 10 && percentage <= 20) {
      pos = 2;
      yPos = pyramidRect.bottom - _offsetPyramidBottom - 10;
      xOffset = 7;
    } else if (percentage > 20 && percentage <= 30) {
      pos = 3;
      yPos = pyramidRect.bottom - _offsetPyramidBottom - 21;
      xOffset = 14;
    } else if (percentage > 30 && percentage <= 40) {
      pos = 4;
      yPos = pyramidRect.bottom - _offsetPyramidBottom - 32;
      xOffset = 21;
    } else if (percentage > 40 && percentage <= 50) {
      pos = 5;
      yPos = pyramidRect.bottom - _offsetPyramidBottom - 43;
      xOffset = 28;
    } else if (percentage > 50 && percentage <= 60) {
      pos = 6;
      yPos = pyramidRect.bottom - _offsetPyramidBottom - 55;
      xOffset = 36;
    } else if (percentage > 60 && percentage <= 70) {
      pos = 7;
      yPos = pyramidRect.bottom - _offsetPyramidBottom - 67;
      xOffset = 44;
    } else if (percentage > 70 && percentage <= 80) {
      pos = 8;
      yPos = pyramidRect.bottom - _offsetPyramidBottom - 80;
      xOffset = 52;
    } else if (percentage > 80 && percentage <= 90) {
      pos = 9;
      yPos = pyramidRect.bottom - _offsetPyramidBottom - 93;
      xOffset = 61;
    } else if (percentage > 90) {
      pos = 10;
      yPos = pyramidRect.bottom - _offsetPyramidBottom - 107;
      xOffset = 70;
    }

    Offset linePt1 = Offset(20, yPos);
    Offset linePt2 = Offset(pyramidRect.left + xOffset, yPos);

    final ui.ParagraphStyle style = ui.ParagraphStyle(
      textAlign: TextAlign.justify,
      fontSize: 15,
      fontFamily: 'Raleway',
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold,
    );
    final ui.TextStyle st = ui.TextStyle(color: Colors.orange);
    final ui.ParagraphBuilder paragraphBuilder = ui.ParagraphBuilder(style)
      ..pushStyle(st)
      ..addText("Tú");
    final paragraph = paragraphBuilder.build()
      ..layout(ParagraphConstraints(width: 100));
    canvas.drawParagraph(paragraph, Offset(linePt1.dx, linePt1.dy - 20));

    canvas.drawLine(linePt1, linePt2, markPaint);
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
    markShadowPath.lineTo(pyramid2Offset.dx + 30, size.height);
    markShadowPath.lineTo(size.width, size.height);
    markShadowPath.lineTo(size.width, size.height - 55);
    markShadowPath.lineTo(pyramid3Offset.dx, pyramid3Offset.dy);
    markShadowPath.close();
    canvas.drawPath(markShadowPath, markShadowPaint);
  }

//  void _drawMarkPath(Canvas canvas, Size size) {
//    double point2X = markOffset2.dx + percentage;
//    double point3X = point2X;
//    markPath.moveTo(markOffset1.dx, markOffset1.dy);
//    markPath.lineTo(point2X, markOffset2.dy);
//    markPath.lineTo(point3X, markOffset3.dy);
//    markPath.lineTo(markOffset4.dx, markOffset4.dy);
//    markPath.lineTo(markOffset5.dx, markOffset5.dy);
//    markPath.lineTo(markOffset6.dx, markOffset6.dy);
//    markPath.close();
//    canvas.drawPath(markPath, markPaint);
//  }

  void _generateMarksModels(Canvas canvas, Size size) {
    final halfW = pyramidRect.left + pyramidRect.width / 2;
    final hypotenuse = pyramidRect.height;
    final cat1 = math.sqrt(math.pow(pyramidRect.width / 2, 2) +
        math.pow(pyramidRect.height - _offsetPyramidBottom, 2));
    final startBottomCat = pyramidRect.bottom - _offsetPyramidBottom;

    final cat2Space = (cat1 % (10 * _markWidth)) / 9;
    final hypotenuseSpace = (hypotenuse % (10 * _markWidth)) / 9;

    final _MarkPointsModel mark1 = _MarkPointsModel(
      position: 1,
      pt1: Offset(halfW, pyramidRect.bottom),
      pt2: Offset(pyramidRect.left, startBottomCat),
      pt3: Offset(pyramidRect.left, startBottomCat - _markWidth),
      pt4: Offset(halfW, pyramidRect.bottom - _markWidth),
      pt5: Offset(pyramidRect.right, startBottomCat - _markWidth),
      pt6: Offset(pyramidRect.right, startBottomCat),
    );
    marks.add(mark1);

    final _MarkPointsModel mark2 = _MarkPointsModel(
      position: 2,
      pt1: Offset(halfW, pyramidRect.bottom - (_markWidth + hypotenuseSpace)),
      pt2: Offset(pyramidRect.left, startBottomCat - (_markWidth + cat2Space)),
      pt3: Offset(
          pyramidRect.left, startBottomCat - (_markWidth * 2 + cat2Space)),
      pt4: Offset(
          halfW, pyramidRect.bottom - (_markWidth * 2 + hypotenuseSpace)),
      pt5: Offset(
          pyramidRect.right, startBottomCat - (_markWidth * 2 + cat2Space)),
      pt6: Offset(pyramidRect.right, startBottomCat - (_markWidth + cat2Space)),
    );
    marks.add(mark2);

    final _MarkPointsModel mark3 = _MarkPointsModel(
      position: 3,
      pt1: Offset(
          halfW, pyramidRect.bottom - (_markWidth * 2 + hypotenuseSpace * 2)),
      pt2: Offset(
          pyramidRect.left, startBottomCat - (_markWidth * 2 + cat2Space * 2)),
      pt3: Offset(
          pyramidRect.left, startBottomCat - (_markWidth * 3 + cat2Space * 2)),
      pt4: Offset(
          halfW,
          pyramidRect.bottom -
              (_markWidth + _markWidth * 2 + hypotenuseSpace * 2)),
      pt5: Offset(
          pyramidRect.right, startBottomCat - (_markWidth * 3 + cat2Space * 2)),
      pt6: Offset(
          pyramidRect.right, startBottomCat - (_markWidth * 2 + cat2Space * 2)),
    );
    marks.add(mark3);

    final _MarkPointsModel mark4 = _MarkPointsModel(
      position: 4,
      pt1: Offset(
          halfW, pyramidRect.bottom - (_markWidth * 3 + hypotenuseSpace * 3)),
      pt2: Offset(
          pyramidRect.left, startBottomCat - (_markWidth * 3 + cat2Space * 3)),
      pt3: Offset(
          pyramidRect.left, startBottomCat - (_markWidth * 4 + cat2Space * 3)),
      pt4: Offset(
          halfW,
          pyramidRect.bottom -
              (_markWidth + _markWidth * 3 + hypotenuseSpace * 3)),
      pt5: Offset(
          pyramidRect.right, startBottomCat - (_markWidth * 4 + cat2Space * 3)),
      pt6: Offset(
          pyramidRect.right, startBottomCat - (_markWidth * 3 + cat2Space * 3)),
    );
    marks.add(mark4);

    final _MarkPointsModel mark5 = _MarkPointsModel(
      position: 5,
      pt1: Offset(
          halfW, pyramidRect.bottom - (_markWidth * 4 + hypotenuseSpace * 4)),
      pt2: Offset(
          pyramidRect.left, startBottomCat - (_markWidth * 4 + cat2Space * 4)),
      pt3: Offset(
          pyramidRect.left, startBottomCat - (_markWidth * 5 + cat2Space * 4)),
      pt4: Offset(
          halfW,
          pyramidRect.bottom -
              (_markWidth + _markWidth * 4 + hypotenuseSpace * 4)),
      pt5: Offset(
          pyramidRect.right, startBottomCat - (_markWidth * 5 + cat2Space * 4)),
      pt6: Offset(
          pyramidRect.right, startBottomCat - (_markWidth * 4 + cat2Space * 4)),
    );
    marks.add(mark5);

    final _MarkPointsModel mark6 = _MarkPointsModel(
      position: 6,
      pt1: Offset(
          halfW, pyramidRect.bottom - (_markWidth * 5 + hypotenuseSpace * 5)),
      pt2: Offset(
          pyramidRect.left, startBottomCat - (_markWidth * 5 + cat2Space * 5)),
      pt3: Offset(
          pyramidRect.left, startBottomCat - (_markWidth * 6 + cat2Space * 5)),
      pt4: Offset(
          halfW,
          pyramidRect.bottom -
              (_markWidth + _markWidth * 5 + hypotenuseSpace * 5)),
      pt5: Offset(
          pyramidRect.right, startBottomCat - (_markWidth * 6 + cat2Space * 5)),
      pt6: Offset(
          pyramidRect.right, startBottomCat - (_markWidth * 5 + cat2Space * 5)),
    );
    marks.add(mark6);

    final _MarkPointsModel mark7 = _MarkPointsModel(
      position: 7,
      pt1: Offset(
          halfW, pyramidRect.bottom - (_markWidth * 6 + hypotenuseSpace * 6)),
      pt2: Offset(
          pyramidRect.left, startBottomCat - (_markWidth * 6 + cat2Space * 6)),
      pt3: Offset(
          pyramidRect.left, startBottomCat - (_markWidth * 7 + cat2Space * 6)),
      pt4: Offset(
          halfW,
          pyramidRect.bottom -
              (_markWidth + _markWidth * 6 + hypotenuseSpace * 6)),
      pt5: Offset(
          pyramidRect.right, startBottomCat - (_markWidth * 7 + cat2Space * 6)),
      pt6: Offset(
          pyramidRect.right, startBottomCat - (_markWidth * 6 + cat2Space * 6)),
    );
    marks.add(mark7);

    final _MarkPointsModel mark8 = _MarkPointsModel(
      position: 8,
      pt1: Offset(
          halfW, pyramidRect.bottom - (_markWidth * 7 + hypotenuseSpace * 7)),
      pt2: Offset(
          pyramidRect.left, startBottomCat - (_markWidth * 7 + cat2Space * 7)),
      pt3: Offset(
          pyramidRect.left, startBottomCat - (_markWidth * 8 + cat2Space * 7)),
      pt4: Offset(
          halfW,
          pyramidRect.bottom -
              (_markWidth + _markWidth * 7 + hypotenuseSpace * 7)),
      pt5: Offset(
          pyramidRect.right, startBottomCat - (_markWidth * 8 + cat2Space * 7)),
      pt6: Offset(
          pyramidRect.right, startBottomCat - (_markWidth * 7 + cat2Space * 7)),
    );
    marks.add(mark8);

    final _MarkPointsModel mark9 = _MarkPointsModel(
      position: 9,
      pt1: Offset(
          halfW, pyramidRect.bottom - (_markWidth * 8 + hypotenuseSpace * 8)),
      pt2: Offset(
          pyramidRect.left, startBottomCat - (_markWidth * 8 + cat2Space * 8)),
      pt3: Offset(
          pyramidRect.left, startBottomCat - (_markWidth * 9 + cat2Space * 8)),
      pt4: Offset(
          halfW,
          pyramidRect.bottom -
              (_markWidth + _markWidth * 8 + hypotenuseSpace * 8)),
      pt5: Offset(
          pyramidRect.right, startBottomCat - (_markWidth * 9 + cat2Space * 8)),
      pt6: Offset(
          pyramidRect.right, startBottomCat - (_markWidth * 8 + cat2Space * 8)),
    );
    marks.add(mark9);

    final _MarkPointsModel mark10 = _MarkPointsModel(
      position: 10,
      pt1: Offset(
          halfW, pyramidRect.bottom - (_markWidth * 9 + hypotenuseSpace * 9)),
      pt2: Offset(
          pyramidRect.left, startBottomCat - (_markWidth * 9 + cat2Space * 9)),
      pt3: Offset(
          pyramidRect.left, startBottomCat - (_markWidth * 10 + cat2Space * 9)),
      pt4: Offset(
          halfW,
          pyramidRect.bottom -
              (_markWidth + _markWidth * 9 + hypotenuseSpace * 9)),
      pt5: Offset(pyramidRect.right,
          startBottomCat - (_markWidth * 10 + cat2Space * 9)),
      pt6: Offset(
          pyramidRect.right, startBottomCat - (_markWidth * 9 + cat2Space * 9)),
    );
    marks.add(mark10);

    marks.forEach((element) {
      Path p = Path();
      p.moveTo(element.pt1.dx, element.pt1.dy);
      p.lineTo(element.pt2.dx, element.pt2.dy);
      p.lineTo(element.pt3.dx, element.pt3.dy);
      p.lineTo(element.pt4.dx, element.pt4.dy);
      p.lineTo(element.pt5.dx, element.pt5.dy);
      p.lineTo(element.pt6.dx, element.pt6.dy);
      p.close();

      if (element.position == 1 && percentage <= 10) {
        canvas.drawPath(p, markPaint);
      } else if (element.position == 2 && percentage > 10 && percentage <= 20) {
        canvas.drawPath(p, markPaint);
      } else if (element.position == 3 && percentage > 20 && percentage <= 30) {
        canvas.drawPath(p, markPaint);
      } else if (element.position == 4 && percentage > 30 && percentage <= 40) {
        canvas.drawPath(p, markPaint);
      } else if (element.position == 5 && percentage > 40 && percentage <= 50) {
        canvas.drawPath(p, markPaint);
      } else if (element.position == 6 && percentage > 50 && percentage <= 60) {
        canvas.drawPath(p, markPaint);
      } else if (element.position == 7 && percentage > 60 && percentage <= 70) {
        canvas.drawPath(p, markPaint);
      } else if (element.position == 8 && percentage > 70 && percentage <= 80) {
        canvas.drawPath(p, markPaint);
      } else if (element.position == 9 && percentage > 80 && percentage <= 90) {
        canvas.drawPath(p, markPaint);
      } else if (element.position == 10 && percentage > 90) {
        canvas.drawPath(p, markPaint);
      }
    });

    Path overlay1 = Path();
    overlay1.moveTo(pyramidRect.left, pyramidRect.top);
    overlay1.lineTo(halfW, pyramidRect.top);
    overlay1.lineTo(pyramidRect.left, startBottomCat);
    overlay1.close();
    canvas.drawPath(overlay1, Paint()..color = Colors.white);

    Path overlay2 = Path();
    overlay2.moveTo(pyramidRect.right, pyramidRect.top);
    overlay2.lineTo(halfW, pyramidRect.top);
    overlay2.lineTo(pyramidRect.right, startBottomCat);
    overlay2.close();
    canvas.drawPath(overlay2, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _MarkPointsModel {
  int position;
  Offset pt1;
  Offset pt2;
  Offset pt3;
  Offset pt4;
  Offset pt5;
  Offset pt6;

  _MarkPointsModel(
      {this.position,
      this.pt1,
      this.pt2,
      this.pt3,
      this.pt4,
      this.pt5,
      this.pt6});
}
