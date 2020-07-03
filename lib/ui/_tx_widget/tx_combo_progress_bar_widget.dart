import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:math' as math;

class TXComboProgressBarWidget extends StatefulWidget {
  final String title;
  final double percentage;
  final double mark1;
  final double mark2;
  final double value;
  final double height;
  final double titleSize;
  final bool showValueInBar;
  final bool showPercentageInfo;
  final double imc;
  final Color backgroundProgress;

  const TXComboProgressBarWidget(
      {Key key,
      this.title,
      this.percentage,
      this.mark1,
      this.mark2,
      this.showValueInBar = false,
      this.showPercentageInfo = true,
      this.value,
      this.height,
      this.titleSize,
      this.imc = 1,
      this.backgroundProgress})
      : super(key: key);

  @override
  _TXComboProgressBarWidgetState createState() =>
      _TXComboProgressBarWidgetState();
}

class _TXComboProgressBarWidgetState extends State<TXComboProgressBarWidget> {
  @override
  Widget build(BuildContext context) {
    final color = widget.value < widget.mark1
        ? (widget.imc < 18.5 ? R.color.food_red : R.color.food_yellow)
        : widget.value >= widget.mark1 && widget.percentage <= 101
            ? R.color.food_green
            : (widget.imc < 18.5 ? R.color.food_green : R.color.food_red);

    return Stack(
      children: <Widget>[
        LinearPercentIndicator(
          lineHeight: widget.height ?? 20,
          linearStrokeCap: LinearStrokeCap.butt,
          backgroundColor: R.color.food_blue_light,
          progressColor: color,
          padding: EdgeInsets.all(0),
          animation: false,
          percent: math.max(math.min(widget.percentage.toInt() / 100, 1), 0),
        ),
        Positioned(
          left: 15,
          top: widget.height == 20 ? 4 : 2,
          child: TXTextWidget(
            text: widget.title,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            size: 10,
          ),
        ),
        Positioned(
          right: 10,
          top: widget.height == 20 ? 4 : 2,
          child: TXTextWidget(
            text: widget.showPercentageInfo ? "${widget.percentage.toInt()}%" : "",
            color: Colors.white,
            fontWeight: FontWeight.bold,
            size: 10,
          ),
        )
      ],
    );
//    return Container(
//      color: R.color.food_blue_light,
//      height: widget.height ?? 15,
//      width: double.infinity,
//      child: FutureBuilder<double>(
//        future: _getProgress(),
//        initialData: 0.0,
//        builder: (ctx, snapshot) {
//          return Stack(
//            children: <Widget>[
//              Container(
//                height: double.infinity,
//                width: snapshot.data,
//                color: color,
//              ),
//              Positioned(
//                right: 5,
//                top: widget.height == 20 ? 4 : 2,
//                child: TXTextWidget(
//                  color: Colors.white,
//                  text: "${widget.percentage.toInt()}%",
//                  size: 10,
//                  fontWeight: FontWeight.bold,
//                ),
//              )
//            ],
//          );
//        },
//      ),
//    );
//    return Stack(
//      children: <Widget>[
//        widget.value < widget.mark1
//            ? RoundedProgressBar(
//                height: widget.height ?? 20,
//                paddingChildLeft: EdgeInsets.only(left: 10),
//                paddingChildRight: EdgeInsets.only(right: 0),
//                percent: widget.percentage,
//                childLeft: TXTextWidget(
//                  text: widget.title,
//                  color: widget.percentage < 1 ? Colors.white : Colors.black,
//                  size: widget.titleSize ?? 12,
//                ),
//                childRight: Container(
//                  margin: EdgeInsets.only(right: 5),
//                  child: TXTextWidget(
//                    fontWeight: FontWeight.bold,
//                    text: widget.showPercentageInfo
//                        ? "${widget.percentage.toInt()}% ${widget.showValueInBar ? "${widget.value.toStringAsFixed(2)}kCal" : ""}"
//                        : "",
//                    size: widget.titleSize ?? 10,
//                    color: Colors.white,
//                  ),
//                ),
//                margin: EdgeInsets.all(0),
//                style: RoundedProgressBarStyle(
//                    widthShadow: 0,
//                    backgroundProgress:
//                        widget.backgroundProgress ?? R.color.food_blue_light,
//                    colorProgress: widget.imc < 18.5
//                        ? R.color.food_red
//                        : R.color.food_yellow,
//                    borderWidth: 0),
//              )
//            : Container(),
//        widget.value >= widget.mark1 && widget.percentage <= 101
//            ? RoundedProgressBar(
//                height: widget.height ?? 20,
//                paddingChildLeft: EdgeInsets.only(left: 10),
//                paddingChildRight: EdgeInsets.only(right: 0),
//                percent: widget.percentage,
//                childLeft: TXTextWidget(
//                  text: widget.title,
//                  color: Colors.black,
//                  size: widget.titleSize ?? 10,
//                ),
//                childRight: TXTextWidget(
//                  fontWeight: FontWeight.bold,
//                  text: widget.showPercentageInfo
//                      ? "${widget.percentage.toInt()}% ${widget.showValueInBar ? "${widget.value.toStringAsFixed(2)}kCal" : ""}"
//                      : "",
//                  size: widget.titleSize ?? 10,
//                  color: Colors.white,
//                ),
//                margin: EdgeInsets.all(0),
//                style: RoundedProgressBarStyle(
//                    widthShadow: 0,
//                    backgroundProgress:
//                        widget.backgroundProgress ?? R.color.food_blue_light,
//                    colorProgress: R.color.food_green,
//                    borderWidth: 0),
//              )
//            : Container(),
//        widget.percentage > 101
//            ? RoundedProgressBar(
//                height: widget.height ?? 20,
//                paddingChildLeft: EdgeInsets.only(left: 10),
//                paddingChildRight: EdgeInsets.only(right: 0),
//                percent: widget.percentage,
//                childLeft: TXTextWidget(
//                  text: widget.title,
//                  color: Colors.black,
//                  size: widget.titleSize ?? 10,
//                ),
//                childCenter: TXTextWidget(
//                  fontWeight: FontWeight.bold,
//                  text: widget.showPercentageInfo
//                      ? "${widget.percentage.toInt()}% ${widget.showValueInBar ? "${widget.value.toStringAsFixed(2)}kCal" : ""}"
//                      : "",
//                  size: widget.titleSize ?? 10,
//                  color: Colors.black,
//                ),
//                margin: EdgeInsets.all(0),
//                style: RoundedProgressBarStyle(
//                    widthShadow: 0,
//                    backgroundProgress:
//                        widget.backgroundProgress ?? R.color.food_blue_light,
//                    colorProgress: widget.imc < 18.5
//                        ? R.color.food_green
//                        : R.color.food_red,
//                    borderWidth: 0),
//              )
//            : Container()
//      ],
//    );
  }

//  double _getViewWidth() {
//    final RenderBox renderBoxRed =
//        widget.viewKey.currentContext.findRenderObject();
//    return renderBoxRed.size.width;
//  }
//
//  Future<double> _getProgress() async {
//    return widget.percentage * _getViewWidth() / 100;
//  }
}
