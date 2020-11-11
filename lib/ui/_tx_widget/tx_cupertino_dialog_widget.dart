import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXCupertinoDialogWidget extends StatelessWidget {
  final Function onOK;
  final Function onCancel;
  final String title;
  final String content;
  final Widget contentWidget;
  final String okText;
  final String cancelText;


  const TXCupertinoDialogWidget(
      {Key key,
      this.onOK,
      this.onCancel,
      this.title,
      this.content,
      this.contentWidget, this.okText, this.cancelText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      isMaterialAppTheme: true,
      data: ThemeData(
          dialogBackgroundColor: Colors.white,
          dialogTheme: DialogTheme(backgroundColor: Colors.white)),
      child: CupertinoAlertDialog(
        title: TXTextWidget(
          text: title,
          fontWeight: FontWeight.bold,
        ),
        content: Container(
          margin: EdgeInsets.only(top: 10),
          child: contentWidget ?? TXTextWidget(
            text: content,
          ),
        ),
        actions: <Widget>[
          if (onCancel != null)
            CupertinoDialogAction(
              child: TXTextWidget(
                text: cancelText ?? R.string.cancel,
              ),
              onPressed: onCancel,
            ),
          CupertinoDialogAction(
            child: TXTextWidget(
              text: okText ?? R.string.ok,
            ),
            onPressed: onOK,
          ),
        ],
      ),
    );
  }
}
