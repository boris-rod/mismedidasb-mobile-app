import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/domain/answer/answer_model.dart';
import 'package:mismedidasb/domain/health_concept/health_concept.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/domain/question/question_model.dart';
import 'package:mismedidasb/domain/single_selection_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_background_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_blur_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_result_info.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottomsheet_selector_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_box_cell_data_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_buttons_paginate_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_dialog_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_custom_action_bar.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_navigator_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/measure_health/health_measure_result_model.dart';
import 'package:mismedidasb/ui/measure_health/measure_health_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MeasureHealthPage extends StatefulWidget {
  final HealthConceptModel conceptModel;

  const MeasureHealthPage({Key key, this.conceptModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MeasureHealthState();
}

class _MeasureHealthState
    extends StateWithBloC<MeasureHealthPage, MeasureHealthBloC> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: R.color.health_color));
    bloc.pageResult.listen((onData) {
      pageController.animateToPage(onData,
          duration: Duration(milliseconds: 300), curve: Curves.linear);
    });
    bloc.pollSaveResult.listen((onData) {
      if (onData is String && onData.isNotEmpty) {
        showTXModalBottomSheet(
            context: context,
            builder: (ctx) {
              return TXBottomResultInfo(
                content: onData,
              );
            });
      }
    });
    bloc.loadPolls(widget.conceptModel.id);
  }

  @override
  Widget buildWidget(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        TXCustomActionBar(
          actionBarColor: R.color.health_color,
          body: StreamBuilder<List<PollModel>>(
            stream: bloc.pollsResult,
            initialData: [],
            builder: (ctx, snapshot) {
              return Stack(
                children: <Widget>[
                  Positioned(
                    top : 0,
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
                                    return _getPageView(context, model, index);
                                  },
                                  itemCount: snapshot.data.length,
                                ),
                                constraints: BoxConstraints(
                                    maxWidth:
                                        math.min(300, screenWidth * 90 / 100)),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      math.min(300, screenWidth * 90 / 100)),
                              child: TXTextWidget(
                                textAlign: TextAlign.center,
                                text: snapshot.data.isNotEmpty
                                    ? snapshot.data[bloc.currentPage - 1]
                                        .bottomTip()
                                    : "",
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
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
                              nextTitle: snapshot.data.length > bloc.currentPage
                                  ? R.string.next
                                  : R.string.update,
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
        )
      ],
    );
  }

  Widget _getPageView(BuildContext context, PollModel model, int pageIndex) {
    return TXBlurWidget(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _getQuestions(context, pageIndex, model),
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
      final bool isHeightQuestion = question.order == 3;
      if (isPersonalDataPoll &&
          isHeightQuestion &&
          question.selectedAnswerId <= 0) {
        final AnswerModel defH =
            question.answers.firstWhere((a) => a.title == "150", orElse: () {
          return null;
        });
        question.selectedAnswerId = defH?.id ?? question.selectedAnswerId;
      }
      final w = TXBottomSheetSelectorWidget(
//        useDatePicker: pollIndex == 0 && i == 0,
        boxAnswerWidth: pollIndex == 0 ? 130 : 270,
        list: question.convertAnswersToSelectionModel(),
        onItemSelected: (value) {
          bloc.setAnswerValue(pollIndex, i, value.id);
        },
        title: "${question.title}:",
        initialId: question.selectedAnswerId,
      );
      list.add(w);
    }

    return list;
  }
}
