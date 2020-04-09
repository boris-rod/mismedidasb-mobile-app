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
import 'package:mismedidasb/ui/_tx_widget/tx_progress_bar_checked_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_serie_progress_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/food/food_page.dart';
import 'package:mismedidasb/ui/food_dish/food_dish_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:mismedidasb/ui/home/home_page.dart';
import 'package:mp_chart/mp/chart/pie_chart.dart';

class FoodDishPage extends StatefulWidget {
  final bool fromNotificationScope;

  const FoodDishPage(
      {Key key, this.fromNotificationScope = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _FoodDishState();
}

class SubscriberSeries {
  final String nutritionKey;
  final int partialValue;
  final charts.Color barColor;

  SubscriberSeries(
      {@required this.nutritionKey,
      @required this.partialValue,
      @required this.barColor});
}

class _FoodDishState extends StateWithBloC<FoodDishPage, FoodDishBloC> {
  List<charts.Series<SubscriberSeries, String>> series = [];
  List<charts.Series<SubscriberSeries, String>> series1 = [];

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
    final List<SubscriberSeries> data = [
      SubscriberSeries(
        nutritionKey: "1",
        partialValue: 2,
        barColor: charts.ColorUtil.fromDartColor(Colors.blueAccent[100]),
      ),
      SubscriberSeries(
        nutritionKey: "2",
        partialValue: 4,
        barColor: charts.ColorUtil.fromDartColor(Colors.blueAccent[200]),
      ),
      SubscriberSeries(
        nutritionKey: "3",
        partialValue: 4,
        barColor: charts.ColorUtil.fromDartColor(Colors.blueAccent[700]),
      ),
    ];
    final List<SubscriberSeries> data1 = [
      SubscriberSeries(
        nutritionKey: "1",
        partialValue: 3,
        barColor: charts.ColorUtil.fromDartColor(Colors.blueAccent[100]),
      ),
      SubscriberSeries(
        nutritionKey: "2",
        partialValue: 2,
        barColor: charts.ColorUtil.fromDartColor(Colors.blueAccent[200]),
      ),
      SubscriberSeries(
        nutritionKey: "3",
        partialValue: 5,
        barColor: charts.ColorUtil.fromDartColor(Colors.blueAccent[700]),
      ),
    ];

    series = [
      charts.Series(
          id: "Subscribers",
          data: data,
          displayName: "Pie",
          domainFn: (SubscriberSeries series, _) => series.nutritionKey,
          measureFn: (SubscriberSeries series, _) => series.partialValue,
          colorFn: (SubscriberSeries series, _) => series.barColor)
    ];

    series1 = [
      charts.Series(
          id: "Subscribers",
          data: data1,
          displayName: "Pie",
          domainFn: (SubscriberSeries series, _) => series.nutritionKey,
          measureFn: (SubscriberSeries series, _) => series.partialValue,
          colorFn: (SubscriberSeries series, _) => series.barColor)
    ];

    charts.SeriesLegend();
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
                        return Container(
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.topLeft,
                          child: SingleChildScrollView(
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
                                Container(
                                  padding: EdgeInsets.only(left: 10, right: 20),
                                  child: Center(
                                    child: TXTextWidget(
                                        textAlign: TextAlign.justify,
                                        text: R.string.foodsInstructions),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TXTextWidget(
                                  textAlign: TextAlign.center,
                                  text: R.string.appClinicalWarning,
                                  size: 10,
                                  color: R.color.accent_color,
                                ),
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
                                TXTextWidget(
                                  text: "Ingesta de kilo-calorías por día.",
                                  size: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: TXComboProgressBarWidget(
//                                  showValueInBar: true,
                                    title: "Calorías",
                                    titleSize: 10,
                                    percentage:
                                        bloc.getCurrentCaloriesPercentage(
                                            dailyModel),
                                    mark1:
                                        dailyModel.dailyFoodPlanModel.kCalMin,
                                    mark2:
                                        dailyModel.dailyFoodPlanModel.kCalMax,
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
                                        percentage:
                                            dailyModel.currentSumProteins *
                                                100 /
                                                (dailyModel.dailyFoodPlanModel
                                                        .kCalMax *
                                                    25 /
                                                    100),
                                        color: Colors.grey[350],
                                        minMark: 12 * 100 / 25,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TXProgressBarCheckedWidget(
                                        title: "Carbohidratos",
                                        percentage:
                                            dailyModel.currentSumCarbohydrates *
                                                100 /
                                                (dailyModel.dailyFoodPlanModel
                                                        .kCalMax *
                                                    55 /
                                                    100),
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
                                            (dailyModel.dailyFoodPlanModel
                                                    .kCalMax *
                                                35 /
                                                100),
                                        color: Colors.grey[350],
                                        minMark: 20 * 100 / 35,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TXProgressBarCheckedWidget(
                                        title: "Fibras",
                                        percentage: dailyModel.currentSumFiber *
                                            100 /
                                            50,
                                        color: Colors.grey[350],
                                        minMark: 30 * 100 / 50,
                                      ),
                                    ],
                                  ),
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
                              Container(
                                padding: EdgeInsets.all(1),
                                height: 70,
                                width: 70,
                                child: Stack(
                                  children: <Widget>[
                                    charts.PieChart(
                                      model.id == 5 ? series1 : series,
                                      layoutConfig: LayoutConfig(
                                          topMarginSpec:
                                              MarginSpec.fixedPixel(0),
                                          leftMarginSpec:
                                              MarginSpec.fixedPixel(0),
                                          rightMarginSpec:
                                              MarginSpec.fixedPixel(0),
                                          bottomMarginSpec:
                                              MarginSpec.fixedPixel(0)),
                                      animate: true,
                                    ),
                                    Positioned(
                                      top: 25,
                                      left: 10,
                                      child: TXTextWidget(
                                        text: model.id == 5 ? "50%" : "40%",
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    ),
                                    Positioned(
                                      top: model.id == 5 ? 20 : 12,
                                      right: 12,
                                      child: TXTextWidget(
                                        text: model.id == 5 ? "30%" : "20%",
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    ),
                                    Positioned(
                                      right: 12,
                                      bottom: model.id == 5 ? 10 : 20,
                                      child: TXTextWidget(
                                        text: model.id == 5 ? "20%" : "40%",
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              TXTextWidget(
                                text: "Ideal",
                                size: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          )
                        : Container(),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: (model.id != 2 && model.id != 4)
                          ? Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
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
                                                  "${model.foodsProteinsPercentage}",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              size: 9,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          TXTextWidget(
                                            text: "Proteínas",
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 9,
                                            backgroundColor:
                                                Colors.blueAccent[200],
                                            child: TXTextWidget(
                                              text:
                                                  "${model.foodsCarbohydratesPercentage}",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              size: 9,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          TXTextWidget(
                                            text: "Carbohidratos",
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 9,
                                            backgroundColor:
                                                Colors.blueAccent[700],
                                            child: TXTextWidget(
                                              text:
                                                  "${model.foodsFiberPercentage}",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              size: 9,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          TXTextWidget(
                                            text: "Frutas y/o Vegetales",
                                          ),
                                        ],
                                      ),
//                                      SizedBox(
//                                        height: 5,
//                                      ),
//                                      Container(
//                                        margin:
//                                            EdgeInsets.only(right: 20, top: 5),
//                                        child: TXSeriesProgressBarWidget(
//                                          value1: model.foodsProteinsPercentage,
//                                          value2: model
//                                              .foodsCarbohydratesPercentage,
//                                          value3: model.foodsFiberPercentage,
//                                        ),
//                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          : Container(),
                    )
                  ],
                ),
              ),
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
//            TXTextWidget(
//              size: 9,
//              color: Colors.black,
//              text:
//                  "${model.calories.toStringAsFixed(2)}kCal-${model.carbohydrates.toStringAsFixed(2)}Car-"
//                  "${model.fat.toStringAsFixed(2)}Fat- ${model.fiber.toStringAsFixed(2)}Fib-"
//                  "${model.proteins.toStringAsFixed(2)}Pro",
//            ),
          ],
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
}
