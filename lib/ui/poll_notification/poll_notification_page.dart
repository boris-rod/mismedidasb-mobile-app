import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/domain/question/question_model.dart';
import 'package:mismedidasb/domain/single_selection_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_blur_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottomsheet_selector_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_box_cell_data_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_box_cellcheck_data_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_buttons_paginate_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_custom_action_bar.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/poll_notification/poll_notification_bloc.dart';
import 'dart:math' as math;

class PollNotificationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PollNotificationState();
}

class _PollNotificationState
    extends StateWithBloC<PollNotificationPage, PollNotificationBloC> {
  final PageController pageController = PageController();
  final _keyPollNotifications = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    bloc.pageResult.listen((onData) async {
      if (onData == (await bloc.soloQuestionsResult.first).length)
        NavigationUtils.pop(context);
      else {
        pageController.animateToPage(onData,
            duration: Duration(milliseconds: 300), curve: Curves.linear);
      }
    });

    bloc.rewardResult.listen((onData) {
      _keyPollNotifications.currentState.showSnackBar(getSnackBarWidget(
          "Felicidades ha obtenido una recompensa de ${onData.reward.points} puntos."));
    });
    bloc.loadData();
  }

  @override
  Widget buildWidget(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        TXCustomActionBar(
          scaffoldKey: _keyPollNotifications,
          actionBarColor: R.color.health_color,
          leading: TXIconButtonWidget(
            icon: Icon(
              Icons.cancel,
              color: Colors.yellow,
              size: 35,
            ),
            onPressed: () {
              NavigationUtils.pop(context);
            },
          ),
          body: StreamBuilder<List<SoloQuestionModel>>(
            stream: bloc.soloQuestionsResult,
            initialData: [],
            builder: (ctx, snapshot) {
              return Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: -20,
                    right: 0,
                    bottom: 0,
                    child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                      fit: BoxFit.contain,
                      image: ExactAssetImage(R.image.health_home_blur),
                    ))),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        width: 300,
                        height: 90,
                        child: Stack(
                          children: <Widget>[
                            Image.asset(
                              R.image.icon_title,
                              width: 300,
                            ),
                            Container(
                              child: Container(
                                child: TXTextWidget(
                                  text: "Cuestionarios",
                                  fontWeight: FontWeight.w900,
                                  size: 18,
                                  maxLines: 1,
                                ),
                                width: 250,
                                alignment: Alignment.bottomCenter,
                                height: 45,
                              ),
                              alignment: Alignment.topCenter,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: PageView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          controller: pageController,
                          itemBuilder: (ctx, index) {
                            final model = snapshot.data[index];
                            return _getPageView(context, model, index);
                          },
                          itemCount: snapshot.data.length,
                        ),
                        constraints: BoxConstraints(
                            maxWidth: math.min(300, screenWidth * 90 / 100)),
                        height: 200,
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: StreamBuilder<int>(
                          stream: bloc.pageResult,
                          initialData: bloc.currentPageIndex,
                          builder: (ctx, snapshotPage) {
                            return TXButtonPaginateWidget(
                              page: bloc.currentPageIndex + 1,
                              showBackNavigation: false,
                              total: snapshot.data.length,
                              onNext: () {
                                bloc.answer();
                              },
//                              onPrevious: bloc.currentPage > 1
//                                  ? () {
////                                      bloc.changePage(-1);
//                                    }
//                                  : null,
                              nextTitle: "responder",
//                              previousTitle: R.string.previous,
                            );
                          },
                        ),
                      )
                    ],
                  )
                ],
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

  Widget _getPageView(
      BuildContext context, SoloQuestionModel model, int pageIndex) {
    return TXBlurWidget(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            model.code == 'SQ-1'
                ? _geFoodPlanReached(context, pageIndex)
                : model.code == 'SQ-2'
                    ? _getFeelingTodayView(context, pageIndex)
                    : model.code == 'SQ-3'
                        ? _getPlanExerciseTomorrow(context, pageIndex)
                        : model.code == 'SQ-4'
                            ? _getExercisePlanReached(context, pageIndex)
                            : Container()
          ],
        ),
      ),
    );
  }

  Widget _getPlanExerciseTomorrow(BuildContext context, int pageIndex) {
    return StreamBuilder<SoloQuestionModel>(
        stream: bloc.exercisePlanTomorrowResult,
        builder: (context, snapshot) {
          if (snapshot.data == null) return Container();

          final exerciseAnswer = snapshot.data.soloAnswers
              .firstWhere((element) => element.code == 'SQ-3-SA-1', orElse: () {
            return null;
          });
          if (exerciseAnswer != null) bloc.timeTitle = exerciseAnswer.title;

          final exerciseAnswerDont = snapshot.data.soloAnswers
              .firstWhere((element) => element.code == 'SQ-3-SA-2', orElse: () {
            return null;
          });

          return Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: TXTextWidget(
                  text: snapshot.data.title,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TXBoxCellCheckDataWidget(
                value: bloc.timeMarked ? bloc.exerciseTimeStr : bloc.timeTitle,
                checked: bloc.timeMarked,
                onTap: () async {
                  final TimeOfDay picked = await showTimePicker(
                    context: context,
                    initialTime: bloc.exerciseTime,
                  );
                  if (picked != null && picked != bloc.exerciseTime) {
                    bloc.timeMarked = true;
                    bloc.exerciseTime = picked;
                    setState(() {});
                    print(picked.toString());
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              TXBoxCellCheckDataWidget(
                value: exerciseAnswerDont.title,
                checked: !bloc.timeMarked,
                onTap: () {
                  bloc.timeMarked = false;
                  setState(() {});
                },
              )
            ],
          );
        });
  }

  Widget _getFeelingTodayView(BuildContext context, int pageIndex) {
    return StreamBuilder<SoloQuestionModel>(
        stream: bloc.feelingTodayResult,
        builder: (context, snapshot) {
          if (snapshot.data == null) return Container();
          return Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: TXTextWidget(
                  text: snapshot.data.title,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 5),
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(width: 4, color: Colors.black),
                    color: Colors.white),
                child: Center(
                  child: RatingBar(
                    unratedColor: Colors.grey[300],
                    initialRating: 3,
                    tapOnlyMode: true,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return Icon(
                            Icons.sentiment_very_dissatisfied,
                            color: Colors.red,
                          );
                        case 1:
                          return Icon(
                            Icons.sentiment_dissatisfied,
                            color: Colors.redAccent,
                          );
                        case 2:
                          return Icon(
                            Icons.sentiment_neutral,
                            color: Colors.amber,
                          );
                        case 3:
                          return Icon(
                            Icons.sentiment_satisfied,
                            color: Colors.lightGreen,
                          );
                        case 4:
                          return Icon(
                            Icons.sentiment_very_satisfied,
                            color: Colors.green,
                          );
                        default:
                          return Container();
                      }
                    },
                    onRatingUpdate: (rating) {
                      setState(() {
//          _rating = rating;
                      });
                    },
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget _getExercisePlanReached(BuildContext context, int pollIndex) {
    return StreamBuilder<SoloQuestionModel>(
        stream: bloc.exercisePlanReachedResult,
        builder: (context, snapshot) {
          if (snapshot.data == null) return Container();
          final answer = snapshot.data.soloAnswerModelSelected;
          return TXBottomSheetSelectorWidget(
            boxAnswerWidth: 270,
            list: snapshot.data.convertAnswersToSelectionModel(),
            onItemSelected: (value) {
              SoloAnswerModel selectedAnswer = snapshot.data.soloAnswers
                  .firstWhere((element) => element.id == value.id);
              bloc.saveExercisePlanReached(selectedAnswer, pollIndex);
            },
            title: "${snapshot.data.title}",
            initialId: answer.id,
          );
        });
  }

  Widget _geFoodPlanReached(BuildContext context, int pollIndex) {
    return StreamBuilder<SoloQuestionModel>(
        stream: bloc.foodPlanReachedResult,
        builder: (context, snapshot) {
          if (snapshot.data == null) return Container();
          final answer = snapshot.data.soloAnswerModelSelected;
          return TXBottomSheetSelectorWidget(
            boxAnswerWidth: 270,
            list: snapshot.data.convertAnswersToSelectionModel(),
            onItemSelected: (value) {
              SoloAnswerModel selectedAnswer = snapshot.data.soloAnswers
                  .firstWhere((element) => element.id == value.id);
              bloc.saveFoodPlanReached(selectedAnswer, pollIndex);
            },
            title: snapshot.data.title,
            initialId: answer.id,
          );
        });
  }

  SnackBar getSnackBarWidget(String message) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 3),
      content: Row(
        children: <Widget>[
          Container(
            child: Image.asset(
              R.image.logo,
              width: 60,
              height: 60,
            ),
          ),
          Expanded(
              child: TXTextWidget(
            text: message,
          ))
        ],
      ),
    );
    return snackBar;
  }
}
