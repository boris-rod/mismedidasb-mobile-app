import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';

class TXTextWidget extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight fontWeight;
  final int maxLines;
  final TextOverflow textOverflow;
  final TextAlign textAlign;
  final FontStyle fontStyle;
  final TextDecoration textDecoration;

  TXTextWidget(
      {@required this.text,
      this.size,
      this.color,
      this.fontWeight,
      this.maxLines,
      this.textOverflow,
      this.textAlign, this.fontStyle, this.textDecoration});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        color: color ?? Colors.black,
        fontSize: size ?? 15,
        fontWeight: fontWeight ?? FontWeight.w500,
        fontStyle: fontStyle ?? null,
        decoration: textDecoration
      ),
      maxLines: maxLines,
      overflow: textOverflow,
    );
  }
}
