import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';

class TXInstructionsWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TXTextWidget(
                    text: R.string.foodInstructionsTitle,
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                    size: 18,
                  ),
                ),
                Container(
                  width: 50,
                  child: TXTextLinkWidget(
                    title: R.string.ok,
                    textColor: R.color.primary_color,
                    onTap: () {
                      NavigationUtils.pop(context);
                    },
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 20),
              child: Center(
                child: TXTextWidget(
                    textAlign: TextAlign.justify,
                    text: R.string.foodsInstructions),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TXTextWidget(
              textAlign: TextAlign.center,
              text: R.string.appClinicalWarning,
              size: 10,
              color: R.color.accent_color,
            ),
          ],
        ),
      ),
    );
  }

}