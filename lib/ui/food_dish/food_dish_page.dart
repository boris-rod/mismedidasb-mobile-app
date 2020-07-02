import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/res/values/config.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_checkbox_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_combo_progress_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_dialog_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_divider_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_navigator_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_network_image.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/food/food_page.dart';
import 'package:mismedidasb/ui/food_dish/food_dish_bloc.dart';
import 'package:mismedidasb/ui/food_dish/tx_bottom_resume_food_plan_widget.dart';
import 'package:mismedidasb/ui/food_dish/tx_daily_nutritional_info_widget.dart';
import 'package:mismedidasb/ui/food_dish/tx_dish_nutritional_info_widget.dart';
import 'package:mismedidasb/ui/food_dish/tx_food_healthy_filter_widget.dart';
import 'package:mismedidasb/ui/food_dish/tx_ideal_pie_chart_food_widget.dart';
import 'package:mismedidasb/ui/food_dish/tx_instrucctions_widget.dart';
import 'package:mismedidasb/ui/home/home_page.dart';
import 'package:mismedidasb/utils/calendar_utils.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mismedidasb/utils/extensions.dart';

import '../../enums.dart';

class FoodDishPage extends StatefulWidget {
  final bool fromNotificationScope;
  final String instructions;

  const FoodDishPage(
      {Key key, this.fromNotificationScope = false, this.instructions})
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

