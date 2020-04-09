import 'package:flutter/material.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_combo_progress_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_progress_bar_checked_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXDailyNutritionalInfoWidget extends StatelessWidget {
  final DailyFoodModel dailyModel;
  final double currentCaloriesPercentage;

  const TXDailyNutritionalInfoWidget({Key key, this.dailyModel, this.currentCaloriesPercentage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TXTextWidget(
          text: "Ingesta de kilo-calorías por día.",
          size: 12,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: TXComboProgressBarWidget(
            title: "Calorías",
            titleSize: 10,
            percentage: currentCaloriesPercentage,
            mark1: dailyModel.dailyFoodPlanModel.kCalMin,
            mark2: dailyModel.dailyFoodPlanModel.kCalMax,
            value: dailyModel.currentCaloriesSum,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TXTextWidget(
          text: "Información nutricional",
          size: 12,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(
          height: 3,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: <Widget>[
              TXProgressBarCheckedWidget(
                title: "Proteínas",
                percentage: dailyModel.currentSumProteins *
                    100 /
                    (dailyModel.dailyFoodPlanModel.kCalMax * 25 / 100),
                color: Colors.grey[350],
                minMark: 12 * 100 / 25,
              ),
              SizedBox(
                height: 5,
              ),
              TXProgressBarCheckedWidget(
                title: "Carbohidratos",
                percentage: dailyModel.currentSumCarbohydrates *
                    100 /
                    (dailyModel.dailyFoodPlanModel.kCalMax * 55 / 100),
                color: Colors.grey[350],
                minMark: 35 * 100 / 55,
              ),
              SizedBox(
                height: 5,
              ),
              TXProgressBarCheckedWidget(
                title: "Grasas",
                percentage: dailyModel.currentSumFat *
                    100 /
                    (dailyModel.dailyFoodPlanModel.kCalMax * 35 / 100),
                color: Colors.grey[350],
                minMark: 20 * 100 / 35,
              ),
              SizedBox(
                height: 5,
              ),
              TXProgressBarCheckedWidget(
                title: "Fibras",
                percentage: dailyModel.currentSumFiber * 100 / 50,
                color: Colors.grey[350],
                minMark: 30 * 100 / 50,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
