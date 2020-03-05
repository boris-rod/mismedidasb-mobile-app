import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_action_chip_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_network_image.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/food/food_page.dart';
import 'package:mismedidasb/ui/food_dish/food_dish_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class FoodDishPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FoodDishState();
}

class SubscriberSeries {
  final String year;
  final int subscribers;
  final charts.Color barColor;

  SubscriberSeries(
      {@required this.year,
      @required this.subscribers,
      @required this.barColor});
}

class _FoodDishState extends StateWithBloC<FoodDishPage, FoodDishBloC> {
  @override
  void initState() {
    super.initState();
    bloc.loadInitialData();
  }

  @override
  Widget buildWidget(BuildContext context) {
    final List<SubscriberSeries> data = [
//      SubscriberSeries(
//        year: "1",
//        subscribers: 2,
//        barColor: charts.ColorUtil.fromDartColor(Colors.blue),
//      ),
      SubscriberSeries(
        year: "2",
        subscribers: 12,
        barColor: charts.ColorUtil.fromDartColor(R.color.accent_color),
      ),
      SubscriberSeries(
        year: "2",
        subscribers: 4,
        barColor: charts.ColorUtil.fromDartColor(R.color.primary_color),
      ),
    ];

    List<charts.Series<SubscriberSeries, String>> series = [
      charts.Series(
          id: "Subscribers",
          data: data,
          displayName: "Pie",
          domainFn: (SubscriberSeries series, _) => series.year,
          measureFn: (SubscriberSeries series, _) => series.subscribers,
          colorFn: (SubscriberSeries series, _) => series.barColor)
    ];

    charts.SeriesLegend();
    return Stack(
      children: <Widget>[
        TXMainAppBarWidget(
          title: R.string.foodDishes,
          leading: TXIconButtonWidget(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              NavigationUtils.pop(context);
            },
          ),
          body: StreamBuilder<DailyFoodModel>(
            stream: bloc.dailyFoodResult,
            initialData: null,
            builder: (ctx, snapshot) {
              final dailyModel = snapshot.data;
              return dailyModel == null
                  ? Container()
                  : SingleChildScrollView(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TXTextWidget(
                            text: dailyModel.dailyFoodPlanModel.kCalStr,
                          ),
                          TXTextWidget(
                            text: dailyModel.dailyFoodPlanModel.kCalRange,
                          ),
                          TXTextWidget(
                            text: dailyModel.dailyFoodPlanModel.imcStr,
                          ),

                          Container(
                            padding: EdgeInsets.all(1),
                            height: 100,
                            width: 100,
                            child: charts.PieChart(
                              series,
                              layoutConfig: LayoutConfig(
                                  topMarginSpec: MarginSpec.fixedPixel(0),
                                  leftMarginSpec: MarginSpec.fixedPixel(0),
                                  rightMarginSpec: MarginSpec.fixedPixel(0),
                                  bottomMarginSpec: MarginSpec.fixedPixel(0)),
                              animate: true,
                            ),
                          ),
                          Column(
                            children: _getDailyActivityFood(
                                context, snapshot.data.dailyActivityFoodModel),
                          )
                        ],
                      ),
                    );
            },
          ),
        ),
        TXLoadingWidget(
          loadingStream: bloc.isLoadingStream,
        )
      ],
    );
  }

  List<Widget> _getDailyActivityFood(
      BuildContext context, List<DailyActivityFoodModel> modelList) {
    List<Widget> list = [];
    int pos = 1;
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
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          TXTextWidget(
                            text: "${model.name}",
                            fontWeight: FontWeight.bold,
                            color: R.color.primary_dark_color,
                            size: 16,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          TXTextWidget(
                            text:
                                "${pos == 1 ? model.plan.breakfastCalStr : (pos == 2 ? model.plan.snack1CalStr : (pos == 3 ? model.plan.lunchCalStr : (pos == 4 ? model.plan.snack2CalStr : model.plan.dinnerCalStr)))}",
                            color: Colors.black,
                            size: 16,
                          )
                        ],
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
                          model.isExpanded = resultList.isNotEmpty;
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Wrap(
                  spacing: 3,
                  runSpacing: 0,
                  alignment: WrapAlignment.start,
                  children: <Widget>[..._getChips(model)],
                ),
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  ..._getFoods(model, model.foods),
                  SizedBox(
                    height: 5,
                  )
                ],
              ),
//              Container(
//                padding: EdgeInsets.only(right: 10),
//                child: Align(
//                  alignment: Alignment.centerRight,
//                  child: TXIconButtonWidget(
//                    onPressed: () async {
//                      final resultList = await NavigationUtils.push(
//                          context,
//                          FoodPage(
//                            selectedItems: model.foods,
//                          ));
//                      if (resultList is List<FoodModel>) {
//                        model.isExpanded = resultList.isNotEmpty;
//                        model.foods = resultList;
//                        bloc.setFoodList(model);
//                      }
//                    },
//                    icon: Icon(
//                      Icons.add,
//                      color: R.color.primary_dark_color,
//                    ),
//                  ),
//                ),
//              )
            ],
          ),
        ),
      );
      list.add(w);
      pos += 1;
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

  List<Widget> _getChips(DailyActivityFoodModel model) {
    List<Widget> resultList = [];

    if (model.calories > 0) {
      final cal = Chip(
        label: TXTextWidget(
          size: 10,
          color: Colors.black,
          text: "Calorías: ${model.calories.toStringAsFixed(2)}",
        ),
      );
      resultList.add(cal);
    }

    if (model.carbohydrates > 0) {
      final car = Chip(
        label: TXTextWidget(
          size: 10,
          color: Colors.black,
          text: "Carbohidratos: ${model.carbohydrates.toStringAsFixed(2)}",
        ),
      );
      resultList.add(car);
    }

    if (model.proteins > 0) {
      final pro = Chip(
        label: TXTextWidget(
          size: 10,
          color: Colors.black,
          text: "Proteinas: ${model.proteins.toStringAsFixed(2)}",
        ),
      );
      resultList.add(pro);
    }

    if (model.fat > 0) {
      final fat = Chip(
        label: TXTextWidget(
          size: 10,
          color: Colors.black,
          text: "Grasas: ${model.fat.toStringAsFixed(2)}",
        ),
      );
      resultList.add(fat);
    }

    if (model.fiber > 0) {
      final fib = Chip(
        label: TXTextWidget(
          size: 10,
          color: Colors.black,
          text: "Fibras ${model.fiber.toStringAsFixed(2)}",
        ),
      );
      resultList.add(fib);
    }

    return resultList;
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
          placeholderImage: R.image.logo,
        ),
        title: TXTextWidget(
          text: model.name,
        ),
        trailing: TXIconButtonWidget(
          onPressed: () {
            modelList.remove(model);
            dailyActivityFoodModel.isExpanded = modelList.isNotEmpty;
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

  void _showFoodList(BuildContext context, List<FoodModel> list) {
    showTXModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            height: MediaQuery.of(context).size.height - 100,
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 50,
                ),
                Container(
                  height: .5,
                  color: R.color.gray,
                ),
                Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final food = list[index];
                      return Container(
                        child: ListTile(
                          onTap: () {},
                          leading: TXNetworkImage(
                            width: 60,
                            height: 60,
                            imageUrl: food.image,
                            placeholderImage: R.image.logo,
                          ),
                          title: TXTextWidget(
                            text: food.name,
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        });
  }
}
