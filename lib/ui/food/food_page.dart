import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_action_chip_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_checkbox_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_combo_progress_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_divider_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_gesture_hide_key_board.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_network_image.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textfield_widget.dart';
import 'package:mismedidasb/ui/food/food_bloc.dart';
import 'package:mismedidasb/ui/food/tx_food_app_bar_widget.dart';
import 'package:mismedidasb/ui/food_add_edit/food_add_edit_page.dart';
import 'package:mismedidasb/ui/food_search/food_search_page.dart';
import 'package:mismedidasb/ui/profile/tx_cell_selection_option_widget.dart';
import 'dart:math' as math;
import '../../enums.dart';

class FoodPage extends StatefulWidget {
  final List<FoodModel> selectedItems;
  final FoodFilterMode foodFilterMode;
  final int foodFilterCategoryIndex;
  final DailyActivityFoodModel dailyActivityFoodModel;
  final double imc;

  FoodPage(
      {Key key,
      this.selectedItems,
      this.foodFilterMode = FoodFilterMode.tags,
      this.foodFilterCategoryIndex = 0,
      this.dailyActivityFoodModel,
      this.imc})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _FoodState();
}

class _FoodState extends StateWithBloC<FoodPage, FoodBloC> {
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    widget.dailyActivityFoodModel.isExpanded = true;
    bloc.loadData(widget.selectedItems, widget.foodFilterMode,
        widget.foodFilterCategoryIndex);

