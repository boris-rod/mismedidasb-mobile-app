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

  const TXBottomResumeFoodPlanWidget(
      {Key key,
      this.dailyFoodModel,
      this.setShowDailyResume,
      this.onSaveConfirm,
      this.showValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4 * 3,
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
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 200,
                              color: R.color.accent_color,
                            ),
                            Container(
                              height: 200,
                              color: R.color.primary_color,
                            ),
                            Container(
                              height: 200,
                              color: R.color.accent_color,
                            ),
                            Container(
                              height: 200,
                              color: R.color.primary_color,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
