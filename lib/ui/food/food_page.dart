import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_action_chip_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_checkbox_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_gesture_hide_key_board.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_network_image.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_search_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/food/food_bloc.dart';

class FoodPage extends StatefulWidget {
  final List<FoodModel> selectedItems;

  const FoodPage({Key key, this.selectedItems}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FoodState();
}

class _FoodState extends StateWithBloC<FoodPage, FoodBloC> {
  @override
  void initState() {
    super.initState();
    bloc.loadData(widget.selectedItems ?? []);
  }

  void _navBack() async {
    NavigationUtils.pop(context,
        result: bloc.foodsAll.where((f) => f.isSelected).toList());
  }

  @override
  Widget buildWidget(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return WillPopScope(
      onWillPop: () async {
        _navBack();
        return false;
      },
      child: Stack(
        children: <Widget>[
          StreamBuilder<bool>(
            stream: bloc.searchShowResult,
            initialData: false,
            builder: (context, searchSnapshot) {
              return TXSearchAppBarWidget(
                title: "Alimentos",
                centeredTitle: true,
                searchController: searchController,
                leading: TXIconButtonWidget(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    _navBack();
                  },
                ),
                isSearching: searchSnapshot.data,
                onSearchTap: () {
                  bloc.setShowSearch();
                },
                onQueryChanged: (value) {
                  bloc.currentQuery = value;
                  bloc.queryData();
                },
                body: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        width: double.infinity,
                        child: StreamBuilder<List<TagModel>>(
                          stream: bloc.tagsResult,
                          initialData: [],
                          builder: (context, snapshot) {
                            return Wrap(
                              children: _getActionChips(context, snapshot.data),
                            );
                          },
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: .5,
                        color: R.color.gray,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      Expanded(
                        child: StreamBuilder<List<FoodModel>>(
                          stream: bloc.foodsResult,
                          initialData: [],
                          builder: (context, snapshot) {
                            return TXGestureHideKeyBoard(
                              child: ListView.builder(
                                  padding: EdgeInsets.only(top: 5, bottom: 30),
                                  physics: BouncingScrollPhysics(),
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
                                        placeholderImage: R.image.logo_blue,
                                        height: 40,
                                        width: 40,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                      onTap: () {
                                        model.isSelected = !model.isSelected;
                                        bloc.setSelectedFood(model);
                                      },
                                      title: TXTextWidget(
                                        text: model.name,
                                        color: model.isSelected
                                            ? R.color.primary_color
                                            : Colors.black,
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
                                  }),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
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

  List<Widget> _getCategories(List<TagModel> list) {
    List<Widget> resultList = [];
    list.forEach((tag) {
      final w = TXTextWidget(
        text: tag.name,
        color: R.color.gray,
        size: 8,
      );
      resultList.add(w);
    });
    return resultList;
  }

  List<Widget> _getActionChips(BuildContext context, List<TagModel> list) {
    List<Widget> resultList = [];

    list.forEach((t) {
      final w = Container(
        margin: EdgeInsets.only(right: 10),
        child: TXActionChipWidget(
          tag: t,
          onTap: () {
            bloc.setTagState(t);
          },
        ),
      );
      resultList.add(w);
    });

    return resultList;
  }
}
