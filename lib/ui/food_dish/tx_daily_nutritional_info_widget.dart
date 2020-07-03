import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_combo_progress_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_progress_bar_checked_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/utils/calendar_utils.dart';

class TXDailyNutritionalInfoWidget extends StatelessWidget {
  final DailyFoodModel dailyModel;
  final double currentCaloriesPercentage;
  final Function onHeaderTap;
  final double imc;

  const TXDailyNutritionalInfoWidget(
      {Key key,
      this.dailyModel,
      this.currentCaloriesPercentage,
      this.onHeaderTap,
      this.imc = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double caloriesSum = dailyModel.currentCaloriesSum;
    final double proteinSum = dailyModel.currentProteinsSum;
    final double fatSum = dailyModel.currentFatSum;
    final double carbohydratesSum = dailyModel.currentCarbohydratesSum;
    final double fibberSum = dailyModel.currentFiberSum;
    final double kCalMax = dailyModel.dailyFoodPlanModel.kCalMax;
    return Container(
      padding: EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: onHeaderTap,
            child: Container(
              height: 40,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: 16,
                    margin: EdgeInsets.only(left: 15),
                    padding: EdgeInsets.only(left: 20, right: 5),
                    color: R.color.food_nutri_info,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TXTextWidget(
                            text: R.string.nutritionalInfo,
                            size: 11,
                            textAlign: TextAlign.start,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TXTextWidget(
                          text: CalendarUtils.showInFormat(
                              "d/M/yyyy", dailyModel.dateTime),
                          size: 11,
                          color: Colors.black,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.bold,
                        )
                      ],
                    ),
                  ),
                  Image.asset(
                    R.image.down_arrow_icon,
                    height: 35,
                    width: 35,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 5,
          ),
          dailyModel.headerExpanded
              ? Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: TXComboProgressBarWidget(
                        imc: imc,
                        title: R.string.calories,
                        titleSize: 10,
                        height: 20,
                        backgroundProgress: R.color.food_blue_light,
                        showPercentageInfo: dailyModel.showKCalPercentages,
                        percentage: currentCaloriesPercentage,
                        mark1: dailyModel.dailyFoodPlanModel.kCalMin,
                        mark2: kCalMax,
                        value: caloriesSum,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ).copyWith(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TXProgressBarCheckedWidget(
                            title: R.string.proteins,
                            showPercentage: dailyModel.showKCalPercentages,
                            percentage: proteinSum * 100 / (kCalMax * 25 / 100),
                            color: Colors.grey[350],
                            minMark: 12 * 100 / 25,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TXProgressBarCheckedWidget(
                            title: R.string.carbohydrates,
                            showPercentage: dailyModel.showKCalPercentages,
                            percentage:
                                carbohydratesSum * 100 / (kCalMax * 55 / 100),
                            color: Colors.grey[350],
                            minMark: 35 * 100 / 55,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TXProgressBarCheckedWidget(
                            title: R.string.fat,
                            showPercentage: dailyModel.showKCalPercentages,
                            percentage: fatSum * 100 / (kCalMax * 35 / 100),
                            color: Colors.grey[350],
                            minMark: 20 * 100 / 35,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TXProgressBarCheckedWidget(
                            title: R.string.fiber,
                            showPercentage: dailyModel.showKCalPercentages,
                            percentage: fibberSum * 100 / 50,
                            color: Colors.grey[350],
                            minMark: 30 * 100 / 50,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
