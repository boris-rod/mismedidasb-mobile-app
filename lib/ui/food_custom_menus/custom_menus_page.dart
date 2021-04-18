

import 'package:flutter/cupertino.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_navigator_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/food_custom_menus/custom_menus_bloc.dart';

class CustomMenusPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => CustomMenusState();
}

class CustomMenusState extends StateWithBloC<CustomMenusPage, CustomMenusBloC> {

  @override
  void initState() {
    super.initState();
    bloc.initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: [
        TXMainAppBarWidget(
          title: "Menus",
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
          body: Container(),
        ),
        TXLoadingWidget(loadingStream: bloc.isLoadingStream),
      ],
    );
  }

}