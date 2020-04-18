import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXCheckBoxWidget extends StatelessWidget {
  final String text;
  final bool value;
  final ValueChanged<bool> onChange;
  final bool leading;
  final Color textColor;
  final EdgeInsetsGeometry padding;

  TXCheckBoxWidget(
      {this.text,
      this.onChange,
      this.value = false,
      this.leading = false,
      this.textColor, this.padding});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChange(!value);
      },
      child: Container(
        padding: padding,
        child: leading ? leadingWidget() : trailingWidget(),
      ),
    );
  }

  Widget trailingWidget() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: TXTextWidget(
              text: text,
              color: textColor ?? R.color.primary_color,
            ),
          ),
          Checkbox(
            onChanged: (value) {
              onChange(value);
            },
            value: value,
          )
        ],
      );

  Widget leadingWidget() => Row(
        children: <Widget>[
          Container(
            child: Checkbox(
              onChanged: (value) {
                onChange(value);
              },
              value: value,
            ),
          ),
          Expanded(
            child: TXTextWidget(
              text: text,
            ),
          ),
        ],
      );
}
