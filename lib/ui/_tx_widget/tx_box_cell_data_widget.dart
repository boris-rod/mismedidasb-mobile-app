import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXBoxCellDataWidget extends StatelessWidget {
  final String value;
  final Function onTap;
  final double width;

  const TXBoxCellDataWidget({Key key, this.value, this.onTap, this.width})
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
            RotatedBox(
              quarterTurns: 1,
              child: Icon(
                Icons.play_arrow,
                color: Colors.black,
                size: 30,
              ),
            )
          ],
        ),
      ),
    );
  }
}
