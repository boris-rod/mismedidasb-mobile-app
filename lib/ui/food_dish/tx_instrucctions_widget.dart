import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';

class TXInstructionsWidget extends StatelessWidget {
  final String instructions;

  const TXInstructionsWidget({Key key, this.instructions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      color: R.color.profile_options_color,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 30),
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
                    color: Colors.white,
                  ),
                ),
                Container(
                  child: TXTextLinkWidget(
                    title: R.string.ok,
                    textColor: R.color.gray_light,
                    onTap: () {
                      NavigationUtils.pop(context);
                    },
                  ),
                )
              ],
            ),
            Container(
              child: Html(
                data: instructions,
                style: {"p": Style(color: Colors.white)},
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TXTextWidget(
              textAlign: TextAlign.center,
              text: R.string.appClinicalWarning,
              size: 10,
              color: R.color.gray_light,
            ),
          ],
        ),
      ),
    );
  }
}
