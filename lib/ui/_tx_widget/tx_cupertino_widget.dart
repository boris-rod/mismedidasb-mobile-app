import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mismedidasb/domain/single_selection_model.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:sqflite/utils/utils.dart';

class TXCupertinoPickerWidget extends StatelessWidget {
  final double height;
  final List<SingleSelectionModel> list;
  final ValueChanged<SingleSelectionModel> onItemSelected;
  final String title;
  final int initialId;

  const TXCupertinoPickerWidget(
      {Key key,
      this.height,
      this.list,
      this.onItemSelected,
      this.title,
      this.initialId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int index = list.firstWhere((ele) {
      return ele.id == initialId;
    }, orElse: () {
      return null;
    })?.index;

    return Container(
      height: height,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 10, top: 10),
            alignment: Alignment.topLeft,
            child: TXTextWidget(
              text: title ?? "",
              size: 18,
            ),
          ),
          Expanded(
            child: CupertinoPicker(
              scrollController:
                  FixedExtentScrollController(initialItem: index ?? 0),
              itemExtent: 30,
              backgroundColor: Colors.white,
              onSelectedItemChanged: (int index) {
                if (onItemSelected != null) onItemSelected(list[index]);
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
