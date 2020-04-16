import 'package:flutter/material.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_checkbox_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';

class TXBottomResumeFoodPlanWidget extends StatelessWidget {
  final DailyFoodModel dailyFoodModel;
  final ValueChanged<bool> setShowDailyResume;
  final Function onSaveConfirm;
  final bool showValue;
  final bool showConfirm;

  const TXBottomResumeFoodPlanWidget(
      {Key key,
      this.dailyFoodModel,
      this.setShowDailyResume,
      this.onSaveConfirm,
      this.showValue,
      this.showConfirm = true})
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
                    text: "Resumen",
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                    size: 18,
                  ),
                ),
                Container(
                  child: TXTextLinkWidget(
                      title: "Cerrar",
                      textColor: R.color.primary_color,
                      onTap: () {
                        NavigationUtils.pop(context);
                      }),
                )
              ],
            ),
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
                                    return Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: TXTextWidget(
                                        text: "${indexFoods + 1}- ${foodModel.name}",
                                      ),
                                    );
                                  },
                                  padding: EdgeInsets.only(left: 20),
                                  itemCount: activityModel.foods.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                ),
                              ),
                              SizedBox(height: 20,)
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
                                  title: R.string.confirm),
                              TXCheckBoxWidget(
                                text: R.string.notShowAgain,
                                leading: true,
                                textColor: R.color.accent_color,
                                value: showValue,
                                onChange: (value) {
                                  setShowDailyResume(value);
                                },
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
}
