import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXButtonPaginateWidget extends StatelessWidget {
  final Function onNext;
  final Function onPrevious;
  final String nextTitle;
  final String previousTitle;
  final int total;
  final int page;

  const TXButtonPaginateWidget({
    Key key,
    this.onNext,
    this.onPrevious,
    this.nextTitle,
    this.previousTitle,
    this.total = 1,
    this.page = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 80,
      color: R.color.gray_light,
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Container(
            child: TXButtonWidget(
              title: previousTitle ?? R.string.previous,
              onPressed: onPrevious,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.center,
                child: TXTextWidget(
                  text: "$page / $total",
                ),
              ),
            ),
          ),
          Container(
            child: TXButtonWidget(
              title: nextTitle ?? R.string.next,
              onPressed: onNext,
            ),
          )
        ],
      ),
    );
  }
}
