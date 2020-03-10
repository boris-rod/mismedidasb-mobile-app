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
import 'package:mismedidasb/ui/_tx_widget/tx_combo_progress_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_network_image.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/food/food_page.dart';
import 'package:mismedidasb/ui/food_dish/food_dish_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:mp_chart/mp/chart/pie_chart.dart';

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
  List<charts.Series<SubscriberSeries, String>> series = [];
  List<charts.Series<SubscriberSeries, String>> series1 = [];

  @override
  void initState() {
    super.initState();
    bloc.loadInitialData();
  }

  @override
  Widget buildWidget(BuildContext context) {
    final List<SubscriberSeries> data = [
      SubscriberSeries(
        year: "1",
        subscribers: 2,
        barColor: charts.ColorUtil.fromDartColor(Colors.red[400]),
      ),
      SubscriberSeries(
        year: "2",
        subscribers: 4,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue[400]),
      ),
      SubscriberSeries(
        year: "3",
        subscribers: 4,
        barColor: charts.ColorUtil.fromDartColor(Colors.green[400]),
      ),
    ];
    final List<SubscriberSeries> data1 = [
      SubscriberSeries(
        year: "1",
        subscribers: 2,
        barColor: charts.ColorUtil.fromDartColor(Colors.red[400]),
      ),
      SubscriberSeries(
        year: "2",
        subscribers: 3,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue[400]),
      ),
      SubscriberSeries(
        year: "3",
        subscribers: 5,
        barColor: charts.ColorUtil.fromDartColor(Colors.green[400]),
      ),
    ];

    series = [
      charts.Series(
          id: "Subscribers",
          data: data,
          displayName: "Pie",
          domainFn: (SubscriberSeries series, _) => series.year,
          measureFn: (SubscriberSeries series, _) => series.subscribers,
          colorFn: (SubscriberSeries series, _) => series.barColor)
    ];

    series1 = [
      charts.Series(
          id: "Subscribers",
          data: data1,
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
          actions: <Widget>[
            TXIconButtonWidget(
              icon: Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              onPressed: () {
                showTXModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                      text: "Instrucciones",
                                      maxLines: 2,
                                      textOverflow: TextOverflow.ellipsis,
                                      size: 18,
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    child: TXTextLinkWidget(
                                      title: R.string.ok,
                                      textColor: R.color.primary_color,
                                      onTap: () {
                                        NavigationUtils.pop(context);
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: TXTextWidget(
                                    size: 16,
                                    textAlign: TextAlign.justify,
                                    text: R.string.foodsInstructions,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
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
                  : Stack(
                      children: <Widget>[
                        SingleChildScrollView(
                          padding: EdgeInsets.only(top: 100, left: 5, right: 5),
                          child: Column(
                            children: _getDailyActivityFood(
                                context, snapshot.data.dailyActivityFoodModel),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
//                              TXTextWidget(
//                                text: dailyModel.dailyFoodPlanModel.kCalStr,
//                              ),
//                              TXTextWidget(
//                                text: dailyModel.dailyFoodPlanModel.kCalRange,
//                              ),
//                              TXTextWidget(
//                                text: dailyModel.dailyFoodPlanModel.imcStr,
//                              ),
//                              SizedBox(
//                                height: 5,
//                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                                child: TXComboProgressBarWidget(
//                                  showValueInBar: true,
                                  title: "Calorías",
                                  titleSize: 12,
                                  percentage: bloc
                                      .getCurrentCaloriesPercentage(dailyModel),
                                  mark1: dailyModel.dailyFoodPlanModel.kCalMin,
                                  mark2: dailyModel.dailyFoodPlanModel.kCalMax,
                                  value: dailyModel.currentCaloriesSum,
                                ),
                              ),
                              Container(
                                color: R.color.gray,
                                height: .5,
                                margin: EdgeInsets.only(top: 5),
                              )
                            ],
                          ),
                          height: 105,
                          color: Colors.white,
                        )
                      ],
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
                      child: TXTextWidget(
                        text: "${model.name}",
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: R.color.primary_dark_color,
                        size: 16,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 5,
                        ),
//                        TXTextWidget(
//                          size: 8,
//                          text:
//                              "+-${bloc.getActivityFoodCaloriesOffSet(model).toStringAsFixed(2)}",
//                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 150,
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
                padding: EdgeInsets.only(left: 10, top: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    (model.id != 2 && model.id != 4)
                        ? Column(
                            children: <Widget>[
                              TXTextWidget(
                                text: "Ideal",
                                size: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              Container(
                                padding: EdgeInsets.all(1),
                                height: 80,
                                width: 80,
                                child: charts.PieChart(
                                  model.id == 5 ? series1 : series,
                                  layoutConfig: LayoutConfig(
                                      topMarginSpec: MarginSpec.fixedPixel(0),
                                      leftMarginSpec: MarginSpec.fixedPixel(0),
                                      rightMarginSpec: MarginSpec.fixedPixel(0),
                                      bottomMarginSpec:
                                          MarginSpec.fixedPixel(0)),
                                  animate: true,
                                ),
                              )
                            ],
                          )
                        : Container(),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Wrap(
                          spacing: 3,
                          runSpacing: 0,
                          alignment: WrapAlignment.start,
                          children: <Widget>[..._getChips(model)],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  (model.id == -1)
                      ? Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2),
                                      child: Column(
                                        children: <Widget>[
                                          TXComboProgressBarWidget(
                                            titleSize: 9,
                                            height: 14,
                                            percentage: 30,
                                            title: "",
                                            mark1: 50,
                                            mark2: 70,
                                            value: 80,
                                          ),
                                          TXTextWidget(
                                            text: "Vegetales",
                                            maxLines: 1,
                                            size: 10,
                                            textOverflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2),
                                      child: Column(
                                        children: <Widget>[
                                          TXComboProgressBarWidget(
                                            titleSize: 9,
                                            height: 14,
                                            percentage: 30,
                                            title: "",
                                            mark1: 50,
                                            mark2: 70,
                                            value: 80,
                                          ),
                                          TXTextWidget(
                                            text: "Carbohidratos",
                                            size: 10,
                                            maxLines: 1,
                                            textOverflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2),
                                      child: Column(
                                        children: <Widget>[
                                          TXComboProgressBarWidget(
                                            titleSize: 9,
                                            height: 14,
                                            percentage: 30,
                                            title: "",
                                            mark1: 50,
                                            mark2: 70,
                                            value: 80,
                                          ),
                                          TXTextWidget(
                                            text: "Proteínas",
                                            size: 10,
                                            maxLines: 1,
                                            textOverflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
        labelPadding: EdgeInsets.all(0),
        label: TXTextWidget(
          size: 9,
          color: Colors.black,
          text: "Calorías: ${model.calories.toStringAsFixed(2)}",
        ),
      );
      resultList.add(cal);
    }

    if (model.carbohydrates > 0) {
      final car = Chip(
        label: TXTextWidget(
          size: 9,
          color: Colors.black,
          text: "Carbohidratos: ${model.carbohydrates.toStringAsFixed(2)}",
        ),
      );
      resultList.add(car);
    }

    if (model.proteins > 0) {
      final pro = Chip(
        label: TXTextWidget(
          size: 9,
          color: Colors.black,
          text: "Proteinas: ${model.proteins.toStringAsFixed(2)}",
        ),
      );
      resultList.add(pro);
    }

    if (model.fat > 0) {
      final fat = Chip(
        label: TXTextWidget(
          size: 9,
          color: Colors.black,
          text: "Grasas: ${model.fat.toStringAsFixed(2)}",
        ),
      );
      resultList.add(fat);
    }

    if (model.fiber > 0) {
      final fib = Chip(
        label: TXTextWidget(
          size: 9,
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
          text: "${model.name} ${model.calories.toStringAsFixed(2)}kCal",
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
