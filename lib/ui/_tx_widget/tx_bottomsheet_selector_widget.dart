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
      this.useDatePicker = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int index = list.firstWhere((ele) {
          return ele.id == initialId;
        }, orElse: () {
          return null;
        })?.index ??
        0;
    return Column(
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
            fontWeight: FontWeight.bold,
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
                  msg: R.string.emptyList, toastLength: Toast.LENGTH_SHORT);
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
    );

//      ListTile(
//      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//      trailing: Icon(
//        Icons.arrow_forward_ios,
//        size: 15,
//      ),
//      onTap: () {
//        if (list.isEmpty)
//          Fluttertoast.showToast(
//              msg: R.string.emptyList, toastLength: Toast.LENGTH_SHORT);
//        else
//          showTXModalBottomSheet(
//              context: context,
//              builder: (ctx) {
//                return TXCupertinoPickerWidget(
//                  height: bottomSheetHeight ?? 300,
//                  list: list,
//                  onItemSelected: onItemSelected,
//                  title: title,
//                  initialId: initialId,
//                );
//              });
//      },
//      title: Container(
//        child: TXTextWidget(
//          text: title,
//          textAlign: TextAlign.justify,
//        ),
//      ),
//      dense: true,
//      subtitle: Container(
//        child:
//
//        TXTextWidget(
//          text: list[index]?.displayName ?? "Vacio",
//          color: R.color.gray_darkest,
//          size: 20,
//        ),
//      ),
//    );
  }
}
