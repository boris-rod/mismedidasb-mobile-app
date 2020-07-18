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
      if (_pageController.page != onData)
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
            body: Container(
              color: R.color.food_background,
              child: StreamBuilder<DailyFoodModel>(
                stream: bloc.dailyFoodResult,
                initialData: null,
                builder: (ctx, snapshot) {
                  final dailyModel = snapshot.data;
                  return dailyModel == null
                      ? Container()
                      : Container(
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
                                        onPageChanged: (index) {
                                          bloc.changePage(index);
                                        },
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
          showPlaniSuggest: bloc.showPlaniSuggest,
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
                        Fluttertoast.showToast(msg: R.string.emptyFoodList,
                            backgroundColor: R.color.gray,
                            textColor: Colors.white);
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
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 30),
                            padding: EdgeInsets.only(left: 0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 10),
                                    color: R.color.food_blue_lightest,
                                    height: 15,
                                    child: TXTextWidget(
                                      text: "${model.name}",
                                      maxLines: 1,
                                      textOverflow: TextOverflow.ellipsis,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      size: 12,
                                    ),
                                  ),
                                  flex: 1,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: TXComboProgressBarWidget(
                                      imc: bloc.imc,
                                      title: "",
                                      showPercentageInfo: showKCalPercentage,
                                      percentage: bloc
                                          .getCurrentCaloriesPercentageByFood(
                                              model),
                                      mark1: model.activityFoodCalories -
                                          model.activityFoodCaloriesOffSet,
                                      mark2: model.activityFoodCalories +
                                          model.activityFoodCaloriesOffSet,
                                      height: 15,
                                      value: model.caloriesSum,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
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
                    InkWell(
                      onTap: () {
                        setState(() {
                          model.isExpanded = !model.isExpanded;
                        });
                      },
                      child: Image.asset(
                        model.isExpanded
                            ? R.image.up_arrow_icon
                            : R.image.down_arrow_icon,
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ],
                ),
              ),
              model.isExpanded
                  ? Column(
                      children: <Widget>[
                        (model.id != 1 && model.id != 3)
                            ? Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  children: <Widget>[
                                    Image.asset(R.image.divider_icon),
                                    TXFoodHealthyFilterWidget(
                                      onFilterTapped: (index) async {
                                        final resultList =
                                            await NavigationUtils.push(
                                                context,
                                                FoodPage(
                                                  dailyActivityFoodModel: model,
                                                  selectedItems: model.foods,
                                                  imc: bloc.imc,
                                                  foodFilterMode: FoodFilterMode
                                                      .dish_healthy,
                                                  foodFilterCategoryIndex:
                                                      index,
                                                ));
                                        if (resultList is List<FoodModel>) {
                                          model.foods = resultList;
                                          bloc.setFoodList(model);
                                        }
                                      },
                                    )
                                  ],
                                ))
                            : Container(),
                        SizedBox(
                          height: 5,
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
        color: R.color.food_blue_light,
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
        contentPadding: EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 0),
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
          text: model.name,
          color: Colors.white,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
        ),
        trailing: TXIconButtonWidget(
          onPressed: () {
            modelList.remove(model);
            bloc.setFoodList(dailyActivityFoodModel);
          },
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 25,
          ),
        ),
        dense: true,
      );
      list.add(Image.asset(R.image.divider_icon));
      list.add(w);
    });
    return list;
  }

  Widget _getCalendarView(
      BuildContext context, List<DailyFoodModel> modelList) {
    final firstD = CalendarUtils.getFirstDateOfPreviousMonth();
    final lastD = CalendarUtils.getLastDateOfNextMonth();
    if (bloc.isCopying) {
      _calendarController.setSelectedDay(bloc.selectedDate);
      bloc.isCopying = false;
    }
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[
          StreamBuilder<Map<DateTime, List<DailyFoodModel>>>(
          stream: bloc.calendarPageResult,
          initialData: {},
          builder: (ctx, snapshotCalendarData) {
            final currentDateMonth = bloc.currentCalendarPage < 0 ? CalendarUtils.getFirstDateOfPreviousMonth() :
            bloc.currentCalendarPage > 0 ? CalendarUtils.getFirstDateOfNextMonth() : DateTime.now();

            return Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: 350),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TXIconButtonWidget(
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          size: 30,
                          color: bloc.currentCalendarPage < 0
                              ? R.color.gray_dark
                              : R.color.food_nutri_info,
                        ),
                        onPressed: bloc.currentCalendarPage < 0
                            ? null
                            : () {
                          bloc.currentCalendarPage -= 1;
                          bloc.changeCalendarPage();
                          final focus = bloc.currentCalendarPage < 0 ? CalendarUtils.getFirstDateOfPreviousMonth() :
                          bloc.currentCalendarPage > 0 ? CalendarUtils.getFirstDateOfNextMonth() : DateTime.now();
                          _calendarController.setFocusedDay(focus);

                        },
                      ),
                      Expanded(
                        child: TXTextWidget(
                            textAlign: TextAlign.center,
                            text: "${CalendarUtils.showInFormat(
                              "MMMM",
                              currentDateMonth,
                            )} de ${CalendarUtils.showInFormat(
                              "yyyy",
                              currentDateMonth,
                            )}",
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            size: 25),
                      ),
                      TXIconButtonWidget(
                        icon: Icon(
                          Icons.keyboard_arrow_right,
                          size: 30,
                          color: bloc.currentCalendarPage > 0
                              ? R.color.gray_dark
                              : R.color.food_nutri_info,
                        ),
                        onPressed: bloc.currentCalendarPage > 0
                            ? null
                            : () {
                          bloc.currentCalendarPage += 1;
                          bloc.changeCalendarPage();
                          final focus = bloc.currentCalendarPage < 0 ? CalendarUtils.getFirstDateOfPreviousMonth() :
                          bloc.currentCalendarPage > 0 ? CalendarUtils.getFirstDateOfNextMonth() : DateTime.now();
                          _calendarController.setFocusedDay(focus);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TableCalendar(
                  availableGestures: AvailableGestures.none,
                  headerVisible: false,
                  locale: AppConfig.locale == AppLocale.EN
                      ? 'en_US'
                      : AppConfig.locale == AppLocale.IT ? 'it_IT' : 'es_ES',
                  calendarController: _calendarController,
                  startDay: firstD,
                  endDay: lastD,
                  onDaySelected: (datetime, events) {
//              print(datetime.toIso8601String());
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
                  events: snapshotCalendarData.data,
                  initialCalendarFormat: CalendarFormat.month,
                  availableCalendarFormats: Map.of({CalendarFormat.month: ""}),
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                  ),
//            onVisibleDaysChanged: (dateTimeFirst, dateTimeLast, calendarFormat){
//
//            },
                  headerStyle: HeaderStyle(
                    centerHeaderTitle: true,
                    titleTextStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                    rightChevronIcon: Icon(
                      Icons.keyboard_arrow_right,
                      size: 30,
                      color: R.color.food_nutri_info,
                    ),
                    leftChevronIcon: Icon(
                      Icons.keyboard_arrow_left,
                      size: 30,
                      color: R.color.food_nutri_info,
                    ),
                  ),
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
                        color: Colors.white,
                      );
                    },
                    dowWeekdayBuilder: (context, str) {
                      return TXTextWidget(
                        text: str.toCapitalize().substring(0, str.length - 1),
                        textAlign: TextAlign.center,
                        color: Colors.white,
                      );
                    },
                    dayBuilder: (context, date, events) {
                      bool isValidDay = (CalendarUtils.compare(
                          date,
                          (CalendarUtils.compare(firstD,
                              bloc.firstDateHealthResult) >
                              0
                              ? firstD
                              : bloc.firstDateHealthResult)) >=
                          0 &&
                          CalendarUtils.compare(date, lastD) <= 0);
                      return Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: Center(
                          child: TXTextWidget(
                            text: "${date.day}",
                            color: isValidDay ? Colors.white : R.color.gray,
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
                                  backgroundColor: R.color.button_color,
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
                                  backgroundColor: R.color.food_action_bar,
                                  radius: 12,
                                ),
                              ),
                              Center(
                                child: TXTextWidget(
                                  text: "${date.day}",
                                  size: 14,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
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
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            title: R.string.copyPlan,
                            onTap: snapshot.data.hasFoods != null
                                ? () {
                                    _selectDate(context);
                                  }
                                : null,
                            textColor: snapshot.data.hasFoods != null
                                ? R.color.food_nutri_info
                                : R.color.food_blue_light,
                          ),
                          TXTextLinkWidget(
                            title: R.string.editPlan,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            onTap: () {
                              bloc.changePage(0);
                            },
                            textColor: R.color.food_nutri_info,
                          ),
                          TXTextLinkWidget(
                            title: R.string.resumePlan,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
                                ? R.color.food_nutri_info
                                : R.color.food_blue_light,
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
    bool hasFoods = dailyModel != null && dailyModel.hasFoods != null;
    if (hasFoods) {
      double calSum = dailyModel.currentCaloriesSum;
      return Align(
        alignment: Alignment.bottomCenter,
        child: Icon(
          calSum > dailyModel.dailyFoodPlanModel.kCalMax
              ? Icons.add_circle_outline
              : calSum > dailyModel.dailyFoodPlanModel.kCalMin
                  ? Icons.check_circle_outline
                  : Icons.remove_circle_outline,
          size: 14,
          color: calSum > dailyModel.dailyFoodPlanModel.kCalMax
              ? Colors.red[400]
              : calSum > dailyModel.dailyFoodPlanModel.kCalMin
                  ? Colors.green[400]
                  : Colors.yellow[400],
        ),
      );
    }
    return Container();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final firstD = CalendarUtils.getFirstDateOfPreviousMonth();
    final lastD = CalendarUtils.getLastDateOfNextMonth();
    final DateTime picked = await showDatePicker(
        context: context,
        locale: const Locale('es', 'ES'),
        confirmText: "COPIAR PLAN PARA ESTE DIA",
        cancelText: "CANCELAR",
        initialDate: bloc.selectedDate,
        firstDate: firstD,
        lastDate: lastD,
        selectableDayPredicate: (date) {
          return (CalendarUtils.compare(
                      date,
                      (CalendarUtils.compare(
                                  firstD, bloc.firstDateHealthResult) >
                              0
                          ? firstD
                          : bloc.firstDateHealthResult)) >=
                  0 &&
              CalendarUtils.compare(date, lastD) <= 0);
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
