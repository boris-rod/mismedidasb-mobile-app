import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXBoxCellCheckDataWidget extends StatelessWidget {
  final String value;
  final Function onTap;
  final double width;
  final bool checked;

  const TXBoxCellCheckDataWidget(
      {Key key, this.value, this.onTap, this.width, this.checked = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 5),
        width: width ?? double.infinity,
        height: 38,
        decoration: BoxDecoration(
            border: Border.all(width: 4, color: Colors.black),
            color: Colors.white),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TXTextWidget(
                text: value,
                maxLines: 1,
                fontWeight: FontWeight.w500,
                textOverflow: TextOverflow.ellipsis,
                color: Colors.black,
              ),
            ),
            Icon(
              checked
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: Colors.black,
              size: 26,
            )
          ],
        ),
      ),
    );
  }
}
