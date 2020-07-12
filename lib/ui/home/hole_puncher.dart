import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'dart:ui' as ui;

class HolePuncher extends StatelessWidget {
  final Widget child;

  const HolePuncher({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: new CustomPaint(
        painter: HolePuncherPainter(),
//        willChange: true,
      ),
    );
  }
}

class HolePuncherPainter extends CustomPainter {
  Paint clearPaint;
  Path path;

  HolePuncherPainter() {
    path = Path();
    clearPaint = Paint()..color = R.color.discover_background;
  }

  @override
  void paint(Canvas canvas, Size size) {
    path.moveTo(0, 0);
    path.lineTo(0, 230);
    path.lineTo(160, 230);
    path.lineTo(180, 260);
    path.lineTo(180, 350);
    path.lineTo(160, 380);
    path.lineTo(0, 380);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, clearPaint);

    Offset linePt1 = Offset(20, 500);

    final ui.ParagraphStyle style = ui.ParagraphStyle(
      textAlign: TextAlign.justify,
      fontSize: 15,
      fontFamily: 'Raleway',
    );
    final ui.TextStyle st = ui.TextStyle(color: Colors.white);
    final ui.ParagraphBuilder paragraphBuilder = ui.ParagraphBuilder(style)
      ..pushStyle(st)
      ..addText("Comencemos por las Medidas de Salud. Completar el reporte de los datos que te solicitamos en esta vista es fundamental. Si no lo haces, no podrás acceder a las prestaciones que te brinda la vista de Mi Plan de Comidas.");
    final paragraph = paragraphBuilder.build()
      ..layout(ParagraphConstraints(width: size.width - 50));
    canvas.drawParagraph(paragraph, Offset(linePt1.dx, linePt1.dy - 20));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
