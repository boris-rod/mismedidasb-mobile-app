import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/habit/habit_page.dart';
import 'package:mismedidasb/ui/home/home_bloc.dart';
import 'package:mismedidasb/ui/measure_health/measure_health_page.dart';
import 'package:mismedidasb/ui/measure_value/measure_value_page.dart';
import 'package:mismedidasb/ui/measure_wellness/measure_wellness_page.dart';

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
          onPressed: () {
            Fluttertoast.showToast(
                msg: "Ir a la vista de Ajustes",
                toastLength: Toast.LENGTH_LONG);
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
                  icon: Icons.thumb_up,
                  title: R.string.myMeasureHealth,
                  onTap: () {
                    NavigationUtils.push(context, MeasureHealthPage());
                  }),
              _getHomeButton(
                  context: context,
                  icon: Icons.videogame_asset,
                  title: R.string.myMeasureValues,
                  onTap: () {
                    NavigationUtils.push(context, MeasureValuePage());
                  }),
              _getHomeButton(
                  context: context,
                  icon: Icons.local_florist,
                  title: R.string.myMeasureWellness,
                  onTap: () {
                    NavigationUtils.push(context, MeasureWellnessPage());
                  }),
              _getHomeButton(
                  context: context,
                  icon: Icons.local_offer,
                  title: R.string.foodDishes,
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: "Ir a la vista de Platos",
                        toastLength: Toast.LENGTH_LONG);
                  }),
              _getHomeButton(
                  context: context,
                  icon: Icons.bubble_chart,
                  title: R.string.healthHabits,
                  onTap: () {
                    NavigationUtils.push(context, HabitPage());
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
      {BuildContext context, IconData icon, String title, Function onTap}) {
    return Container(
      padding: EdgeInsets.all(20),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: R.color.primary_color, width: .5),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: R.color.primary_color,
                size: 60,
              ),
              SizedBox(
                height: 10,
              ),
              TXTextWidget(
                text: title,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
