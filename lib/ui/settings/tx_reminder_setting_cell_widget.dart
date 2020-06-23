import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';

class TXReminderSettingCellWidget extends StatelessWidget {
  final String title;
  final DateTime time;
  final bool isActive;
  final ValueChanged<DateTime> onDateSelected;
  final Function onActiveTap;
  final DateTime minimumDate;
  final DateTime maximumDate;

  const TXReminderSettingCellWidget(
      {Key key,
      this.title,
      this.time,
      this.isActive,
      this.onDateSelected,
      this.onActiveTap,
      this.minimumDate,
      this.maximumDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentDateTime = time;
    return ListTile(
      contentPadding: EdgeInsets.only(right: 0, left: 10),
      onTap: isActive
          ? () {
              showTXModalBottomSheet(
                  context: context,
                  builder: (context) {
                    final now = DateTime.now();
                    return Container(
                      height: 200,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: TXTextWidget(
                                    text: title,
                                  ),
                                ),
                                TXTextLinkWidget(
                                  onTap: () {
                                    NavigationUtils.pop(context);
                                    onDateSelected(currentDateTime);
                                  },
                                  title: "OK",
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.time,
                              initialDateTime: time,
                              minimumDate: minimumDate,
                              maximumDate: maximumDate,
                              onDateTimeChanged: (datetime) {
                                currentDateTime = datetime;
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
          : null,
      title: TXTextWidget(
        text: title,
      ),
      subtitle: TXTextWidget(
        text:
            "${time.hour > 12 ? time.hour - 12 : time.hour}:${time.minute < 10 ? "0${time.minute}" : time.minute} ${time.hour > 12 ? "pm" : "am"}",
        textDecoration:
            isActive ? TextDecoration.none : TextDecoration.lineThrough,
        color: R.color.gray,
      ),
      trailing: TXIconButtonWidget(
        onPressed: onActiveTap,
        icon: Icon(
          isActive ? Icons.timer : Icons.timer_off,
          size: 25,
          color: R.color.accent_color,
        ),
      ),
    );
  }
}
