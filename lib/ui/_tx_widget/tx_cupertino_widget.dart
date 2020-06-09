import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mismedidasb/domain/single_selection_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:sqflite/utils/utils.dart';

class TXCupertinoPickerWidget extends StatelessWidget {
  final double height;
  final List<SingleSelectionModel> list;
  final ValueChanged<SingleSelectionModel> onItemSelected;
  final String title;
  final int initialId;
  final bool useDatePicker;

  const TXCupertinoPickerWidget(
      {Key key,
      this.height,
      this.list,
      this.onItemSelected,
      this.title,
      this.initialId,
      this.useDatePicker = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();

    int index = list.firstWhere((ele) {
          return ele.id == initialId;
        }, orElse: () {
          return null;
        })?.index ??
        0;
    SingleSelectionModel current = list[index];
    return Container(
      height: height,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10),
            alignment: Alignment.topLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TXTextWidget(
                    text: title ?? "",
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
                      if (onItemSelected != null) onItemSelected(current);
                      NavigationUtils.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: useDatePicker
                ? CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime:
                        DateTime(now.year - 18, now.month, now.day),
                    minimumDate:
                        DateTime(now.year - list.length, now.month, now.day),
                    maximumDate: DateTime(now.year - 18, now.month, now.day),
                    onDateTimeChanged: (DateTime newDateTime) {
                      int age = now.year - newDateTime.year;
                      current = list[age - 1];
                      var newTod = TimeOfDay.fromDateTime(newDateTime);
//                  _updateTimeFunction(newTod);
                    },
                    use24hFormat: false,
                  )
                : CupertinoPicker(
                    scrollController:
                        FixedExtentScrollController(initialItem: index ?? 0),
                    itemExtent: 30,
                    backgroundColor: Colors.white,
                    onSelectedItemChanged: (int index) {
                      current = list[index];
                    },
                    children: List<Widget>.generate(list.length, (int index) {
                      return Center(
                        child: TXTextWidget(
                          text: list[index].displayName,
                          color: Colors.black,
                        ),
                      );
                    }),
                  ),
          ),
        ],
      ),
    );
  }
}
