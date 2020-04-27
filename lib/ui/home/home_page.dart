import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/health_concept/health_concept.dart';
import 'package:mismedidasb/fcm/fcm_background_notification_aware_widget.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_result_info.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
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
    final screenW = MediaQuery.of(context).size.width;
    final totalRowCount = bloc.getHomeCountPerRow(screenW);
    return FCMAwareBody(
      child: Stack(
        children: <Widget>[
          TXMainAppBarWidget(
            title: R.string.appName,
            actions: <Widget>[
              TXIconButtonWidget(
                icon: Icon(Icons.settings),
                onPressed: () async {
                  final res =
                      await NavigationUtils.push(context, ProfilePage());
                  if (res is profileAction) {
                    if (res == profileAction.logout) {
                      NavigationUtils.pushReplacement(context, LoginPage());
                    } else if (res == profileAction.languageCodeChanged) {
                      bloc.loadHomeData();
                    }
                  }
                },
              )
            ],
            body: StreamBuilder<List<HealthConceptModel>>(
              stream: bloc.conceptResult,
              initialData: [],
              builder: (ctx, snapshot) {
                return GridView.count(
                  padding: EdgeInsets.only(top: 20),
                  crossAxisCount: totalRowCount,
                  children:
                      _getHomeWidgets(snapshot.data, screenW, totalRowCount),
                );
              },
            ),
          ),
          TXLoadingWidget(
            loadingStream: bloc.isLoadingStream,
          )
        ],
      ),
    );
  }

  List<Widget> _getHomeWidgets(
      List<HealthConceptModel> modelList, double screenW, int totalRowCount) {
    List<Widget> list = [];
    modelList.forEach((model) {
      final w = Container(
        width: screenW / totalRowCount,
        height: screenW / totalRowCount,
        child: _getHomeButton(model, () async {
          Widget page;
          if (model.codeName == RemoteConstants.concept_health_measure)
            page = MeasureHealthPage(
              conceptModel: model,
            );
          else if (model.codeName == RemoteConstants.concept_values_measure)
            page = MeasureValuePage(
              conceptModel: model,
            );
          else if (model.codeName == RemoteConstants.concept_wellness_measure)
            page = MeasureWellnessPage(
              conceptModel: model,
            );
          else if (model.codeName == RemoteConstants.concept_dishes)
            page = FoodDishPage(
              instructions: model.instructions,
            );
          else if (model.codeName == RemoteConstants.concept_habits)
            page = HabitPage(
              conceptModel: model,
            );
          else if (model.codeName == RemoteConstants.concept_craving)
            page = FoodCravingPage(
              conceptModel: model,
            );
          if (page != null) {
            if (page is FoodDishPage && !(await bloc.canNavigateToDishes())) {
              showTXModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return TXBottomResultInfo(
                      content: R.string.fillHealthPoll,
                      height: 200,
                      title: R.string.foodInstructionsTitle,
                    );
                  });
            } else
              NavigationUtils.push(context, page);
          }
        }),
      );
      list.add(w);
    });
    return list;
  }

  Widget _getHomeButton(
    HealthConceptModel model,
    Function onTap,
  ) {
    return Container(
      padding: EdgeInsets.all(10),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
              color: R.color.gray_light,
              border: Border.all(color: R.color.primary_color, width: .5),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            children: <Widget>[
              Container(
                height: 30,
                width: double.infinity,
                child: TXTextWidget(
                  text: model.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  size: 12,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Container(
                    alignment: Alignment.center,
                    child: TXNetworkImage(
                      width: double.infinity,
                      height: double.infinity,
                      imageUrl: model.image ?? '',
                      placeholderImage: R.image.logo_blue,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
