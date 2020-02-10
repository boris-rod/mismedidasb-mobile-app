import 'package:flutter/material.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXCheckBoxWidget extends StatelessWidget {
  final String text;
  final bool value;
  final ValueChanged<bool> onChange;
  final bool leading;
  final Color textColor;

  TXCheckBoxWidget(
      {this.text,
      this.onChange,
      this.value = false,
      this.leading = false,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChange(!value);
      },
      child: Container(
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
              color: textColor,
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
