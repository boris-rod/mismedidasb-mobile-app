import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_action_chip_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_combo_progress_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_network_image.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_progress_bar_checked_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_serie_progress_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/food/food_page.dart';
import 'package:mismedidasb/ui/food_dish/food_dish_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:mismedidasb/ui/food_dish/tx_daily_nutritional_info_widget.dart';
import 'package:mismedidasb/ui/food_dish/tx_dish_nutritional_info_widget.dart';
import 'package:mismedidasb/ui/food_dish/tx_ideal_pie_chart_food_widget.dart';
import 'package:mismedidasb/ui/food_dish/tx_instrucctions_widget.dart';
import 'package:mismedidasb/ui/home/home_page.dart';
import 'package:mp_chart/mp/chart/pie_chart.dart';

class FoodDishPage extends StatefulWidget {
  final bool fromNotificationScope;

  const FoodDishPage({Key key, this.fromNotificationScope = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _FoodDishState();
}

class _FoodDishState extends StateWithBloC<FoodDishPage, FoodDishBloC> {
  void _navBack() {
    if (widget.fromNotificationScope)
      NavigationUtils.pushReplacement(context, HomePage());
    else
      NavigationUtils.pop(context);
  }

  @override
  void initState() {
    super.initState();
    bloc.loadInitialData();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navBack();
        return false;
      },
      child: Stack(
        children: <Widget>[
          TXMainAppBarWidget(
            title: R.string.foodDishes,
            leading: TXIconButtonWidget(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                _navBack();
              },
            ),
            actions: <Widget>[
              TXIconButtonWidget(
                icon: Icon(
                  Icons.live_help,
                  color: Colors.yellow,
                ),
                onPressed: () {
                  showTXModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return TXInstructionsWidget();
                      });
                },
              )
            ],
            body: StreamBuilder<DailyFoodModel>(
              stream: bloc.dailyFoodResult,
              initialData: null,
              builder: (ctx, snapshot) {
                final dailyModel = snapshot.data;
                return dailyModel == null
                    ? Container()
                    : Column(
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                TXDailyNutritionalInfoWidget(
                                  currentCaloriesPercentage: bloc
                                      .getCurrentCaloriesPercentage(dailyModel),
                                  dailyModel: dailyModel,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  color: R.color.gray,
                                  height: .5,
                                  margin: EdgeInsets.only(top: 5),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: SingleChildScrollView(
                                    padding: EdgeInsets.only(
                                        top: 5, left: 5, right: 5, bottom: 50),
                                    child: Column(
                                      children: _getDailyActivityFood(context,
                                          snapshot.data.dailyActivityFoodModel),
                                    ),
                                    physics: BouncingScrollPhysics(),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
                                  child: TXButtonWidget(
                                      onPressed: () {
                                      },
                                      title: "Salvar"),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
              },
            ),
          ),
          TXLoadingWidget(
            loadingStream: bloc.isLoadingStream,
          )
        ],
      ),
    );
  }

  List<Widget> _getDailyActivityFood(
      BuildContext context, List<DailyActivityFoodModel> modelList) {
    List<Widget> list = [];
    modelList.forEach((model) {
      final w = Container(
        width: double.infinity,
        child: Card(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TXTextWidget(
                        text: "${model.name}",
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: R.color.primary_dark_color,
                        size: 16,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 160,
                      child: TXComboProgressBarWidget(
                        title: "",
                        percentage:
                            bloc.getCurrentCaloriesPercentageByFood(model),
                        mark1: bloc.getActivityFoodCalories(model) -
                            bloc.getActivityFoodCaloriesOffSet(model),
                        mark2: bloc.getActivityFoodCalories(model) +
                            bloc.getActivityFoodCaloriesOffSet(model),
                        height: 15,
                        value: model.calories,
                      ),
                    ),
                    TXIconButtonWidget(
                      onPressed: () async {
                        final resultList = await NavigationUtils.push(
                            context,
                            FoodPage(
                              selectedItems: model.foods,
                            ));
                        if (resultList is List<FoodModel>) {
                          model.foods = resultList;
                          bloc.setFoodList(model);
                        }
                      },
                      icon: Icon(
                        Icons.add,
                        color: R.color.primary_dark_color,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: R.color.gray,
                height: .5,
                margin: EdgeInsets.only(left: 10),
              ),
              (model.id != 2 && model.id != 4)
                  ? Container(
                      padding: EdgeInsets.only(left: 10, top: 5, right: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: TXDishNutritionalInfoWidget(model: model),
                          ),
                          TXIdealPieChartFoodWidget(model: model)
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              ..._getFoods(model, model.foods),
              SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      );
      list.add(w);
      if(model.id != 5)
      list.add(Container(
        height: 15,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Divider(
          color: R.color.primary_color,
        ),
      ));
    });
    return list;
  }

  List<Widget> _getFoods(DailyActivityFoodModel dailyActivityFoodModel,
      List<FoodModel> modelList) {
    List<Widget> list = [];
    modelList.forEach((model) {
      final w = ListTile(
        contentPadding: EdgeInsets.only(left: 10, right: 10),
        leading: TXNetworkImage(
          width: 40,
          height: 40,
          imageUrl: model.image,
          placeholderImage: R.image.logo_blue,
        ),
        title: Wrap(
          children: <Widget>[
            TXTextWidget(
              text: "${model.name}",
            ),
          ],
        ),
        trailing: TXIconButtonWidget(
          onPressed: () {
            modelList.remove(model);
            bloc.setFoodList(dailyActivityFoodModel);
          },
          icon: Icon(
            Icons.close,
            color: R.color.primary_color,
          ),
        ),
      );
      list.add(Container(
        width: double.infinity,
        height: .2,
        color: R.color.gray,
        margin: EdgeInsets.only(left: 10),
      ));
      list.add(w);
    });
    return list;
  }
}
