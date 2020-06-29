import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

Widget showSnackBar({String title = "", String content = ""}) {
  return SnackBar(
    backgroundColor: Colors.white,
    content: Container(
      constraints: BoxConstraints(maxHeight: 80),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Image.asset(
              R.image.logo,
              width: 60,
              height: 60,
            ),
          ),
          Expanded(
              child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TXTextWidget(
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  text: title,
                  fontWeight: FontWeight.bold,
                ),
                Expanded(
                  child: TXTextWidget(
                    maxLines: 3,
                    textOverflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    text: content,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    ),
  );
}

showAlertDialogForPollsAnswerResult(
    {BuildContext context, Function onOk, String title, String content}) {
  // set up the button
  Widget okButton = FlatButton(
    child: TXTextWidget(text: R.string.ok,),
    onPressed: onOk,
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    titlePadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    title: Row(
      children: <Widget>[
        Container(
          child: Image.asset(
            R.image.logo,
            width: 80,
            height: 80,
          ),
        ),
        Expanded(
          child: TXTextWidget(
            text: title,
          ),
        )
      ],
    ),
    content: TXTextWidget(
      text: content,
    ),
    actions: [okButton],
  );

  // show the dialog
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
