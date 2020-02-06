import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showTXModalBottomSheet({
  @required BuildContext context,
  @required WidgetBuilder builder,
}) {
  showCupertinoModalPopup(
    context: context,
    builder: (b) => Container(
      color: Colors.white,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 100),
      child: Material(child: builder(context)),
    ),
  );
}

//void showPVCModalBottomSheet(
//    {@required BuildContext context,
//    List<SingleSelectionModel> list = const [],
//    TextAlign textAlign = TextAlign.center,
//    ValueChanged<SingleSelectionModel> onItemSelect}) {
//  showCupertinoModalPopup(
//    context: context,
//    builder: (b) {
//      return Material(
//        child: SingleChildScrollView(
//            child: Column(
//          children: _conformItemList(list, onItemSelect, textAlign),
//        )),
//      );
//    },
//  );
//}
//
//List<Widget> _conformItemList(List<SingleSelectionModel> list,
//    ValueChanged<SingleSelectionModel> onItemSelect, TextAlign textAlign) {
//  List<Widget> resultList = [];
//
//  list.forEach((model) {
//    final w = InkWell(
//      onTap: () {
//        if (onItemSelect != null) onItemSelect(model);
//      },
//      child: Column(
//        children: <Widget>[
//          Container(
//            color: AppColor.gray_dark,
//            height: model.cancelAction ? .5 : 0,
//          ),
//          Container(
//            padding: EdgeInsets.symmetric(horizontal: 15),
//            height: R.dim.bottomOptionH,
//            child: Row(
//              children: <Widget>[
//                Expanded(
//                  child: P2BText(
//                    model.value,
//                    textOverFlow: TextOverflow.ellipsis,
//                    textAlign: textAlign,
//                    textColor: model.textColor,
//                  ),
//                )
//              ],
//            ),
//          )
//        ],
//      ),
//    );
//    resultList.add(w);
//  });
//
//  return resultList;
//}
