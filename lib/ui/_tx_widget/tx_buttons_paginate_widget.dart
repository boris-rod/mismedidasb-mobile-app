import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';

class TXButtonPaginateWidget extends StatelessWidget {
  final Function onNext;
  final Function onPrevious;
  final String nextTitle;
  final String previousTitle;

  const TXButtonPaginateWidget(
      {Key key,
      this.onNext,
      this.onPrevious,
      this.nextTitle,
      this.previousTitle,})
      : super(key: key);

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
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: TXButtonWidget(
                title: previousTitle ?? R.string.previous,
                onPressed: onPrevious,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerRight,
              width: double.infinity,
              child: TXButtonWidget(
                title: nextTitle ?? R.string.next,
                onPressed: onNext,
              ),
            ),
          )
        ],
      ),
    );
  }
}
