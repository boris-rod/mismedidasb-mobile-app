import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:math' as math;

class TXProgressBarCheckedWidget extends StatefulWidget {
  final double height;
  final double percentage;
  final Color color;
  final String title;
  final bool showTitle;
  final double titleSize;
  final bool showPercentage;
  final double minMark;
  final double value;

  const TXProgressBarCheckedWidget(
      {Key key,
      this.height,
      this.percentage,
      this.color,
      this.title,
      this.showTitle = true,
      this.showPercentage = true,
      this.titleSize,
      this.minMark, this.value})
      : super(key: key);

  @override
  _TXProgressBarCheckedWidgetState createState() =>
      _TXProgressBarCheckedWidgetState();
}

class _TXProgressBarCheckedWidgetState
    extends State<TXProgressBarCheckedWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              LinearPercentIndicator(
                lineHeight: 15,
                linearStrokeCap: LinearStrokeCap.butt,
                backgroundColor: R.color.food_blue_light,
                progressColor: R.color.food_blue_dark,
                padding: EdgeInsets.all(0),
                animation: false,
                percent: math.max(math.min(widget.percentage.toInt() / 100, 1), 0),
              ),
              Positioned(
                left: 15,
                top: 2,
                child: TXTextWidget(
                  text: "${widget.title}",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  size: 10,
                ),
              ),
              Positioned(
                right: 10,
                top: 2,
                child: TXTextWidget(
                  text: widget.showPercentage ? "${widget.percentage.toInt()}%" : "",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  size: 10,
                ),
              )
            ],
          ),
        ),
        SizedBox(width: 2,),
        Icon(
          widget.percentage < widget.minMark
              ? Icons.remove_circle_outline
              : (widget.percentage > 100
              ? Icons.add_circle_outline
              : Icons.check_circle_outline),
          size: 14,
          color: widget.percentage < widget.minMark
              ? R.color.food_red
              : (widget.percentage > 100
              ? R.color.food_red
              : R.color.food_green),
        )
      ],
    );

    double _widthMax = MediaQuery.of(context).size.width;

    double _currentWidth = widget.percentage * _widthMax / 100;

    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            color: R.color.food_blue_light,
            height: 15,
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: _currentWidth,
                  color: R.color.food_blue_dark,
                ),
                Positioned(
                  right: 5,
                  top: 2,
                  child: TXTextWidget(
                    color: Colors.white,
                    text: widget.showPercentage
                        ? "${widget.percentage.toInt()}%"
                        : "",
                    size: 10,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          child: Icon(
            widget.percentage < widget.minMark
                ? Icons.remove_circle_outline
                : (widget.percentage > 100
                    ? Icons.add_circle_outline
                    : Icons.check_circle_outline),
            size: 14,
            color: widget.percentage < widget.minMark
                ? Colors.red[400]
                : (widget.percentage > 100
                    ? Colors.red[400]
                    : Colors.green[400]),
          ),
        )
      ],
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: RoundedProgressBar(
            height: widget.height ?? 15,
            paddingChildLeft: EdgeInsets.only(left: 10),
            paddingChildRight: EdgeInsets.only(right: 0),
            percent: widget.percentage,
            childLeft: TXTextWidget(
              text: widget.showTitle ? widget.title : "",
              color: Colors.white,
              size: widget.titleSize ?? 12,
              fontWeight: FontWeight.bold,
            ),
            childRight: Container(
              margin: EdgeInsets.only(right: 10),
              child: TXTextWidget(
                fontWeight: FontWeight.bold,
                text: widget.showPercentage
                    ? "${widget.percentage.toInt()}%"
                    : "",
                size: widget.titleSize ?? 12,
                color: Colors.white,
              ),
            ),
            margin: EdgeInsets.all(0),
            style: RoundedProgressBarStyle(
                widthShadow: 0,
                backgroundProgress: R.color.food_blue_light,
                colorProgress: R.color.food_blue_dark,
                borderWidth: 0),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          child: Icon(
            widget.percentage < widget.minMark
                ? Icons.remove_circle_outline
                : (widget.percentage > 100
                    ? Icons.add_circle_outline
                    : Icons.check_circle_outline),
            size: 14,
            color: widget.percentage < widget.minMark
                ? Colors.red[400]
                : (widget.percentage > 100
                    ? Colors.red[400]
                    : Colors.green[400]),
          ),
        )
      ],
    );
  }
}
