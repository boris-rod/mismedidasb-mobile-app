import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_network_image.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/food_craving/food_craving_page.dart';
import 'package:mismedidasb/ui/food_dish/food_dish_page.dart';
import 'package:mismedidasb/ui/habit/habit_page.dart';
import 'package:mismedidasb/ui/home/home_bloc.dart';
import 'package:mismedidasb/ui/login/login_page.dart';
import 'package:mismedidasb/ui/measure_health/measure_health_page.dart';
import 'package:mismedidasb/ui/measure_value/measure_value_page.dart';
import 'package:mismedidasb/ui/measure_wellness/measure_wellness_page.dart';
import 'package:mismedidasb/ui/profile/profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends StateWithBloC<HomePage, HomeBloC> {
  @override
  void initState() {
    super.initState();
    bloc.loadHomeData();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return TXMainAppBarWidget(
      title: R.string.appName,
      leading: TXIconButtonWidget(
        icon: Image.asset(
          R.image.logo,
        ),
      ),
      actions: <Widget>[
        TXIconButtonWidget(
          icon: Icon(Icons.settings),
          onPressed: () async {
            final res = await NavigationUtils.push(context, ProfilePage());
            if (res is profileAction) {
              if (res == profileAction.logout) {
                NavigationUtils.pushReplacement(context, LoginPage());
              }
            }
          },
        )
      ],
      body: Stack(
        children: <Widget>[
          GridView.count(
            padding: EdgeInsets.symmetric(vertical: 10),
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 2
                    : 4,
            children: <Widget>[
              _getHomeButton(
                  context: context,
                  imgH: 100,
                  imgW: 100,
                  resDir: R.image.health_home,
                  title: R.string.myMeasureHealth,
                  onTap: () {
                    NavigationUtils.push(context, MeasureHealthPage());
                  }),
              _getHomeButton(
                  context: context,
                  imgH: 100,
                  imgW: 100,
                  resDir: R.image.values_home,
                  title: R.string.myMeasureValues,
                  onTap: () {
                    NavigationUtils.push(context, MeasureValuePage());
                  }),
              _getHomeButton(
                  context: context,
                  imgH: 100,
                  imgW: 100,
                  resDir: R.image.wellness_home,
                  title: R.string.myMeasureWellness,
                  onTap: () {
                    NavigationUtils.push(context, MeasureWellnessPage());
                  }),
              _getHomeButton(
                  context: context,
                  resDir: R.image.dishes_home,
                  title: R.string.foodDishes,
                  imgH: 110,
                  imgW: 110,
                  onTap: () async {
                    final res = await bloc.canNavigateToFoodPage();
                    if (res)
                      NavigationUtils.push(context, FoodDishPage());
                    else
                      Fluttertoast.showToast(
                          msg:
                              "Debe completar el cuestionario de Medidas de Salud");
                  }),
              _getHomeButton(
                  context: context,
                  resDir: R.image.habits_home,
                  imgH: 100,
                  imgW: 100,
                  title: R.string.healthHabits,
                  onTap: () {
                    NavigationUtils.push(context, HabitPage());
                  }),
              _getHomeButton(
                  context: context,
                  resDir: R.image.food_craving_home,
                  title: R.string.foodCraving,
                  imgH: 110,
                  imgW: 110,
                  onTap: () {
                    NavigationUtils.push(context, FoodCravingPage());
                  }),
            ],
          ),
          TXLoadingWidget(
            loadingStream: bloc.isLoadingStream,
          )
        ],
      ),
    );
  }

  Widget _getHomeButton(
      {BuildContext context, String resDir, String title, Function onTap, double imgH = 120, double imgW = 120}) {
    return Container(
      padding: EdgeInsets.all(10),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: R.color.primary_color, width: .5),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            children: <Widget>[
              Container(
                height: imgH,
                width: imgW,
                child: Image.asset(
                  resDir,
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: TXTextWidget(
                  text: title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
