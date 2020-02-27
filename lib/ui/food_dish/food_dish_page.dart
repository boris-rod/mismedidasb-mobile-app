import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_network_image.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/food_dish/food_dish_bloc.dart';

class FoodDishPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FoodDishState();
}

class _FoodDishState extends StateWithBloC<FoodDishPage, FoodDishBloC> {
  @override
  void initState() {
    super.initState();
    bloc.loadInitialData();
  }

  @override
  Widget buildWidget(BuildContext context) {
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
              return snapshot.data == null
                  ? Container()
                  : SingleChildScrollView(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                      child: Container(
                        child: Column(
                          children: _getDailyActivityFood(
                              context, snapshot.data.dailyActivityFoodModel),
                        ),
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
    modelList.forEach((model) {
      final w = Container(
        width: double.infinity,
        child: Card(
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  bloc.expCollDailyFood(model);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TXTextWidget(
                          text: model.name,
                          fontWeight: FontWeight.bold,
                          color: R.color.primary_dark_color,
                          size: 16,
                        ),
                      ),
                      TXIconButtonWidget(
                        icon: Icon(
                          model.isExpanded
                              ? Icons.arrow_drop_down
                              : Icons.arrow_drop_up,
                          color: R.color.primary_dark_color,
                        ),
                      )
                    ],
                  ),
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
                        ..._getFoodGroup(context, modelList.indexOf(model),
                            model.foodGroupList),
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
    });
    return list;
  }

  List<Widget> _getFoodGroup(BuildContext context, int dailyFoodModelIndex,
      List<FoodGroupModel> modelList) {
    List<Widget> list = [];
    modelList.forEach((model) {
      final w = Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        width: double.infinity,
        child: Card(
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () async {
                  final list = await bloc.loadFoods("Proteins", "");
                  _showFoodList(context, list);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TXTextWidget(
                          text: model.name,
                        ),
                      ),
                      TXIconButtonWidget(
                        onPressed: () {
                          bloc.expCollGroup(dailyFoodModelIndex, model);
                        },
                        icon: Icon(
                          model.isExpanded
                              ? Icons.arrow_drop_down
                              : Icons.arrow_drop_up,
                          color: R.color.primary_dark_color,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              model.isExpanded
                  ? Column(
                      children: _getFoods(model.foods),
                    )
                  : Container()
            ],
          ),
        ),
      );
      list.add(w);
    });
    return list;
  }

  List<Widget> _getFoods(List<FoodModel> modelList) {
    List<Widget> list = [];
    modelList.forEach((model) {
      final w = ListTile(
        leading: TXNetworkImage(
          width: 60,
          height: 60,
          imageUrl: model.image,
          placeholderImage: R.image.logo,
        ),
        title: TXTextWidget(
          text: model.name,
        ),
      );
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
