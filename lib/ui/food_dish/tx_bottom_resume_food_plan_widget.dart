import 'package:flutter/material.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_checkbox_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_divider_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';

class TXBottomResumeFoodPlanWidget extends StatelessWidget {
  final DailyFoodModel dailyFoodModel;
  final ValueChanged<bool> setShowDailyResume;
  final Function onSaveConfirm;
  final bool showValue;
  final bool showConfirm;
  final bool showPlaniSuggest;

  const TXBottomResumeFoodPlanWidget(
      {Key key,
      this.dailyFoodModel,
      this.setShowDailyResume,
      this.onSaveConfirm,
      this.showValue,
      this.showConfirm = true,
      this.showPlaniSuggest = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 9 * 6,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.topLeft,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TXTextWidget(
                    text: R.string.resumePlan,
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                    size: 18,
                  ),
                ),
                Container(
                  child: TXTextLinkWidget(
                      title: R.string.cancel,
                      textColor: R.color.primary_color,
                      onTap: () {
                        NavigationUtils.pop(context);
                      }),
                )
              ],
            ),
            showPlaniSuggest ? _getPlaniSuggest() : Container(),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 20, bottom: 10),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (ctx, index) {
                          final activityModel =
                              dailyFoodModel.dailyActivityFoodModelList[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TXTextWidget(
                                text: activityModel.name,
                                fontWeight: FontWeight.bold,
                                size: 16,
                              ),
                              Container(
                                child: ListView.builder(
                                  itemBuilder: (ctx, indexFoods) {
                                    final foodModel =
                                        activityModel.foods[indexFoods];
                                    return Column(
                                      children: <Widget>[
                                        indexFoods > 0
                                            ? TXDividerWidget(
                                                height: .2,
                                              )
                                            : Container(),
                                        Container(
                                          padding: EdgeInsets.only(
                                              bottom: 5, top: 5),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: TXTextWidget(
                                                  text:
                                                      "${indexFoods + 1}- ${foodModel.name}",
                                                ),
                                              ),
                                              foodModel.count != 1
                                                  ? CircleAvatar(
                                                      backgroundColor:
                                                          R.color.accent_color,
                                                      child: TXTextWidget(
                                                        text:
                                                            "${foodModel.displayCount}",
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        size: 7,
                                                      ),
                                                      radius: 8,
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                  padding: EdgeInsets.only(left: 20),
                                  itemCount: activityModel.foods.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          );
                        },
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount:
                            dailyFoodModel.dailyActivityFoodModelList.length,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    showConfirm
                        ? Column(
                            children: <Widget>[
                              TXButtonWidget(
                                  onPressed: () {
                                    NavigationUtils.pop(context);
                                    onSaveConfirm();
                                  },
                                  mainColor: R.color.button_color,
                                  title: R.string.confirm),
                              TXCheckBoxWidget(
                                text: R.string.showAlways,
                                leading: true,
                                textColor: R.color.accent_color,
                                value: showValue,
                                onChange: (value) {
                                  setShowDailyResume(value);
                                },
                              ),
                              Container(
                                height: .5,
                                color: R.color.gray,
                                width: double.infinity,
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getPlaniSuggest() {
    double proteinPer = dailyFoodModel.currentProteinsSum *
        100 /
        (dailyFoodModel.dailyFoodPlanModel.kCalMax * 25 / 100);
    int proteins = proteinPer <= 100 && proteinPer > (12 * 100 / 25)
        ? 0
        : proteinPer > 100 ? 1 : -1;

    double carbohydratesPer = dailyFoodModel.currentCarbohydratesSum *
        100 /
        (dailyFoodModel.dailyFoodPlanModel.kCalMax * 55 / 100);
    int carbohydrates =
        carbohydratesPer <= 100 && carbohydratesPer > 35 * 100 / 55
            ? 0
            : carbohydratesPer > 100 ? 1 : -1;

    double fatPer = dailyFoodModel.currentFatSum *
        100 /
        (dailyFoodModel.dailyFoodPlanModel.kCalMax * 35 / 100);
    int fat =
        fatPer <= 100 && fatPer > 20 * 100 / 35 ? 0 : fatPer > 100 ? 1 : -1;

    double fiberPer = dailyFoodModel.currentFiberSum * 100 / 50;
    int fiber = fiberPer <= 100 && fiberPer > 30 * 100 / 50
        ? 0
        : fiberPer > 100 ? 1 : -1;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          R.image.plani,
          width: 60,
          height: 60,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TXTextWidget(
                size: 12,
                color: proteins != 0 ? Colors.redAccent : Colors.green,
                fontWeight: FontWeight.bold,
                text: proteins < 0
                    ? "Debes incluir más Proteínas."
                    : proteins > 0
                        ? "Deberias reducir la cantidad de Proteínas."
                        : "La cantidad de Proteínas es adecuada.",
              ),
              SizedBox(
                height: 2,
              ),
              TXTextWidget(
                size: 12,
                color: carbohydrates != 0 ? Colors.redAccent : Colors.green,
                fontWeight: FontWeight.bold,
                text: carbohydrates < 0
                    ? "Debes incluir más Carbohidratos."
                    : carbohydrates > 0
                        ? "Deberias reducir la cantidad de Carbohidratos."
                        : "La cantidad de Carbohidratos es adecuada.",
              ),
              SizedBox(
                height: 2,
              ),
              TXTextWidget(
                size: 12,
                color: fat != 0 ? Colors.redAccent : Colors.green,
                fontWeight: FontWeight.bold,
                text: fat < 0
                    ? "Debes incluir más Grasa."
                    : fat > 0
                        ? "Deberias reducir la cantidad de Grasa."
                        : "La cantidad de Grasa es adecuada.",
              ),
              SizedBox(
                height: 2,
              ),
              TXTextWidget(
                size: 12,
                color: fiber != 0 ? Colors.redAccent : Colors.green,
                fontWeight: FontWeight.bold,
                text: fiber < 0
                    ? "Debes incluir más Fibra."
                    : fiber > 0
                        ? "Deberias reducir la cantidad de Fibra."
                        : "La cantidad de Fibra es adecuada.",
              )
            ],
          ),
        )
      ],
    );
  }
}
