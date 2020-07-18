import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/domain/single_selection_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_box_cell_data_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXBottomSheetSelectorWidget extends StatelessWidget {
  final List<SingleSelectionModel> list;
  final String title;
  final FontWeight titleFont;
  final int initialId;
  final ValueChanged<SingleSelectionModel> onItemSelected;
  final double bottomSheetHeight;
  final double boxAnswerWidth;
  final bool useDatePicker;

  const TXBottomSheetSelectorWidget(
      {Key key,
      this.list,
      this.title,
      this.initialId,
      this.onItemSelected,
      this.bottomSheetHeight = 300,
      this.boxAnswerWidth,
      this.useDatePicker = false, this.titleFont})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int index = list.firstWhere((ele) {
          return ele.id == initialId;
        }, orElse: () {
          return null;
        })?.index ??
        0;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            child: TXTextWidget(
              text: title,
              color: Colors.white,
              fontWeight: titleFont ?? FontWeight.bold,
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TXBoxCellDataWidget(
            width: boxAnswerWidth,
            value: list[index]?.displayName ?? "",
            onTap: () {
              if (list.isEmpty)
                Fluttertoast.showToast(
                    msg: R.string.emptyList, toastLength: Toast.LENGTH_SHORT,
                    backgroundColor: R.color.gray,
                    textColor: Colors.white);
              else
                showTXModalBottomSheet(
                    context: context,
                    builder: (ctx) {
                      return TXCupertinoPickerWidget(
                        height: bottomSheetHeight ?? 300,
                        list: list,
                        onItemSelected: onItemSelected,
                        title: title,
                        useDatePicker: useDatePicker,
                        initialId: initialId,
                      );
                    });
            },
          )
        ],
      ),
    );
  }
}
