import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

import '../../enums.dart';

class TXFoodHealthyFilterWidget extends StatelessWidget {
  final ValueChanged<int> onFilterTapped;

  const TXFoodHealthyFilterWidget({Key key, this.onFilterTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            children: <Widget>[
              TXIconButtonWidget(
                icon: Icon(Icons.filter_list, color: R.color.gray_darkest,),
                onPressed: () {
                  onFilterTapped(FoodHealthy.fruitVeg.index);
                },
              ),
              TXTextWidget(
                text: "Frutas y/o Vegetales",
                color: Colors.black,
                size: 12,
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: <Widget>[
              TXIconButtonWidget(
                icon: Icon(Icons.filter_list, color: R.color.gray_darkest),
                onPressed: () {
                  onFilterTapped(FoodHealthy.proteic.index);
                },
              ),
              TXTextWidget(
                text: "Protéico",
                color: Colors.black,
                size: 12,
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: <Widget>[
              TXIconButtonWidget(
                icon: Icon(Icons.filter_list, color: R.color.gray_darkest),
                onPressed: () {
                  onFilterTapped(FoodHealthy.caloric.index);
                },
              ),
              TXTextWidget(
                text: "Calórico",
                color: Colors.black,
                size: 12,
              )
            ],
          ),
        ),
      ],
    );
  }
}
