import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXComboProgressBarWidget extends StatelessWidget {
  final String title;
  final double percentage;
  final double mark1;
  final double mark2;
  final double value;
  final double height;
  final double titleSize;
  final bool showValueInBar;
  final bool showPercentageInfo;

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
      this.titleSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        value < mark1
            ? RoundedProgressBar(
                height: height ?? 20,
                paddingChildLeft: EdgeInsets.only(left: 10),
                paddingChildRight: EdgeInsets.only(right: 0),
                percent: percentage,
                childLeft: TXTextWidget(
                  text: title,
                  color: Colors.black,
                  size: titleSize ?? 12,
                ),
                childCenter: TXTextWidget(
                  fontWeight: FontWeight.bold,
                  text: showPercentageInfo ?
                  "${percentage.toInt()}/100% ${showValueInBar ? "${value.toStringAsFixed(2)}kCal" : ""}" : "",
                  size: titleSize ?? 10,
                  color: Colors.black,
                ),
                margin: EdgeInsets.all(0),
                style: RoundedProgressBarStyle(
                    widthShadow: 0,
                    backgroundProgress: Colors.grey[200],
                    colorProgress: Colors.yellowAccent,
                    borderWidth: 0),
              )
            : Container(),
        value >= mark1 && value <= mark2
            ? RoundedProgressBar(
                height: height ?? 20,
                paddingChildLeft: EdgeInsets.only(left: 10),
                paddingChildRight: EdgeInsets.only(right: 0),
                percent: percentage,
                childLeft: TXTextWidget(
                  text: title,
                  color: Colors.black,
                  size: titleSize ?? 10,
                ),
                childCenter: TXTextWidget(
                  fontWeight: FontWeight.bold,
                  text: showPercentageInfo ?
                  "${percentage.toInt()}/100% ${showValueInBar ? "${value.toStringAsFixed(2)}kCal" : ""}" : "",
                  size: titleSize ?? 10,
                  color: Colors.black,
                ),
                margin: EdgeInsets.all(0),
                style: RoundedProgressBarStyle(
                    widthShadow: 0,
                    backgroundProgress: Colors.grey[200],
                    colorProgress: Colors.greenAccent,
                    borderWidth: 0),
              )
            : Container(),
        value > mark2
            ? RoundedProgressBar(
                height: height ?? 20,
                paddingChildLeft: EdgeInsets.only(left: 10),
                paddingChildRight: EdgeInsets.only(right: 0),
                percent: percentage,
                childLeft: TXTextWidget(
                  text: title,
                  color: Colors.black,
                  size: titleSize ?? 10,
                ),
                childCenter: TXTextWidget(
                  fontWeight: FontWeight.bold,
                  text: showPercentageInfo ?
                  "${percentage.toInt()}/100% ${showValueInBar ? "${value.toStringAsFixed(2)}kCal" : ""}" : "",
                  size: titleSize ?? 10,
                  color: Colors.black,
                ),
                margin: EdgeInsets.all(0),
                style: RoundedProgressBarStyle(
                    widthShadow: 0,
                    backgroundProgress: Colors.grey[200],
                    colorProgress: Colors.redAccent,
                    borderWidth: 0),
              )
            : Container()
      ],
    );
  }
}
