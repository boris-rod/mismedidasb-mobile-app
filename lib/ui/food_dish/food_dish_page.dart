import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/res/values/config.dart';
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
import 'package:mismedidasb/ui/food_dish/tx_bottom_resume_food_plan_widget.dart';
import 'package:mismedidasb/ui/food_dish/tx_daily_nutritional_info_widget.dart';
import 'package:mismedidasb/ui/food_dish/tx_dish_nutritional_info_widget.dart';
import 'package:mismedidasb/ui/food_dish/tx_food_menu_action_widget.dart';
import 'package:mismedidasb/ui/food_dish/tx_ideal_pie_chart_food_widget.dart';
import 'package:mismedidasb/ui/food_dish/tx_instrucctions_widget.dart';
import 'package:mismedidasb/ui/home/home_page.dart';
import 'package:mismedidasb/utils/calendar_utils.dart';
import 'package:mp_chart/mp/chart/pie_chart.dart';
import 'package:table_calendar/table_calendar.dart';

class FoodDishPage extends StatefulWidget {
  final bool fromNotificationScope;

  const FoodDishPage({Key key, this.fromNotificationScope = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _FoodDishState();
}

class _FoodDishState extends StateWithBloC<FoodDishPage, FoodDishBloC> {
  PageController _pageController = PageController();
  CalendarController _calendarController = CalendarController();

  void _navBack() {
    if (widget.fromNotificationScope)
      NavigationUtils.pushReplacement(context, HomePage());
    else
      NavigationUtils.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    bloc.pageResult.listen((onData) {
      _pageController.animateToPage(onData,
          duration: Duration(milliseconds: 300), curve: Curves.linear);
    });
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
              icon: Icon(Icons.close),
              onPressed: () {
                _navBack();
              },
            ),
            actions: <Widget>[
              TXIconButtonWidget(
                icon: Icon(
                  Icons.live_help,
//                  color: Colors.yellow,
                ),
                onPressed: () {
                  showTXModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return TXInstructionsWidget();
                      });
                },
              ),
              StreamBuilder<int>(
                stream: bloc.pageResult,
                initialData: 0,
                builder: (ctx, snapshot) {
                  return TXIconButtonWidget(
                    icon: Icon(
                      snapshot.data == 0
                          ? Icons.calendar_today
                          : Icons.mode_edit,
//                  color: Colors.yellow,
                    ),
                    onPressed: () {
                      bloc.changePage(bloc.currentPage == 0 ? 1 : 0);
                    },
                  );
                },
              ),
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
                                  onHeaderTap: () {
                                    setState(() {
                                      dailyModel.headerExpanded =
                                          !dailyModel.headerExpanded;
                                    });
                                  },
                                ),
                                Container(
                                  color: R.color.gray,
                                  height: .5,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: PageView.builder(
                                      itemBuilder: (ctx, index) {
                                        return index == 0
                                            ? _getListModeView(
                                                context,
                                                snapshot.data
                                                    .dailyActivityFoodModelList)
                                            : _getCalendarView(context, []);
                                      },
                                      itemCount: 2,
                                      physics: NeverScrollableScrollPhysics(),
                                      controller: _pageController,
                                    ),
                                    color: R.color.gray_light,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 50),
                                  child: TXButtonWidget(
                                      onPressed: () {
                                        if (dailyModel.hasFoods == null)
                                          Fluttertoast.showToast(
                                              msg: R.string.emptyFoodList);
                                        else {
                                          if (bloc.showResume)
                                            showTXModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return _showResume(context, dailyModel);
                                                });
                                          else
                                            bloc.saveDailyPlan();
                                        }
                                      },
                                      title: R.string.save),
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

  Widget _showResume(BuildContext context, DailyFoodModel dailyModel){
    return StreamBuilder<bool>(
      stream:
      bloc.showResumeResult,
      initialData: true,
      builder:
          (ctx, showSnapshot) {
        return TXBottomResumeFoodPlanWidget(
          dailyFoodModel:
          dailyModel,
          showValue:
          showSnapshot.data,
          setShowDailyResume:
              (value) {
            bloc.setShowDailyResume(
                value);
          },
          onSaveConfirm: () {
            bloc.saveDailyPlan();
          },
        );
      },
    );
  }

  Widget _getListModeView(
      BuildContext context, List<DailyActivityFoodModel> modelList) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 50),
      child: Column(
        children: _getDailyActivityFood(context, modelList),
      ),
      physics: BouncingScrollPhysics(),
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
                padding: EdgeInsets.only(left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              model.isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 28,
                              color: R.color.primary_dark_color,
                            ),
                            TXTextWidget(
                              text: "${model.name}",
                              maxLines: 1,
                              textOverflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              color: R.color.primary_dark_color,
                              size: 15,
                            )
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            model.isExpanded = !model.isExpanded;
                          });
                        },
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
              model.isExpanded
                  ? Column(
                      children: <Widget>[
                        (model.id != 1 && model.id != 3)
                            ? Container(
                                padding: EdgeInsets.only(
                                    left: 10, top: 5, right: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: TXDishNutritionalInfoWidget(
                                          model: model),
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
                    )
                  : Container()
            ],
          ),
        ),
      );
      list.add(w);
      if (model.id != 4)
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

  Widget _getCalendarView(
      BuildContext context, List<DailyFoodModel> modelList) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (){},
          ),
          TableCalendar(
            availableGestures: AvailableGestures.none,
            locale: AppConfig.locale == AppLocale.EN
                ? 'en_US'
                : AppConfig.locale == AppLocale.IT ? 'it_IT' : 'es_ES',
            calendarController: _calendarController,
            startDay: bloc.firstDate,
            endDay: bloc.lastDate,
            onDaySelected: (datetime, events) {
              bloc.selectedDate = datetime;

              bloc.loadInitialDailyData();
            },
            enabledDayPredicate: (datetime){
              return CalendarUtils.compare(datetime, bloc.firstDateHealthResult) >= 0;
            },
            initialSelectedDay: bloc.selectedDate,
            events: bloc.dailyFoodModelMap,
            initialCalendarFormat: CalendarFormat.month,
            availableCalendarFormats: Map.of({CalendarFormat.month: ""}),
            headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                rightChevronIcon: Icon(
                  Icons.keyboard_arrow_right,
                  size: 30,
                  color: R.color.primary_color,
                ),
                leftChevronIcon: Icon(
                  Icons.keyboard_arrow_left,
                  size: 30,
                  color: R.color.primary_color,
                )),
            builders: CalendarBuilders(
              markersBuilder: (context, date, events, holidays) {
                final children = <Widget>[];
                if (events.isNotEmpty) {
                  children.add(
                    _buildEventsMarker(date, events),
                  );
                }
                return children;
              },
              selectedDayBuilder: (context, date, events) {
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: CircleAvatar(
                            backgroundColor: Colors.blueAccent[100],
                            radius: 12,
                          ),
                        ),
                        Center(
                          child: TXTextWidget(
                            text: "${date.day}",
                            color: Colors.white,
                            size: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              todayDayBuilder: (context, date, events) {
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: CircleAvatar(
                            backgroundColor: R.color.gray_dark,
                            radius: 12,
                          ),
                        ),
                        Center(
                          child: TXTextWidget(
                            text: "${date.day}",
                            size: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Wrap(children: <Widget>[
            TXTextLinkWidget(title: "Planificar", onTap: (){}, textColor: R.color.accent_color,),
            TXTextLinkWidget(title: "Copiar", onTap: (){}, textColor: R.color.accent_color,),
            TXTextLinkWidget(title: "Editar", onTap: (){}, textColor: R.color.accent_color,),
            TXTextLinkWidget(title: "Ver resumen", onTap: (){}, textColor: R.color.accent_color,),
          ],)
        ],
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    final DailyFoodModel dailyModel =
        events.isNotEmpty ? events[0] as DailyFoodModel : null;
    return (dailyModel != null && dailyModel.hasFoods != null)
        ? Align(
            alignment: Alignment.bottomCenter,
            child: Icon(
              dailyModel.currentCaloriesSum >
                      dailyModel.dailyFoodPlanModel.kCalMax
                  ? Icons.add_circle_outline
                  : dailyModel.currentCaloriesSum >
                          dailyModel.dailyFoodPlanModel.kCalMin
                      ? Icons.check_circle_outline
                      : Icons.remove_circle_outline,
              size: 14,
              color: dailyModel.currentCaloriesSum >
                      dailyModel.dailyFoodPlanModel.kCalMax
                  ? Colors.red[400]
                  : dailyModel.currentCaloriesSum >
                          dailyModel.dailyFoodPlanModel.kCalMin
                      ? Colors.green[400]
                      : Colors.yellow[400],
            ),
          )
        : Container();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: bloc.selectedDate,
        firstDate: bloc.firstDate,
        lastDate: bloc.lastDate,
        selectableDayPredicate: (date) {
          return true;
        });
    if (picked != null && picked != bloc.selectedDate) {}
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }
}
