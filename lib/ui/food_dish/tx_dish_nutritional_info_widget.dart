import 'package:flutter/material.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXDishNutritionalInfoWidget extends StatelessWidget{
  final DailyActivityFoodModel model;

  const TXDishNutritionalInfoWidget({Key key, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            CircleAvatar(
              radius: 9,
              backgroundColor:
              Colors.blueAccent[100],
              child: TXTextWidget(
                text:
                "",
                fontWeight: FontWeight.bold,
                color: Colors.white,
                size: 9,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            TXTextWidget(
              text: R.string.proteins,
            ),
          ],
        ),
        SizedBox(
          height: 6,
        ),
        Row(
          children: <Widget>[
            CircleAvatar(
              radius: 9,
              backgroundColor:
              Colors.blueAccent[200],
              child: TXTextWidget(
                text:
                "",
                fontWeight: FontWeight.bold,
                color: Colors.white,
                size: 9,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            TXTextWidget(
              text: R.string.carbohydrates,
            ),
          ],
        ),
        SizedBox(
          height: 6,
        ),
        Row(
          children: <Widget>[
            CircleAvatar(
              radius: 9,
              backgroundColor:
              Colors.blueAccent[700],
              child: TXTextWidget(
                text:
                "",
                fontWeight: FontWeight.bold,
                color: Colors.white,
                size: 9,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            TXTextWidget(
              text: R.string.fiberAndVegetables,
            ),
          ],
        ),
      ],
    );
  }

}