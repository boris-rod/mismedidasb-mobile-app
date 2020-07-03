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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            children: <Widget>[
              TXIconButtonWidget(
                icon: Image.asset(
                  R.image.down_arrow_icon,
                  height: 30,
                  width: 30,
                ),
                onPressed: () {
                  onFilterTapped(FoodHealthy.fruitVeg.index);
                },
              ),
              SizedBox(height: 3,),
              TXTextWidget(
                text: "Frutas/Vegetales",
                color: Colors.white,
                size: 10,
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: <Widget>[
              TXIconButtonWidget(
                icon: Image.asset(
                  R.image.down_arrow_icon,
                  height: 30,
                  width: 30,
                ),
                onPressed: () {
                  onFilterTapped(FoodHealthy.proteic.index);
                },
              ),
              SizedBox(height: 3,),
              TXTextWidget(
                text: "Protéico",
                color: Colors.white,
                size: 10,
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: <Widget>[
              TXIconButtonWidget(
                icon: Image.asset(
                  R.image.down_arrow_icon,
                  height: 30,
                  width: 30,
                ),
                onPressed: () {
                  onFilterTapped(FoodHealthy.caloric.index);
                },
              ),
              SizedBox(height: 3,),
              TXTextWidget(
                text: "Calórico",
                color: Colors.white,
                size: 10,
              )
            ],
          ),
        ),
      ],
    );
  }
}
