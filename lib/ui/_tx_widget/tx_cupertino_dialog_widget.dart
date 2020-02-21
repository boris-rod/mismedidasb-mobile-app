import 'package:flutter/cupertino.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXCupertinoDialogWidget extends StatelessWidget {
  final Function onOK;
  final Function onCancel;
  final String title;
  final String content;

  const TXCupertinoDialogWidget(
      {Key key, this.onOK, this.onCancel, this.title, this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: TXTextWidget(
        text: title,
      ),
      content: TXTextWidget(
        text: content,
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: TXTextWidget(
            text: R.string.cancel,
          ),
          onPressed: onCancel,
        ),
        CupertinoDialogAction(
          child: TXTextWidget(
            text: R.string.ok,
          ),
          onPressed: onOK,
        ),
      ],
    );
  }
}
