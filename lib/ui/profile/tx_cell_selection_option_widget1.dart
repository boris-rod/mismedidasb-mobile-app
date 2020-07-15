import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXCellSelectionOptionWidget1 extends StatelessWidget {
  final IconData leading;
  final String optionName;
  final Function onOptionTap;
  final IconData trailing;

  const TXCellSelectionOptionWidget1(
      {Key key, this.optionName, this.onOptionTap, this.trailing, this.leading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: R.color.profile_color,
      child: InkWell(
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
                      color: Colors.white,
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
                    fontWeight: FontWeight.bold,
                    textOverflow: TextOverflow.ellipsis,
                    color: Colors.white,
                  )),
              Image.asset(R.image.forward, width: 25, height: 25,)
            ],
          ),
        ),
      ),
    );
  }
}
