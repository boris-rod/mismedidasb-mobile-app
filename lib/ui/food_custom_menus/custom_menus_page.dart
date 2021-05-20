import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mismedidasb/domain/menu/menu_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_navigator_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_network_image.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/food_custom_menus/custom_menus_bloc.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/ui/plani_service/plani_service_page.dart';
import '../../enums.dart';

class CustomMenusPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => CustomMenusState();
}

class CustomMenusState extends StateWithBloC<CustomMenusPage, CustomMenusBloC> {
  ScrollController scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScrollDown);
    bloc.initData();
  }

  void onScrollDown() {
    if(scrollController.position.pixels > scrollController.position.maxScrollExtent - 100)
      bloc.loadMore();
  }

  @override
  void dispose() {
    scrollController.removeListener(onScrollDown);
    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: [
        TXMainAppBarWidget(
          title: R.string.chooseYourPlan,
          backgroundColorAppBar: R.color.food_action_bar,
          titleFont: FontWeight.w300,
          leading: Container(
            margin: EdgeInsets.only(left: 10),
            child: TXIconNavigatorWidget(
              onTap: () {
                NavigationUtils.pop(context);
              },
            ),
          ),
          body: StreamBuilder<List<MenuModel>>(
            stream: bloc.menusResult,
            initialData: [],
            builder: (context, snapshot) {
              return snapshot.data.isEmpty
                  ? Container()
                  : ListView.builder(
                controller: scrollController,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: ExpansionTileCard(
                            onExpansionChanged: (expanded) {
                              if(!bloc.hasSubscription) NavigationUtils.pushReplacement(context, PlaniServicePage(userModel: bloc.profile, fromMenus: true));
                            },
                            baseColor: R.color.food_blue_lightest,
                            expandedColor: Colors.cyan[50],
                            title:
                                TXTextWidget(text: snapshot.data[index].name),
                            children: <Widget>[
                              Divider(
                                thickness: 1.0,
                                height: 1.0,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    // horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  child: Column(
                                    children: [
                                      ..._getDailyFoodActivity(
                                          snapshot.data[index].dailyEats,
                                          index),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    child: FlatButton(
                                      onPressed: () {
                                        NavigationUtils.pop(context, result: snapshot.data[index].dailyEats);
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0)),
                                      child: Column(
                                        children: <Widget>[
                                          Icon(Icons.check,
                                              color: R.color.food_green),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                          ),
                                          TXTextWidget(
                                              text: 'Seleccionar',
                                              color: R.color.food_green),
                                          SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                    );
            },
          ),
        ),
        TXLoadingWidget(loadingStream: bloc.isLoadingStream),
      ],
    );
  }

  List<Widget> _getDailyFoodActivity(
          List<DailyActivityFoodModel> model, int index) =>
      model.map((e) => _getFoodActivity(e, index)).toList();

  Widget _getFoodActivity(DailyActivityFoodModel model, int index) {
    List<Widget> foods = [];
    model.foods.forEach((element) {
      foods.add(ListTile(
        leading: TXNetworkImage(
          imageUrl: element.image,
          placeholderImage: R.image.logo,
          boxFitImage: BoxFit.cover,
          height: 40,
          width: 40,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TXTextWidget(
              text: element.name,
            ),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Expanded(
            //       flex: 1,
            //       child: InkWell(
            //         onTap: () {
            //           bloc.markUnMarkFood(index, model.id, element.id,
            //               FoodsTypeMark.favorites, !element.isFavorite);
            //         },
            //         child: Container(
            //           padding: EdgeInsets.only(top: 3, bottom: 5),
            //           child: Row(
            //             children: [
            //               Icon(
            //                 element.isFavorite ? Icons.star : Icons.star_border,
            //                 color: element.isFavorite
            //                     ? Colors.orangeAccent
            //                     : R.color.gray,
            //                 size: 20,
            //               ),
            //               Expanded(
            //                 child: TXTextWidget(
            //                   size: 12,
            //                   color: R.color.gray_darkest,
            //                   text: R.string.favorite,
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       flex: 1,
            //       child: InkWell(
            //         onTap: () {
            //           bloc.markUnMarkFood(index, model.id, element.id, FoodsTypeMark.lackSelfControl,
            //               !element.isLackSelfControlDish);
            //         },
            //         child: Container(
            //           padding: EdgeInsets.only(top: 3, bottom: 5),
            //           child: Row(
            //             children: [
            //               Icon(
            //                 element.isLackSelfControlDish
            //                     ? Icons.remove_circle_outline
            //                     : Icons.remove_circle_outline,
            //                 color: element.isLackSelfControlDish
            //                     ? Colors.redAccent
            //                     : R.color.gray,
            //                 size: 20,
            //               ),
            //               Expanded(
            //                 child: TXTextWidget(
            //                   size: 12,
            //                   color: R.color.gray_darkest,
            //                   text: R.string.lackSelfControl,
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       ),
            //     )
            //   ],
            // )
          ],
        ),
      ));
    });
    return ExpansionTile(
      title: TXTextWidget(text: model.name),
      children: foods,
      childrenPadding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
    );
  }
}
