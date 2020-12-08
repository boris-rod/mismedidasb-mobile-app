import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mismedidasb/app_bloc.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/health_concept/health_concept.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/enums.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_action_bar_menu_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_result_info.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_checkbox_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_dialog_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_custom_action_bar.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_network_image.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_show_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_video_intro_widet.dart';
import 'package:mismedidasb/ui/food_craving/food_craving_page.dart';
import 'package:mismedidasb/ui/food_dish/food_dish_page.dart';
import 'package:mismedidasb/ui/habit/habit_page.dart';
import 'package:mismedidasb/ui/home/hole_puncher.dart';
import 'package:mismedidasb/ui/home/home_bloc.dart';
import 'package:mismedidasb/ui/legacy/legacy_page.dart';
import 'package:mismedidasb/ui/login/login_page.dart';
import 'package:mismedidasb/ui/measure_health/measure_health_page.dart';
import 'package:mismedidasb/ui/measure_value/measure_value_page.dart';
import 'package:mismedidasb/ui/measure_wellness/measure_wellness_page.dart';
import 'package:mismedidasb/ui/poll_notification/poll_notification_page.dart';
import 'package:mismedidasb/ui/profile/profile_page.dart';
import 'package:mismedidasb/ui/settings/settings_page.dart';
import 'package:mismedidasb/utils/file_manager.dart';
import 'package:mismedidasb/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends StateWithBloC<HomePage, HomeBloC> {
  final _keyHome = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Utils.setStatusBarColor(R.color.primary_dark_color);

    bloc.loadHomeData();
