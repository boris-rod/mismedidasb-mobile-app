import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXCellSelectionOptionWidget extends StatelessWidget {
  final IconData leading;
  final String optionName;
  final Function onOptionTap;
  final IconData trailing;

  const TXCellSelectionOptionWidget(
      {Key key, this.optionName, this.onOptionTap, this.trailing, this.leading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onOptionTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            leading != null
                ? Icon(
                    leading,
                    color: R.color.primary_color,
                    size: 20,
                  )
                : Container(),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: TXTextWidget(
                  text: optionName,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                  color: Colors.black,
                )),
            Icon(
              trailing ?? Icons.keyboard_arrow_right,
              color: R.color.primary_dark_color,
              size: 25,
            )
          ],
        ),
      ),
    );
  }
}