    bloc.pageResult.listen((onData) {
      _pageController.animateToPage(onData,
          duration: Duration(milliseconds: 300), curve: Curves.linear);
    });
  }

  void _navBack() async {
    NavigationUtils.pop(context,
        result: bloc.foodsAll.where((f) => f.isSelected).toList());
    widget.dailyActivityFoodModel.isExpanded = true;
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
          StreamBuilder<int>(
            stream: bloc.pageResult,
            initialData: 0,
            builder: (ctx, pageSnapshot) {
              return StreamBuilder<TagModel>(
                stream: bloc.filterResult,
                initialData: TagModel(name: ""),
                builder: (context, filterSnapshot) {
                  return TXFoodAppBarWidget(
                    title: R.string.foods,
                    leading: TXIconButtonWidget(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        _navBack();
                      },
                    ),
                    onFloatingTap: () async {
                      if (pageSnapshot.data == 0) {
                        final res = await NavigationUtils.push(
                            context,
                            FoodSearchPage(
                              allFoods: bloc.foodsAll,
                            ));
                        bloc.syncFoods();
                      } else {
                        final res = await NavigationUtils.push(
                            context, FoodAddEditPage());
                        if (res) {
                          bloc.loadData(
                              widget.selectedItems,
                              widget.foodFilterMode,
                              widget.foodFilterCategoryIndex);
                        }
                      }
                    },
                    onFilterTap: () {
                      showTXModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return _showCategoryFilter(context);
                          });
                    },
                    selectedItemIndex: pageSnapshot.data,
                    onItemTaped: (index) {
                      _pageController.animateToPage(index,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.linear);
                    },
                    body: Container(
                      child: Column(
                        children: <Widget>[
                          StreamBuilder<List<FoodModel>>(
                            stream: bloc.foodsSelectedResult,
                            initialData: [],
                            builder: (ctx, snapshot) {
                              snapshot.data.sort((a, b) => a.name
                                  .trim()
                                  .toLowerCase()
                                  .compareTo(b.name.trim().toLowerCase()));
                              widget.dailyActivityFoodModel.foods =
                                  snapshot.data;
                              return Column(
                                children: <Widget>[
                                  Card(
                                    elevation: 4,
                                    color: R.color.gray_light,
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxHeight: widget
                                                  .dailyActivityFoodModel
                                                  .isExpanded
                                              ? math.min(
                                                  (snapshot.data.length *
                                                          60.0) +
                                                      60,
                                                  300)
                                              : 60),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: InkWell(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          widget.dailyActivityFoodModel
                                                                  .isExpanded
                                                              ? Icons
                                                                  .keyboard_arrow_up
                                                              : Icons
                                                                  .keyboard_arrow_down,
                                                          size: 28,
                                                          color: R.color
                                                              .primary_dark_color,
                                                        ),
                                                        TXTextWidget(
                                                          text:
                                                              "${widget.dailyActivityFoodModel.name}",
                                                          maxLines: 1,
                                                          textOverflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: R.color
                                                              .primary_dark_color,
                                                          size: 15,
                                                        )
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        widget.dailyActivityFoodModel
                                                                .isExpanded =
                                                            !widget
                                                                .dailyActivityFoodModel
                                                                .isExpanded;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 15),
                                                  width: 160,
                                                  child:
                                                      TXComboProgressBarWidget(
                                                    imc: widget.imc,
                                                    title: "",
                                                    showPercentageInfo:
                                                        bloc.kCalPercentageHide,
                                                    percentage: widget
                                                        .dailyActivityFoodModel
                                                        .getCurrentCaloriesPercentageByFood,
                                                    mark1: widget
                                                            .dailyActivityFoodModel
                                                            .getActivityFoodCalories -
                                                        widget
                                                            .dailyActivityFoodModel
                                                            .getActivityFoodCaloriesOffSet,
                                                    mark2: widget
                                                            .dailyActivityFoodModel
                                                            .getActivityFoodCalories +
                                                        widget
                                                            .dailyActivityFoodModel
                                                            .getActivityFoodCaloriesOffSet,
                                                    height: 15,
                                                    value: widget
                                                        .dailyActivityFoodModel
                                                        .activityCalories,
                                                  ),
                                                ),
//                                                TXIconButtonWidget(
//                                                  onPressed: null,
//                                                  icon: Icon(
//                                                    Icons.add,
//                                                    color: Colors.transparent,
//                                                  ),
//                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: .5,
                                            color: R.color.gray,
                                            margin: EdgeInsets.only(left: 10),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder: (ctx, index) {
                                                final food =
                                                    snapshot.data[index];
                                                return widget
                                                        .dailyActivityFoodModel
                                                        .isExpanded
                                                    ? ListTile(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                left: 5,
                                                                right: 0),
                                                        leading: TXNetworkImage(
                                                          width: 40,
                                                          height: 40,
                                                          imageUrl: food.image,
                                                          placeholderImage:
                                                              R.image.plani,
                                                        ),
                                                        title: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child:
                                                                  TXTextWidget(
                                                                text: food.name,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                final selectorList =
                                                                    food.availableCounts;
                                                                showTXModalBottomSheet(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (ctx) {
                                                                      return TXCupertinoPickerWidget(
                                                                        height:
                                                                            300,
                                                                        list:
                                                                            selectorList,
                                                                        onItemSelected:
                                                                            (value) {
                                                                          setState(
                                                                              () {
                                                                            food.count =
                                                                                value.partialValue;
                                                                          });
                                                                        },
                                                                        title:
                                                                            "Cantidad",
                                                                        initialId:
                                                                            selectorList[3].id,
                                                                      );
                                                                    });
                                                              },
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor: R
                                                                    .color
                                                                    .accent_color,
                                                                child:
                                                                    TXTextWidget(
                                                                  text:
                                                                      "${food.displayCount}",
                                                                  color: Colors
                                                                      .white,
                                                                  size: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                radius: 12,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        trailing:
                                                            TXIconButtonWidget(
                                                          onPressed: () {
                                                            food.isSelected =
                                                                false;
                                                            if (food
                                                                .isCompound) {
                                                              bloc.setSelectedFoodCompound(
                                                                  food);
                                                            } else {
                                                              bloc.setSelectedFood(
                                                                  food);
                                                            }
                                                          },
                                                          icon: Icon(
                                                            Icons.close,
                                                            color: R.color
                                                                .primary_color,
                                                          ),
                                                        ),
                                                      )
                                                    : Container();
                                              },
                                              itemCount: snapshot.data.length,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  pageSnapshot.data == 0
                                      ? Container(
                                          child: Row(
                                            children: <Widget>[
                                              TXTextWidget(
                                                text: "Filtro:",
                                                color: R.color.primary_color,
                                                size: 10,
                                              ),
                                              TXTextWidget(
                                                text: filterSnapshot.data.name,
                                                color: R.color.primary_color,
                                                maxLines: 1,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                fontWeight: FontWeight.bold,
                                              )
                                            ],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                          ),
                                          padding:
                                              EdgeInsets.symmetric(vertical: 10)
                                                  .copyWith(right: 20),
                                          width: double.infinity,
                                        )
                                      : Container(),
                                ],
                              );
                            },
                          ),
                          Expanded(
                            child: PageView.builder(
                              controller: _pageController,
                              onPageChanged: (index) {
                                bloc.changePage = index;
                              },
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (ctx, pageIndex) {
                                return pageIndex == 0
                                    ? _getFoodsPage()
                                    : _getMyFoodPage();
                              },
                              itemCount: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          TXLoadingWidget(
            loadingStream: bloc.isLoadingStream,
          )
        ],
      ),
    );
  }

  Widget _getFoodsPage() {
    return StreamBuilder<List<FoodModel>>(
      stream: bloc.foodsFilteredResult,
      initialData: [],
      builder: (context, snapshot) {
        snapshot.data.sort((a, b) =>
            a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
        return ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: 5, bottom: 30),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              final model = snapshot.data[index];
              return ListTile(
                trailing: Checkbox(
                  checkColor: R.color.primary_color,
                  onChanged: (value) {
                    model.isSelected = !model.isSelected;
                    bloc.setSelectedFood(model);
                  },
                  value: model.isSelected,
                ),
                leading: TXNetworkImage(
                  imageUrl: model.image,
                  placeholderImage: R.image.plani,
                  height: 40,
                  width: 40,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                onTap: () {
                  model.isSelected = !model.isSelected;
                  bloc.setSelectedFood(model);
                },
                title: TXTextWidget(
                  text: model.name,
                  color:
                      model.isSelected ? R.color.primary_color : Colors.black,
                ),
//                                    subtitle: Column(
//                                      crossAxisAlignment: CrossAxisAlignment.start,
//                                      children: <Widget>[
//                                        TXTextWidget(
//                                          text: "Calorias: ${model.calories}",
//                                          color: R.color.gray,
//                                          size: 10,
//                                        ),
//                                        ..._getCategories(model.tags),
//                                      ],
//                                    ),
              );
            });
      },
    );
  }

  Widget _getMyFoodPage() {
    return StreamBuilder<List<FoodModel>>(
      stream: bloc.foodsCompoundResult,
      initialData: [],
      builder: (ctx, snapshot) {
        return ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: 5, bottom: 30),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              final model = snapshot.data[index];
              return ListTile(
                trailing: Checkbox(
                  checkColor: R.color.primary_color,
                  onChanged: (value) {
                    model.isSelected = !model.isSelected;
                    bloc.setSelectedFood(model);
                  },
                  value: model.isSelected,
                ),
                leading: TXNetworkImage(
                  imageUrl: model.image,
                  placeholderImage: R.image.plani,
                  height: 40,
                  width: 40,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                onTap: () async {
                  final res = await NavigationUtils.push(
                      context,
                      FoodAddEditPage(
                        foodModel: model,
                      ));
                  if (res) {
                    bloc.loadData(widget.selectedItems, widget.foodFilterMode,
                        widget.foodFilterCategoryIndex);
                  }
                },
                title: TXTextWidget(
                  text: model.name,
                  color:
                      model.isSelected ? R.color.primary_color : Colors.black,
                ),
//                                    subtitle: Column(
//                                      crossAxisAlignment: CrossAxisAlignment.start,
//                                      children: <Widget>[
//                                        TXTextWidget(
//                                          text: "Calorias: ${model.calories}",
//                                          color: R.color.gray,
//                                          size: 10,
//                                        ),
//                                        ..._getCategories(model.tags),
//                                      ],
//                                    ),
              );
            });
      },
    );
  }

  Widget _showCategoryFilter(BuildContext context) {
    return Container(
      height: widget.foodFilterMode == FoodFilterMode.tags ? math.min(
          MediaQuery.of(context).size.height / 2,
          ((bloc.tagsAll.length + 20) + 1) *
              50.0) : 200,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10),
            child: TXTextWidget(
              text: R.string.filter,
              fontWeight: FontWeight.bold,
              size: 16,
              color: R.color.primary_color,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10),
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                final filter = bloc.tagsAll[index];
                return Column(
                  children: <Widget>[
                    TXCellSelectionOptionWidget(
                      trailing: filter.isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      optionName: filter.name,
                      onOptionTap: () {
                        NavigationUtils.pop(context);
                        bloc.changeCategoryFilter(filter.id);
                      },
                    ),
                    TXDividerWidget(),
                  ],
                );
              },
              itemCount: bloc.tagsAll.length,
            ),
          )
        ],
      ),
    );
  }
}
