import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

enum FOOD_MENU_OPTIONS {
  YESTERDAY,
  DAYS_2,
  DAYS_3,
  DAYS_4,
  DAYS_5,
  DAYS_6,
  WEEK,
  INSTRUCTIONS,
  CLOSE
}

class TXFoodMenuActionWidget extends StatefulWidget {
  final FOOD_MENU_OPTIONS itemSelected;

  const TXFoodMenuActionWidget({Key key, this.itemSelected}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TXFoodMenuActionState();
}

class _TXFoodMenuActionState extends State<TXFoodMenuActionWidget> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.calendar_today,
        color: Colors.white,
      ),
      itemBuilder: (ctx) {
        return _getActions();
      },
    );
  }

  List<PopupMenuItem> _getActions() {
    List<PopupMenuItem> list = [];
    list.add(
      PopupMenuItem(
        value: FOOD_MENU_OPTIONS.YESTERDAY,
        child: TXTextWidget(
          text: "Ayer",
          color: Colors.black,
          fontWeight: widget.itemSelected == FOOD_MENU_OPTIONS.YESTERDAY
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
    );
    list.add(
      PopupMenuItem(
        value: FOOD_MENU_OPTIONS.DAYS_2,
        child: TXTextWidget(
          text: "2 días",
          color: Colors.black,
          fontWeight: widget.itemSelected == FOOD_MENU_OPTIONS.DAYS_2
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
    );
    list.add(
      PopupMenuItem(
        value: FOOD_MENU_OPTIONS.DAYS_3,
        child: TXTextWidget(
          text: "3 días",
          color: Colors.black,
          fontWeight: widget.itemSelected == FOOD_MENU_OPTIONS.DAYS_3
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
    );
    list.add(PopupMenuItem(
      value: FOOD_MENU_OPTIONS.DAYS_4,
      child: TXTextWidget(
        text: "4 días",
        color: Colors.black,
        fontWeight: widget.itemSelected == FOOD_MENU_OPTIONS.DAYS_4
            ? FontWeight.bold
            : FontWeight.normal,
      ),
    ));
    list.add(PopupMenuItem(
      value: FOOD_MENU_OPTIONS.DAYS_5,
      child: TXTextWidget(
        text: "5 días",
        color: Colors.black,
        fontWeight: widget.itemSelected == FOOD_MENU_OPTIONS.DAYS_5
            ? FontWeight.bold
            : FontWeight.normal,
      ),
    ));
    list.add(PopupMenuItem(
      value: FOOD_MENU_OPTIONS.DAYS_6,
      child: TXTextWidget(
        text: "6 días",
        color: Colors.black,
        fontWeight: widget.itemSelected == FOOD_MENU_OPTIONS.DAYS_6
            ? FontWeight.bold
            : FontWeight.normal,
      ),
    ));
    list.add(PopupMenuItem(
      value: FOOD_MENU_OPTIONS.WEEK,
      child: TXTextWidget(
        text: "Una semana",
        color: Colors.black,
        fontWeight: widget.itemSelected == FOOD_MENU_OPTIONS.WEEK
            ? FontWeight.bold
            : FontWeight.normal,
      ),
    ));
    list.add(PopupMenuItem(
      height: .5,
      value: null,
      child: Container(
        color: R.color.gray_darkest,
        width: double.infinity,
        height: .5,
      ),
    ));
    list.add(PopupMenuItem(
      value: FOOD_MENU_OPTIONS.CLOSE,
      child: TXTextWidget(
        text: "cancelar",
        color: Colors.black,
      ),
    ));
    return list;
  }
}