  void _showDialogConfirmCopyPlan({BuildContext context, Function onOkAction}) {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => TXCupertinoDialogWidget(
        title: R.string.warningTitle,
        content: R.string.warningReplacePlanContent,
        onOK: () {
          Navigator.pop(context, R.string.ok);
          onOkAction();
        },
        onCancel: () {
          Navigator.pop(context, R.string.cancel);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    bloc.pageResult.listen((onData) {
      _pageController.animateToPage(onData,
          duration: Duration(milliseconds: 300), curve: Curves.linear);
    });

    bloc.copyPlanResult.listen((onData) {
      if (onData is DateTime) {
        _showDialogConfirmCopyPlan(
            context: context,
            onOkAction: () {
              bloc.copyPlan(true, onData);
            });
      }
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
            backgroundColorAppBar: R.color.food_action_bar,
            titleFont: FontWeight.w300,
            title: R.string.foodDishes,
            leading: Container(
              margin: EdgeInsets.only(left: 10),
              child: TXIconNavigatorWidget(
                onTap: () {
                  _navBack();
                },
              ),
            ),
            actions: <Widget>[
              StreamBuilder<int>(
                stream: bloc.pageResult,
                initialData: 0,
                builder: (ctx, snapshot) {
                  return TXIconButtonWidget(
                    icon: Icon(
                      snapshot.data == 0
                          ? Icons.calendar_today
                          : Icons.mode_edit,
                      color: R.color.food_nutri_info,
//                  color: Colors.yellow,
                    ),
                    onPressed: () {
                      _pageController.animateToPage(snapshot.data == 0 ? 1 : 0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.linear);
                      bloc.changePage(bloc.currentPage == 0 ? 1 : 0);
                    },
                  );
                },
              ),
              StreamBuilder(
                stream: bloc.kCalPercentageHideResult,
                initialData: false,
                builder: (ctx, snapshot) {
                  return PopupMenuButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: R.color.food_nutri_info,
                      ),
                      itemBuilder: (ctx) {
                        return [..._popupActions(snapshot.data)];
                      },
                      onSelected: (key) async {
                        if (key == PopupActionKey.show_kcal_percentage) {
                          bloc.changeKCalPercentageHide(!snapshot.data);
                        } else if (key ==
                            PopupActionKey.daily_plan_instructions) {
                          showTXModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return TXInstructionsWidget(
                                  instructions: widget.instructions,
                                );
                              });
                        }
                      });
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
                    : Container(
                        color: R.color.food_background,
                        child: StreamBuilder<bool>(
                          stream: bloc.kCalPercentageHideResult,
                          initialData: false,
                          builder: (ctx, snapshotHidPercentages) {
                            dailyModel.showKCalPercentages =
                                snapshotHidPercentages.data;
                            return Column(
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10,
                                      ),
                                      StreamBuilder(
                                        stream: bloc.nutriInfoHeaderResult,
                                        initialData: false,
                                        builder:
                                            (ctx, snapshotNutriInfoHeader) {
                                          dailyModel.headerExpanded =
                                              snapshotNutriInfoHeader.data;
                                          return TXDailyNutritionalInfoWidget(
                                            imc: bloc.imc,
                                            currentCaloriesPercentage: bloc
                                                .getCurrentCaloriesPercentage(
                                                    dailyModel),
                                            dailyModel: dailyModel,
                                            onHeaderTap: () {
                                              dailyModel.headerExpanded =
                                                  !dailyModel.headerExpanded;
                                              bloc.changeNutriInfoHeader(
                                                  dailyModel.headerExpanded);
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: PageView.builder(
                                      itemBuilder: (ctx, index) {
                                        return index == 0
                                            ? _getListModeView(
                                                context,
                                                snapshot.data
                                                    .dailyActivityFoodModelList,
                                                dailyModel)
                                            : _getCalendarView(context, []);
                                      },
                                      itemCount: 2,
                                      controller: _pageController,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
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

  List<PopupMenuItem> _popupActions(bool showKCalPer) {
    List<PopupMenuItem> list = [];
    final showKCalPercentage = PopupMenuItem(
      value: PopupActionKey.show_kcal_percentage,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              showKCalPer ? Icons.check_box : Icons.check_box_outline_blank,
              size: 20,
              color: R.color.primary_color,
            ),
            SizedBox(
              width: 10,
            ),
            TXTextWidget(
              text: R.string.showBarPercentages,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
    final instrctions = PopupMenuItem(
      value: PopupActionKey.daily_plan_instructions,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.live_help,
              size: 20,
              color: R.color.primary_color,
            ),
            SizedBox(
              width: 10,
            ),
            TXTextWidget(
              text: R.string.foodInstructionsTitle,
              color: Colors.black,
            )
          ],
        ),
      ),
    );

    list.add(showKCalPercentage);
    list.add(instrctions);
    return list;
  }

  Widget _showResume(BuildContext context, DailyFoodModel dailyModel,
      {bool showConfirm = true}) {
    return StreamBuilder<bool>(
      stream: bloc.showResumeResult,
      initialData: bloc.showResume,
      builder: (ctx, showSnapshot) {
        return TXBottomResumeFoodPlanWidget(
          dailyFoodModel: dailyModel,
          showValue: showSnapshot.data,
          showConfirm: showConfirm,
          setShowDailyResume: (value) {
            bloc.showResume = value;
            bloc.setShowDailyResume(value);
          },
          onSaveConfirm: () {
            bloc.saveDailyPlan();
          },
        );
      },
    );
  }

  Widget _getListModeView(BuildContext context,
      List<DailyActivityFoodModel> modelList, DailyFoodModel dailyModel) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 50),
            child: Column(
              children: <Widget>[
                ..._getDailyActivityFood(
                    context, modelList, dailyModel.showKCalPercentages),
              ],
//        children: _getDailyActivityFood(context, modelList),
            ),
            physics: BouncingScrollPhysics(),
          ),
        ),
        dailyModel.synced
            ? Container()
            : Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
                child: TXButtonWidget(
                    onPressed: () {
                      if (dailyModel.hasFoods == null)
                        Fluttertoast.showToast(msg: R.string.emptyFoodList);
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
    );
  }

  List<Widget> _getDailyActivityFood(BuildContext context,
      List<DailyActivityFoodModel> modelList, bool showKCalPercentage) {
    List<Widget> list = [];
    modelList.forEach((model) {
      final w = Card(
        shape: Border.all(style: BorderStyle.none),
        elevation: 0,
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              model.isExpanded
                                  ? R.image.up_arrow_icon
                                  : R.image.down_arrow_icon,
                              height: 35,
                              width: 35,
                            ),
//                          Icon(
//                            model.isExpanded
//                                ? Icons.keyboard_arrow_up
//                                : Icons.keyboard_arrow_down,
//                            size: 28,
//                            color: R.color.primary_dark_color,
//                          ),
                            SizedBox(
                              width: 5,
                            ),
                            TXTextWidget(
                              text: "${model.name}",
                              maxLines: 1,
                              textOverflow: TextOverflow.ellipsis,
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
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
                        imc: bloc.imc,
                        title: "",
                        showPercentageInfo: showKCalPercentage,
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
                    SizedBox(width: 10,),
                    TXIconButtonWidget(
                      onPressed: () async {
                        final resultList = await NavigationUtils.push(
                            context,
                            FoodPage(
                              dailyActivityFoodModel: model,
                              selectedItems: model.foods,
                              imc: bloc.imc,
                            ));
                        if (resultList is List<FoodModel>) {
                          model.foods = resultList;
                          bloc.setFoodList(model);
                        }
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
              Image.asset(R.image.divider_icon),
              model.isExpanded
                  ? Column(
                      children: <Widget>[
                        (model.id != 1 && model.id != 3)
                            ? Container(
                                padding: EdgeInsets.only(
                                    left: 10, top: 10, right: 10),
                                child: TXFoodHealthyFilterWidget(
                                  onFilterTapped: (index) async {
                                    final resultList =
                                        await NavigationUtils.push(
                                            context,
                                            FoodPage(
                                              dailyActivityFoodModel: model,
                                              selectedItems: model.foods,
                                              imc: bloc.imc,
                                              foodFilterMode:
                                                  FoodFilterMode.dish_healthy,
                                              foodFilterCategoryIndex: index,
                                            ));
                                    if (resultList is List<FoodModel>) {
                                      model.foods = resultList;
                                      bloc.setFoodList(model);
                                    }
                                  },
                                )

//                                Row(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: <Widget>[
//                                    Expanded(
//                                      child: TXDishNutritionalInfoWidget(
//                                          model: model),
//                                    ),
//                                    TXIdealPieChartFoodWidget(model: model)
//                                  ],
//                                ),
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
        color: R.color.food_blue_medium,
      );
      list.add(w);
//      if (model.id != 4)
//        list.add(Container(
//          height: 15,
//          margin: EdgeInsets.symmetric(horizontal: 5),
//          child: Divider(
//            color: R.color.primary_color,
//          ),
//        ));
    });
    return list;
  }

  List<Widget> _getFoods(DailyActivityFoodModel dailyActivityFoodModel,
      List<FoodModel> modelList) {
    List<Widget> list = [];
    modelList.forEach((model) {
      final w = ListTile(
        contentPadding: EdgeInsets.only(left: 5, right: 0),
        leading: Stack(
          children: <Widget>[
            TXNetworkImage(
              width: 40,
              height: 40,
              imageUrl: model.image,
              placeholderImage: R.image.logo,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: model.count != 1
                  ? CircleAvatar(
                      backgroundColor: R.color.accent_color,
                      child: TXTextWidget(
                        text: "${model.displayCount}",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        size: 7,
                      ),
                      radius: 8,
                    )
                  : Container(),
            )
          ],
        ),
        title: TXTextWidget(
          text: "${model.name}",
          color: Colors.white,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w300,
        ),
        trailing: TXIconButtonWidget(
          onPressed: () {
            modelList.remove(model);
            bloc.setFoodList(dailyActivityFoodModel);
          },
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 30,
          ),
        ),
      );
      list.add(Image.asset(R.image.divider_icon));
      list.add(w);
    });
    return list;
  }

  Widget _getCalendarView(
      BuildContext context, List<DailyFoodModel> modelList) {
    if (bloc.isCopying) {
      _calendarController.setSelectedDay(bloc.selectedDate);
      bloc.isCopying = false;
    }
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[
//          Container(
//            padding: EdgeInsets.symmetric(
//              horizontal: 15,
//            ).copyWith(top: 5),
//            child: StreamBuilder<int>(
//              stream: bloc.calendarPageResult,
//              initialData: 0,
//              builder: (ctx, snapshot) {
//                return Row(
//                  children: <Widget>[
//                    Container(
//                      width: 50,
//                      child: RaisedButton(
//                        color: R.color.primary_color,
//                        child: Icon(
//                          Icons.keyboard_arrow_left,
//                          size: 20,
//                          color: Colors.white,
//                        ),
//                        onPressed: () {
//                        },
//                        shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(45)),
//                      ),
//                    ),
//                    Expanded(
//                      child: TXTextWidget(
//                        text: CalendarUtils.showInFormat(
//                            "m/yyyy", bloc.selectedDate),
//                      ),
//                    ),
//                    Container(
//                      width: 50,
//                      child: RaisedButton(
//                        color: R.color.primary_color,
//                        child: Icon(
//                          Icons.keyboard_arrow_right,
//                          size: 20,
//                          color: Colors.white,
//                        ),
//                        onPressed: () {},
//                        shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(45)),
//                      ),
//                    ),
//                  ],
//                );
//              },
//            ),
//          ),
          TableCalendar(
            availableGestures: AvailableGestures.none,
            locale: AppConfig.locale == AppLocale.EN
                ? 'en_US'
                : AppConfig.locale == AppLocale.IT ? 'it_IT' : 'es_ES',
            calendarController: _calendarController,
            startDay: bloc.firstDate,
            endDay: bloc.lastDate,
            onDaySelected: (datetime, events) {
              if (CalendarUtils.compare(datetime, bloc.selectedDate) != 0) {
                bloc.selectedDate = datetime;
                bloc.loadDailyPlanData();
              }
            },
            enabledDayPredicate: (datetime) {
              return CalendarUtils.compare(
                      datetime, bloc.firstDateHealthResult) >=
                  0;
            },
            initialSelectedDay: bloc.selectedDate,
            events: bloc.getEvents(),
            initialCalendarFormat: CalendarFormat.month,
            availableCalendarFormats: Map.of({CalendarFormat.month: ""}),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
            ),
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
              dowWeekendBuilder: (context, str) {
                return TXTextWidget(
                  text: str.toCapitalize().substring(0, str.length - 1),
                  textAlign: TextAlign.center,
                );
              },
              dowWeekdayBuilder: (context, str) {
                return TXTextWidget(
                  text: str.toCapitalize().substring(0, str.length - 1),
                  textAlign: TextAlign.center,
                );
              },
              dayBuilder: (context, date, events) {
                bool isValidDay = (CalendarUtils.compare(
                            date,
                            (CalendarUtils.compare(bloc.firstDate,
                                        bloc.firstDateHealthResult) >
                                    0
                                ? bloc.firstDate
                                : bloc.firstDateHealthResult)) >=
                        0 &&
                    CalendarUtils.compare(date, bloc.lastDate) <= 0);
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Center(
                    child: TXTextWidget(
                      text: "${date.day}",
                      color: isValidDay ? Colors.black : R.color.gray,
                      size: isValidDay ? 14 : 11,
                    ),
                  ),
                );
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
                            size: 14,
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
                            size: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          StreamBuilder<DailyFoodModel>(
              stream: bloc.calendarOptionsResult,
              initialData: null,
              builder: (context, snapshot) {
                return snapshot.data == null
                    ? Container()
                    : Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.spaceBetween,
                        children: <Widget>[
                          TXTextLinkWidget(
                            title: R.string.copyPlan,
                            onTap: snapshot.data.hasFoods != null
                                ? () {
                                    _selectDate(context);
                                  }
                                : null,
                            textColor: snapshot.data.hasFoods != null
                                ? R.color.accent_color
                                : R.color.gray,
                          ),
                          TXTextLinkWidget(
                            title: R.string.editPlan,
                            onTap: () {
                              bloc.changePage(0);
                            },
                            textColor: R.color.accent_color,
                          ),
                          TXTextLinkWidget(
                            title: R.string.resumePlan,
                            onTap: snapshot.data.hasFoods != null
                                ? () {
                                    showTXModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return _showResume(
                                              context, snapshot.data,
                                              showConfirm: false);
                                        });
                                  }
                                : null,
                            textColor: snapshot.data.hasFoods != null
                                ? R.color.accent_color
                                : R.color.gray,
                          ),
                        ],
                      );
              })
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
          return (CalendarUtils.compare(
                      date,
                      (CalendarUtils.compare(
                                  bloc.firstDate, bloc.firstDateHealthResult) >
                              0
                          ? bloc.firstDate
                          : bloc.firstDateHealthResult)) >=
                  0 &&
              CalendarUtils.compare(date, bloc.lastDate) <= 0);
        });
    if (picked != null && picked != bloc.selectedDate) {
      bloc.copyPlan(false, picked);
    }
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }
}
