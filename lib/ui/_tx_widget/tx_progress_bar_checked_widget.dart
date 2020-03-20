import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXProgressBarCheckedWidget extends StatelessWidget {
  final double height;
  final double percentage;
  final Color color;
  final String title;
  final bool showTitle;
  final double titleSize;
  final bool showPercentage;
  final double minMark;

  const TXProgressBarCheckedWidget(
      {Key key,
      this.height,
      this.percentage,
      this.color,
      this.title,
      this.showTitle = true,
      this.showPercentage = true,
      this.titleSize,
      this.minMark})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: RoundedProgressBar(
            height: height ?? 15,
            paddingChildLeft: EdgeInsets.only(left: 10),
            paddingChildRight: EdgeInsets.only(right: 0),
            percent: percentage,
            childLeft: TXTextWidget(
              text: showTitle ? title : "",
              color: Colors.black,
              size: titleSize ?? 10,
            ),
            childCenter: TXTextWidget(
              fontWeight: FontWeight.bold,
              text: showPercentage ? "${percentage.toInt()}/100%" : "",
              size: titleSize ?? 10,
              color: Colors.black,
            ),
            margin: EdgeInsets.all(0),
            style: RoundedProgressBarStyle(
                widthShadow: 0,
                backgroundProgress: Colors.grey[200],
                colorProgress: color ?? Colors.redAccent,
                borderWidth: 0),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          child: Icon(
            percentage < minMark
                ? Icons.remove_circle_outline
                : (percentage > 100
                    ? Icons.add_circle_outline
                    : Icons.check_circle_outline),
            size: 14,
            color: percentage < minMark
                ? Colors.red[400]
                : (percentage > 100 ? Colors.red[400] : Colors.green[400]),
          ),
        )
      ],
    );
  }
}
