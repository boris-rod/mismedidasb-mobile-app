import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXButtonSelectorWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function onPressed;

  const TXButtonSelectorWidget(
      {Key key, this.text, this.isSelected, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
          side: BorderSide(color: R.color.primary_color, width: .5),
          borderRadius: BorderRadius.circular(45)),
      onPressed: onPressed,
      color: isSelected ? R.color.primary_color : Colors.white,
      child: TXTextWidget(
          text: text, color: isSelected ? Colors.white : R.color.primary_color),
    );
  }
}