//    bloc.launchNotiPollResult.listen((onData) {
//      if (onData) {
//        NavigationUtils.push(context, PollNotificationPage());
//      }
//    });

    onPollNotificationLaunch.listen((value) {
      NavigationUtils.push(context, PollNotificationPage());
    });
  }

  @override
  void dispose() {
//    didReceiveLocalNotificationSubject.close();
//    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final totalRowCount = bloc.getHomeCountPerRow(screenW);
    return Stack(
      children: <Widget>[
        TXCustomActionBar(
          scaffoldKey: _keyHome,
          showLeading: false,
          actionBarColor: R.color.home_color,
          actions: [
            TXActionBarMenuWidget(
              icon: Image.asset(
                R.image.settings,
                height: 35,
                width: 35,
              ),
              onTap: () async {
//                  NavigationUtils.push(context, PollNotificationPage());
                if (!bloc.termsAccepted) {
                  final res = await NavigationUtils.push(
                      context,
                      LegacyPage(
                        contentType: 1,
                        termsCondAccepted: false,
                      ));
                  if (res ?? false) {
                    bloc.termsAccepted = true;
                  }
                } else if (bloc.needUpdateVersion) {
                  _showUpdateApp(context: context);
                } else {
                  final res =
                  await NavigationUtils.push(context, ProfilePage());
                  if (res is SettingAction) {
                    if (res == SettingAction.logout ||
                        res == SettingAction.removeAccount) {
                      NavigationUtils.pushReplacement(context, LoginPage());
                    } else if (res == SettingAction.languageCodeChanged) {
                      bloc.loadHomeData();
                    }
                  }
                }
              },
            )
          ],
          body: Container(
            color: R.color.home_color,
            child: Column(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    R.image.logo_planifive,
                    height: 120,
                  ),
                ),
                Expanded(
                  child: Container(
                    child: StreamBuilder<List<HealthConceptModel>>(
                      stream: bloc.conceptResult,
                      initialData: [],
                      builder: (ctx, snapshot) {
                        return GridView.count(
                          physics: BouncingScrollPhysics(),
                          crossAxisCount: totalRowCount,
                          children: _getHomeWidgets(
                              snapshot.data, screenW, totalRowCount),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
//          Container(child: HolePuncher()),
//          Positioned(
//            bottom: 0,
//            left: 0,
//            child: Container(
//                height: 30,
//                child: TXTextLinkWidget(
//                  title: "Saltar",
//                  onTap: () {
//                    Fluttertoast.showToast(msg: "Saltar");
//                  },
//                )),
//          ),
//          Positioned(
//            bottom: 0,
//            right: 0,
//            child: Container(
//              height: 30,
//              child: TXButtonWidget(
//                title: "Entiendo",
//                onPressed: () {
//                  Fluttertoast.showToast(msg: "Entiendo");
//                },
//              ),
//            ),
//          ),
//          Positioned(
//            bottom: 10,
//            left: 150,
//            child: Row(
//              children: <Widget>[
//                CircleAvatar(
//                  radius: 3,
//                  backgroundColor: R.color.gray_light,
//                ),
//                SizedBox(width: 3,),
//                CircleAvatar(
//                  radius: 3,
//                  backgroundColor: R.color.gray_dark,
//                ),
//                SizedBox(width: 3,),
//                CircleAvatar(
//                  radius: 3,
//                  backgroundColor: R.color.gray_dark,
//                )
//              ],
//            ),
//          ),
        TXLoadingWidget(
          loadingStream: bloc.isLoadingStream,
        ),
        StreamBuilder<bool>(
            stream: bloc.showFirstTimeResult,
            initialData: false,
            builder: (context, snapshotShow) {
              return snapshotShow.data
                  ? TXVideoIntroWidget(
                title: R.string.planiIntroHelper,
                onSeeVideo: () {
                  bloc.setNotFirstTime();
                  launch(Endpoint.planiIntroVideo);
//                          FileManager.playVideo("main_menu.mp4");
                },
                onSkip: () {
                  bloc.setNotFirstTime();
                },
              )
                  : Container();
            }),
//          Container(
//            color: R.color.discover_background,
//          ),
      ],
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
          if (!bloc.termsAccepted) {
            final res = await NavigationUtils.push(
                context,
                LegacyPage(
                  contentType: 1,
                  termsCondAccepted: false,
                ));
            if (res ?? false) {
              bloc.termsAccepted = true;
            }
          } else {
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
              } else {
                if(bloc.needUpdateVersion)
                  _showUpdateApp(context: context);
                else{
                  final res = await NavigationUtils.push(context, page);
                  if (res is PollResponseModel && res.reward.points > 0) {
                    if (page is MeasureHealthPage) {
                      _keyHome.currentState.showSnackBar(showSnackBar(
                          title: "${R.string.congratulations} ${bloc.userName}",
                          content:
                          "${R.string.rewardGain} ${res.reward.points} ${R.string.rewardGainPoints}"));
                    } else if (page is MeasureValuePage) {
                      _keyHome.currentState.showSnackBar(showSnackBar(
                          title: "${R.string.congratulations} ${bloc.userName}",
                          content:
                          "${R.string.rewardGain} ${res.reward.points} ${R.string.rewardGainPoints}"));
                    } else if (page is MeasureWellnessPage) {
                      _keyHome.currentState.showSnackBar(showSnackBar(
                          title: "${R.string.congratulations} ${bloc.userName}",
                          content:
                          "${R.string.rewardGain} ${res.reward.points} ${R.string.rewardGainPoints}"));
                    }
                  }
                  Utils.setStatusBarColor(R.color.primary_dark_color);
                }
              }
            }
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
      padding: EdgeInsets.only(top: 10),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        onTap: onTap,
        child: Column(
          children: <Widget>[
            Image.asset(
              bloc.getImage(model.codeName),
              width: 100,
              height: 100,
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Image.asset(bloc.getImageTitle(
                model.codeName,
              )),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateApp({BuildContext context}) {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => TXCupertinoDialogWidget(
        title: "Actualización requerida",
        contentWidget: RichText(
          text: TextSpan(
              style: TextStyle(color: R.color.gray_darkest),
              text: "La versión actual que estás usando es ",
              children: [
                TextSpan(
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    text: "${bloc.currentVersion}. "),
                TextSpan(
                    style: TextStyle(color: R.color.gray_darkest),
                    text:
                        "Para poder seguir usando Planifive necesitas actualizar a la versión "),
                TextSpan(
                    style: TextStyle(
                        color: R.color.accent_color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    text: "${bloc.nextVersion}."),
              ]),
        ),
        okText: "Actualizar",
        onOK: () async{
          Navigator.pop(context);
//          LaunchReview.launch(
//              androidAppId: "com.metriri.mismedidasb", iOSAppId: "1506658015");
          await launch(Platform.isIOS ? "https://itunes.apple.com/us/app/sutiawbapp/id1506658015?ls=1&mt=8" :
          "https://play.google.com/store/apps/details?id=com.metriri.mismedidasb");
        },
        onCancel: () {
          Navigator.pop(context, R.string.cancel);
        },
      ),
    );
  }
}
