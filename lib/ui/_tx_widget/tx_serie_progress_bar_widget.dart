import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXSeriesProgressBarWidget extends StatelessWidget {
  final int value1;
  final int value2;
  final int value3;

  const TXSeriesProgressBarWidget(
      {Key key, this.value1, this.value2, this.value3})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
            height: 12,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: value1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red[400],
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(
                              (value3 <= 0 && value2 <= 0) ? 10 : 0),
                          bottomRight: Radius.circular(
                              (value3 <= 0 && value2 <= 0) ? 10 : 0)),
                    ),
                  ),
                ),
                Expanded(
                  flex: value2,
                  child: Container(
                      decoration: BoxDecoration(
                    color: Colors.blue[400],
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(value1 <= 0 ? 10 : 0),
                        topLeft: Radius.circular(value1 <= 0 ? 10 : 0),
                        topRight: Radius.circular(value3 <= 0 ? 10 : 0),
                        bottomRight: Radius.circular(value3 <= 0 ? 10 : 0)),
                  )),
                ),
                Expanded(
                  flex: value3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green[400],
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(
                              (value1 <= 0 && value2 <= 0) ? 10 : 0),
                          bottomLeft: Radius.circular(
                              (value1 <= 0 && value2 <= 0) ? 10 : 0)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 15,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.red[400],
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      TXTextWidget(
                        text: "$value1%",
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.blue[400],
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      TXTextWidget(
                        text: "$value2%",
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.green[400],
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      TXTextWidget(
                        text: "$value3%",
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
