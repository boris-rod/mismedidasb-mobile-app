import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
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
import 'package:mismedidasb/ui/_tx_widget/tx_video_intro_widet.dart';
import 'package:mismedidasb/ui/food/food_bloc.dart';
import 'package:mismedidasb/ui/food/tx_food_app_bar_widget.dart';
import 'package:mismedidasb/ui/food_add_edit/food_add_edit_page.dart';
import 'package:mismedidasb/ui/food_search/food_search_page.dart';
import 'package:mismedidasb/ui/profile/tx_cell_selection_option_widget.dart';
import 'package:mismedidasb/utils/file_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import '../../enums.dart';

class FoodPage extends StatefulWidget {
  final List<FoodModel> selectedItems;
  final FoodFilterMode foodFilterMode;
  final int currentHarvardFilter;
  final int currentTag;
  final DailyActivityFoodModel dailyActivityFoodModel;
  final double imc;

  FoodPage(
      {Key key,
      this.selectedItems,
      this.foodFilterMode = FoodFilterMode.tags,
      this.currentHarvardFilter,
      this.dailyActivityFoodModel,
      this.imc,
      this.currentTag})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _FoodState();
}

class _FoodState extends StateWithBloC<FoodPage, FoodBloC> {
  PageController _pageController = PageController();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    widget.dailyActivityFoodModel.isExpanded = true;
    bloc.loadData(widget.selectedItems, widget.foodFilterMode,
        widget.currentTag, widget.currentHarvardFilter);

    bloc.pageResult.listen((onData) {
      _pageController.animateToPage(onData,
          duration: Duration(milliseconds: 300), curve: Curves.linear);
    });
    Future.delayed(Duration(milliseconds: 500), () {
      bloc.launchFirstTime();
    });
  }

  void _navBack() async {
    NavigationUtils.pop(context, result: bloc.selectedFoods.values.toList());
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
                              selectedItems: bloc.selectedFoods.values.toList(),
                            ));
                        if (res is List<FoodModel>) {
                          bloc.syncFoods(res);
                        }
                      } else {
                        final res = await NavigationUtils.push(
                          context,
                          FoodAddEditPage(
                            compoundFoodModelList: bloc.compoundsFoods,
                          ),
                        );
                        if (res ?? false) {
                          bloc.loadCompoundFoods(true);
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
                                                            .activityFoodCalories -
                                                        widget
                                                            .dailyActivityFoodModel
                                                            .activityFoodCaloriesOffSet,
                                                    mark2: widget
                                                            .dailyActivityFoodModel
                                                            .activityFoodCalories +
                                                        widget
                                                            .dailyActivityFoodModel
                                                            .activityFoodCaloriesOffSet,
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
                                                              R.image.logo,
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
                                                                        title: R
                                                                            .string
                                                                            .quantity,
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
                                                            bloc.setSelectedFood(
                                                                food);
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
                                                text: "${R.string.filter}:",
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
          ),
          StreamBuilder<bool>(
              stream: bloc.showFirstTimeResult,
              initialData: false,
              builder: (context, snapshotShow) {
                return snapshotShow.data
                    ? TXVideoIntroWidget(
                        title: R.string.portionFoodHelper,
                        onSeeVideo: () {
                          bloc.setNotFirstTime();
                          launch(Platform.isAndroid ? Endpoint.foodPortionsVideo: Endpoint.metririWeb);
//                          FileManager.playVideo("portions_food_sizes.mp4");
                        },
                        onSkip: () {
                          bloc.setNotFirstTime();
                        },
                      )
                    : Container();
              }),
        ],
      ),
    );
  }

  Widget _getFoodsPage() {
    return StreamBuilder<List<FoodModel>>(
      stream: bloc.foodsResult,
      initialData: [],
      builder: (context, snapshot) {
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
//            print(_scrollController.position.maxScrollExtent.toString());
//            print(notification.metrics.pixels.toString());
            if (notification.metrics.pixels >
                _scrollController.position.maxScrollExtent - 10) {
              if (!bloc.isLoadingMore && bloc.hasMore) bloc.loadFoods(false);
            }
            return true;
          },
          child: ListView.builder(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(top: 5, bottom: 100),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final model = snapshot.data[index];
                return _getFoodItem(model);
              }),
        );
      },
    );
  }

  Widget _getMyFoodPage() {
    bloc.loadCompoundFoods(false);
    return StreamBuilder<List<FoodModel>>(
      stream: bloc.foodsCompoundResult,
      initialData: [],
      builder: (ctx, snapshot) {
        return ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: 5, bottom: 70),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              final model = snapshot.data[index];
              return _getFoodItem(model);
            });
      },
    );
  }

  Widget _getFoodItem(FoodModel model) {
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
        placeholderImage: R.image.logo,
        boxFitImage: BoxFit.cover,
        height: 40,
        width: 40,
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      onTap: () async {
        if (model.isCompound) {
          final res = await NavigationUtils.push(
            context,
            FoodAddEditPage(
              foodModel: model,
              compoundFoodModelList: bloc.compoundsFoods,
            ),
          );
          if (res ?? false) {
            bloc.loadCompoundFoods(true);
          }
        } else {
          model.isSelected = !model.isSelected;
          bloc.setSelectedFood(model);
        }
      },
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TXTextWidget(
            text: model.name,
            color: model.isSelected ? R.color.primary_color : Colors.black,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    bloc.markUnMarkFood(
                        model.id, FoodsTypeMark.favorites, !model.isFavorite);
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 3, bottom: 5),
                    child: Row(
                      children: [
                        Icon(
                          model.isFavorite ? Icons.star : Icons.star_border,
                          color: model.isFavorite
                              ? Colors.orangeAccent
                              : R.color.gray,
                          size: 20,
                        ),
                        Expanded(
                          child: TXTextWidget(
                            size: 12,
                            color: R.color.gray_darkest,
                            text: R.string.favorite,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    bloc.markUnMarkFood(model.id, FoodsTypeMark.lackSelfControl,
                        !model.isLackSelfControlDish);
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 3, bottom: 5),
                    child: Row(
                      children: [
                        Icon(
                          model.isLackSelfControlDish
                              ? Icons.remove_circle_outline
                              : Icons.remove_circle_outline,
                          color: model.isLackSelfControlDish
                              ? Colors.redAccent
                              : R.color.gray,
                          size: 20,
                        ),
                        Expanded(
                          child: TXTextWidget(
                            size: 12,
                            color: R.color.gray_darkest,
                            text: R.string.lackSelfControl,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _showCategoryFilter(BuildContext context) {
    return Container(
      height: widget.foodFilterMode == FoodFilterMode.tags
          ? math.min(MediaQuery.of(context).size.height / 2,
              ((bloc.tagList.length + 20) + 1) * 50.0)
          : 320,
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
                final filter = widget.foodFilterMode == FoodFilterMode.tags
                    ? bloc.tagList[index]
                    : bloc.harvardFilterList[index];
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
              itemCount: widget.foodFilterMode == FoodFilterMode.tags
                  ? bloc.tagList.length
                  : bloc.harvardFilterList.length,
            ),
          )
        ],
      ),
    );
  }
}
