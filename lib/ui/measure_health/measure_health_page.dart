import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'dart:math' as math;
import 'package:mismedidasb/domain/answer/answer_model.dart';
import 'package:mismedidasb/domain/health_concept/health_concept.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/enums.dart';
import 'package:mismedidasb/global_regex.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_blur_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottomsheet_selector_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_buttons_paginate_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_custom_action_bar.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_show_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_video_intro_widet.dart';
import 'package:mismedidasb/ui/measure_health/measure_health_bloc.dart';
import 'package:mismedidasb/ui/references/references_page.dart';
import 'package:mismedidasb/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class MeasureHealthPage extends StatefulWidget {
  final HealthConceptModel conceptModel;

  const MeasureHealthPage({Key key, this.conceptModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MeasureHealthState();
}

class _MeasureHealthState
    extends StateWithBloC<MeasureHealthPage, MeasureHealthBloC> {
  final PageController pageController = PageController();
  final _keyPollHealthy = new GlobalKey<ScaffoldState>();

  _navBack() {
    NavigationUtils.pop(context, result: bloc.pollResponseModel);
  }

  @override
  void initState() {
    super.initState();
    Utils.setStatusBarColor(R.color.health_color);

    bloc.pageResult.listen((onData) {
      pageController.animateToPage(onData,
          duration: Duration(milliseconds: 300), curve: Curves.linear);
    });
    bloc.pollSaveResult.listen((onData) {
      if (onData is PollResponseModel) {
        showAlertDialogForPollsAnswerResult(
            context: context,
            content: onData.result,
            title: "${R.string.thanks} ${bloc.userName}",
            onOk: () async {
              await NavigationUtils.pop(context);
              if (bloc.isFirstTime)
                bloc.launchFirstTime();
              else
                NavigationUtils.pop(context, result: onData);
            });
//        showTXModalBottomSheet(
//            context: context,
//            builder: (ctx) {
//              return TXBottomResultInfo(
//                content: onData,
//              );
//            });
      }
    });
    bloc.rewardResult.listen((onData) {
      _keyPollHealthy.currentState.showSnackBar(showSnackBar(
          title:
              "Felicidades ha obtenido una recompensa de ${onData.reward.points} puntos."));
    });

    bloc.loadPolls(widget.conceptModel.id);
  }

  @override
  Widget buildWidget(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        _navBack();
        return false;
      },
      child: Stack(
        children: <Widget>[
          TXCustomActionBar(
            scaffoldKey: _keyPollHealthy,
            actionBarColor: R.color.health_color,
            onLeadingTap: () {
              _navBack();
            },
            body: StreamBuilder<List<PollModel>>(
              stream: bloc.pollsResult,
              initialData: [],
              builder: (ctx, snapshot) {
                return Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: -40,
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
                        Image.asset(
                          R.image.health_title,
                          width: 300,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: PageView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    controller: pageController,
                                    itemBuilder: (ctx, index) {
                                      final model = snapshot.data[index];
                                      return _getPageView(
                                          context, model, index);
                                    },
                                    itemCount: snapshot.data.length,
                                  ),
                                  constraints: BoxConstraints(
                                      maxWidth: math.min(
                                          300, screenWidth * 90 / 100)),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        math.min(300, screenWidth * 90 / 100)),
                                child: snapshot.data.isNotEmpty
                                    ? Html(
                                        data:
                                            "<div>${snapshot.data[bloc.currentPage - 1].bottomTip()} <a href='#'><b>Referencias</b></a></div>",
                                        onLinkTap: (link) {
                                          NavigationUtils.push(
                                              context, ReferencesPage());
                                        },
                                        style: {
                                          "div": Style(
                                              color: Colors.white,
                                              textAlign: TextAlign.center,
                                              fontWeight: FontWeight.w500,
                                              fontSize: FontSize(15)),
                                          "a": Style(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500)
                                        },
                                      )
                                    : Container(),

                                // TXTextWidget(
                                //   textAlign: TextAlign.center,
                                //   text: snapshot.data.isNotEmpty
                                //       ? snapshot.data[bloc.currentPage - 1]
                                //           .bottomTip()
                                //       : "",
                                //   color: Colors.white,
                                // ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          child: StreamBuilder<int>(
                            stream: bloc.pageResult,
                            initialData: bloc.currentPage,
                            builder: (ctx, snapshotPage) {
                              return TXButtonPaginateWidget(
                                page: bloc.currentPage,
                                total: snapshot.data.length,
                                onNext: () {
                                  snapshot.data.length > bloc.currentPage
                                      ? bloc.changePage(1)
                                      : bloc.saveMeasures();
                                },
                                onPrevious: bloc.currentPage > 1
                                    ? () {
                                        bloc.changePage(-1);
                                      }
                                    : null,
                                nextTitle:
                                    snapshot.data.length > bloc.currentPage
                                        ? R.string.next
                                        : R.string.answerPoll,
                                previousTitle: R.string.previous,
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
          ),
          StreamBuilder<bool>(
              stream: bloc.showFirstTimeResult,
              initialData: false,
              builder: (context, snapshotShow) {
                return snapshotShow.data
                    ? TXVideoIntroWidget(
                        title: R.string.planiHelper,
                        onSeeVideo: () async {
                          await bloc.setNotFirstTime();
                          launch(Platform.isAndroid ? Endpoint.whoIsPlaniVideo: Endpoint.metririWeb);
//                          FileManager.playVideo("plani.mp4");
                          Future.delayed(Duration(seconds: 2), () {
                            _navBack();
                          });
                        },
                        onSkip: () async {
                          await bloc.setNotFirstTime();
                          _navBack();
                        },
                      )
                    : Container();
              }),
        ],
      ),
    );
  }

  Widget _getPageView(BuildContext context, PollModel model, int pageIndex) {
    return TXBlurWidget(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _getQuestions(context, pageIndex, model),
          ),
        ),
      ),
    );
  }

  List<Widget> _getQuestions(
      BuildContext context, int pollIndex, PollModel pollModel) {
    List<Widget> list = [];
    final bool isPersonalDataPoll = pollModel.order == 1;
    for (int i = 0; i < pollModel.questions.length; i++) {
      final question = pollModel.questions[i];
      question.selectedAnswerId = question.lastAnswer != 0
          ? question.lastAnswer
          : question.selectedAnswerId;
      final bool isWeightQuestion = isPersonalDataPoll && question.order == 2;
      final bool isHeightQuestion = isPersonalDataPoll && question.order == 3;
      if (isHeightQuestion && question.selectedAnswerId <= 0) {
        final AnswerModel defH =
            question.answers.firstWhere((a) => a.title == "150", orElse: () {
          return null;
        });
        question.selectedAnswerId = defH?.id ?? question.selectedAnswerId;
      }
      final w = TXBottomSheetSelectorWidget(
//        useDatePicker: pollIndex == 0 && i == 0,
        boxAnswerWidth: pollIndex == 0 ? 130 : 280,
        list: question.convertAnswersToSelectionModel(
            forFeet: isHeightQuestion &&
                bloc.hUnit == heightUnit.feet.toString().split('.').last,
            forPounds: isWeightQuestion &&
                bloc.wUnit == weightUnit.pound.toString().split('.').last),
        onItemSelected: (value) {
          bloc.setAnswerValue(pollIndex, i, value.id);
        },
        labelWidget: isHeightQuestion || isWeightQuestion
            ? _weightHeightLabelWidget(question.title,
                isHeight: isHeightQuestion)
            : null,
        // title: isHeightQuestion &&
        //         bloc.hUnit == heightUnit.feet.toString().split('.').last
        //     ? "${_subsByFeet(question.title)}"
        //     : isWeightQuestion &&
        //             bloc.wUnit == weightUnit.pound.toString().split('.').last
        //         ? "${_subsByPound(question.title)}"
        //         : "${question.title}:",
        title: "${question.title}:",
        initialId: question.selectedAnswerId,
      );
      list.add(w);
    }

    return list;
  }

  Widget _weightHeightLabelWidget(String text, {bool isHeight = false}) {
    final isSelected = isHeight
        ? [
            bloc.hUnit == heightUnit.centimeter.toString().split('.').last,
            bloc.hUnit == heightUnit.feet.toString().split('.').last
          ]
        : [
            bloc.wUnit == weightUnit.kilogram.toString().split('.').last,
            bloc.wUnit == weightUnit.pound.toString().split('.').last
          ];
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TXTextWidget(
            text: _subsText(text),
            color: Colors.white,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.left,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: ToggleButtons(
            selectedBorderColor: Colors.transparent,
            borderColor: Colors.transparent,
            fillColor: R.color.food_red,
            constraints: BoxConstraints(minHeight: 25, minWidth: 64),
            children: isHeight
                ? [
                    TXTextWidget(
                      text: "cm",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.left,
                    ),
                    TXTextWidget(
                      text: "pies",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.left,
                    )
                  ]
                : [
                    TXTextWidget(
                      text: "kg",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.left,
                    ),
                    TXTextWidget(
                      text: "lb",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.left,
                    )
                  ],
            isSelected: isSelected,
            onPressed: (index) async {
              var result = false;
              if (isHeight)
                result = await bloc.toggleHeight(
                    index == 0 ? heightUnit.centimeter : heightUnit.feet);
              else
                result = await bloc.toggleWeight(
                    index == 0 ? weightUnit.kilogram : weightUnit.pound);
              if (result) setState(() {});
            },
          ),
        ),
      ],
    );
  }

  String _subsText(String text) {
    return text.replaceAll(GlobalRegex.heightWeightUnitIndicatorText, "");
  }

  // String _subsByPound(String text) {
  //   return text.replaceAll(
  //       GlobalRegex.heightWeightUnitIndicatorText, "(${R.string.pounds})");
  // }
  //
  // String _subsByFeet(String text) {
  //   return text.replaceAll(
  //       GlobalRegex.heightWeightUnitIndicatorText, "(${R.string.feet})");
  // }
}
