import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_combo_progress_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_progress_bar_checked_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/utils/calendar_utils.dart';

class TXDailyNutritionalInfoWidget extends StatelessWidget {
  final DailyFoodModel dailyModel;
  final double currentCaloriesPercentage;
  final Function onHeaderTap;

  const TXDailyNutritionalInfoWidget(
      {Key key,
      this.dailyModel,
      this.currentCaloriesPercentage,
      this.onHeaderTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          dailyModel.headerExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 28,
                        ),
                        TXTextWidget(
                          text: R.string.nutritionalInfo,
                          size: 12,
                          textAlign: TextAlign.start,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(left: 5),
                  ),
                  onTap: onHeaderTap,
                ),
              ),
              TXTextWidget(
                text: CalendarUtils.showInFormat("dd/MMM", dailyModel.dateTime),
                size: 14,
                color: R.color.primary_dark_color,
                textAlign: TextAlign.start,
                fontWeight: FontWeight.bold,
              )
            ],
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
                        title: R.string.calories,
                        titleSize: 10,
                        showPercentageInfo: dailyModel.showKCalPercentages,
                        percentage: currentCaloriesPercentage,
                        mark1: dailyModel.dailyFoodPlanModel.kCalMin,
                        mark2: dailyModel.dailyFoodPlanModel.kCalMax,
                        value: dailyModel.currentCaloriesSum,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TXProgressBarCheckedWidget(
                            title: R.string.proteins,
                            showPercentage: dailyModel.showKCalPercentages,
                            percentage: dailyModel.currentSumProteins *
                                100 /
                                (dailyModel.dailyFoodPlanModel.kCalMax *
                                    25 /
                                    100),
                            color: Colors.grey[350],
                            minMark: 12 * 100 / 25,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TXProgressBarCheckedWidget(
                            title: R.string.carbohydrates,
                            showPercentage: dailyModel.showKCalPercentages,
                            percentage: dailyModel.currentSumCarbohydrates *
                                100 /
                                (dailyModel.dailyFoodPlanModel.kCalMax *
                                    55 /
                                    100),
                            color: Colors.grey[350],
                            minMark: 35 * 100 / 55,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TXProgressBarCheckedWidget(
                            title: R.string.fat,
                            showPercentage: dailyModel.showKCalPercentages,
                            percentage: dailyModel.currentSumFat *
                                100 /
                                (dailyModel.dailyFoodPlanModel.kCalMax *
                                    35 /
                                    100),
                            color: Colors.grey[350],
                            minMark: 20 * 100 / 35,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TXProgressBarCheckedWidget(
                            title: R.string.fiber,
                            showPercentage: dailyModel.showKCalPercentages,
                            percentage: dailyModel.currentSumFiber * 100 / 50,
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
