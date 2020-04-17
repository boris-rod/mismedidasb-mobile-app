import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

enum PROFILE_OPTION { CHANGE_PASSWORD, LOGOUT, HELP }

class TXProfileItemOptionWidget extends StatelessWidget {
  final IconData icon;
  final String optionName;
  final Function onOptionTap;

  const TXProfileItemOptionWidget(
      {Key key, this.icon, this.optionName, this.onOptionTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onOptionTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10).copyWith(left: 15),
        height: 45,
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: R.color.gray_darkest,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: TXTextWidget(
              text: optionName,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
              color: R.color.gray_darkest,
            )),
            Icon(
              Icons.keyboard_arrow_right,
              color: R.color.primary_dark_color,
              size: 25,
            )
          ],
        ),
      ),
    );
  }
}
