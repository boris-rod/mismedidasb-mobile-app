import 'package:flutter/material.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_gesture_hide_key_board.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_network_image.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textfield_widget.dart';
import 'package:mismedidasb/ui/food_search/food_search_bloc.dart';

class FoodSearchPage extends StatefulWidget {
  final List<FoodModel> selectedItems;

  const FoodSearchPage({Key key, this.selectedItems}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FoodSearchState();
}

class _FoodSearchState extends StateWithBloC<FoodSearchPage, FoodSearchBloC> {
  TextEditingController searchTextController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  DateTime searchMarkTime = DateTime.now();

  void _navBack() async {
    NavigationUtils.pop(context, result: bloc.selectedFoods.values.toList());
  }

  @override
  void initState() {
    super.initState();
    searchTextController.text = "";
    bloc.init(widget.selectedItems);
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
          StreamBuilder<bool>(
            stream: bloc.searchingResult,
            initialData: true,
            builder: (ctx, searchingSnapshot) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  title: !searchingSnapshot.data
                      ? TXTextWidget(
                          text: "Buscar...",
                          color: R.color.gray,
                          size: 16,
                        )
                      : TextFormField(
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 0)),
                          autofocus: true,
                          controller: searchTextController,
                          onChanged: (value) {
                            bloc.currentQuery = value;
                            searchMarkTime = DateTime.now();
                            Future.delayed(Duration(milliseconds: 500), (){
                              final dif = DateTime.now().difference(searchMarkTime);
                              if(dif.inMilliseconds > 500)
                                bloc.loadFoods(true, false);
                            });
                          },
                          onFieldSubmitted: (value) {
//                            bloc.search(value);
                          },
                        ),
                  leading: TXIconButtonWidget(
                    icon: Icon(
                      Icons.arrow_back,
                      color: R.color.gray,
                    ),
                    onPressed: () {
                      _navBack();
                    },
                  ),
                  actions: <Widget>[
                    TXIconButtonWidget(
                      icon: Icon(
                        searchingSnapshot.data ? Icons.close : Icons.search,
                        color: R.color.gray,
                      ),
                      onPressed: () {
                        if (searchingSnapshot.data) {
                          searchTextController.text = "";
//                          bloc.search("");
                        }
                        bloc.setSearching = !searchingSnapshot.data;
                      },
                    )
                  ],
                ),
                body: Container(
                  child: StreamBuilder<List<FoodModel>>(
                    stream: bloc.searchResult,
                    initialData: [],
                    builder: (ctx, searchResultSnapshot) {
                      return NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification.metrics.pixels >
                              _scrollController.position.maxScrollExtent -
                                  300) {
                            if (!bloc.isLoadingMore && bloc.hasMore)
                              bloc.loadFoods(false, false);
                          }
                          return true;
                        },
                        child: TXGestureHideKeyBoard(
                          child: ListView.builder(
                              controller: _scrollController,
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.only(top: 5, bottom: 30),
                              itemCount: searchResultSnapshot.data.length,
                              itemBuilder: (context, index) {
                                final model = searchResultSnapshot.data[index];
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
                                    height: 40,
                                    width: 40,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 5),
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
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          TXLoadingWidget(
            loadingStream: bloc.isLoadingStream,
          ),
        ],
      ),
    );
  }
}
