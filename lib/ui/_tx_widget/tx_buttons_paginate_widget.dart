import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_navigator_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXButtonPaginateWidget extends StatelessWidget {
  final Function onNext;
  final Function onPrevious;
  final String nextTitle;
  final String previousTitle;
  final int total;
  final int page;
  final bool showBackNavigation;

  const TXButtonPaginateWidget({
    Key key,
    this.onNext,
    this.onPrevious,
    this.nextTitle,
    this.previousTitle,
    this.total = 1,
    this.page = 1,
    this.showBackNavigation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 20),
      width: double.infinity,
      height: 70,
      alignment: Alignment.center,
      child: Stack(
        children: <Widget>[
          (showBackNavigation ?? true) ?
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              child: TXIconNavigatorWidget(
                text: previousTitle ?? R.string.previous,
                onTap: onPrevious,
              ),
            ),
          ): Container(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.center,
                child: TXTextWidget(
                  text: "$page / $total",
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              child: TXIconNavigatorWidget(
                isLeading: false,
                text: nextTitle ?? R.string.next,
                onTap: onNext,
              ),
            ),
          )
        ],
      ),
    );
  }
}
