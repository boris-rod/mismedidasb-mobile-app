import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';

class TXBottomResultInfo extends StatelessWidget {
  final String content;
  final String title;
  final double height;

  const TXBottomResultInfo({Key key, this.content, this.title, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 300,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.topLeft,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TXTextWidget(
                    text: title ?? R.string.thanks,
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                    size: 18,
                  ),
                ),
                Container(
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
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 20),
                child: Center(
                  child: TXTextWidget(
                      textAlign: TextAlign.justify,
                      text: content ?? ""),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
