import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_buttons_paginate_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_custom_action_bar.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_navigator_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/measure_value/measure_value_bloc.dart';
import 'package:mismedidasb/ui/measure_value/measure_value_model.dart';

class MeasureValuePage extends StatefulWidget {
  final HealthConceptModel conceptModel;

  const MeasureValuePage({Key key, this.conceptModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MeasureValueState();
}

class _MeasureValueState
    extends StateWithBloC<MeasureValuePage, MeasureValueBloC> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: R.color.values_color));
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
    return Stack(
      children: <Widget>[
        TXCustomActionBar(
          actionBarColor: R.color.values_color,
          body: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: -50,
                right: 0,
                bottom: 0,
                child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image:
                          ExactAssetImage(R.image.values_home_blur),
                        ))),
              ),
              Column(
                children: <Widget>[
                  Image.asset(
                    R.image.values_title,
                    width: 300,
                  ),
                  Expanded(
                    child: StreamBuilder<PollModel>(
                      stream: bloc.pollsResult,
                      initialData: null,
                      builder: (ctx, snapshot) {
                        return (snapshot == null || snapshot.data == null)
                            ? Container()
                            : (snapshot.data.id == -1)
                            ? Container(
                          height: double.infinity,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: TXTextWidget(
                            text: R.string.noPollData,
                            color: Colors.white,
                          ),
                        )
                            : Column(
                          children: <Widget>[
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              padding:
                              EdgeInsets.symmetric(horizontal: 20),
                              child: TXTextWidget(
                                  color: Colors.white,
                                  textAlign: TextAlign.justify,
                                  text: snapshot.data.topTip()),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: PageView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (ctx, index) {
                                  final model =
                                  snapshot.data.questions[index];
                                  return _getPageView(ctx, model, index);
                                },
                                controller: pageController,
                                itemCount: snapshot.data.questions.length,
                              ),
                            ),
                            StreamBuilder<int>(
                              stream: bloc.pageResult,
                              initialData: bloc.currentPage,
                              builder: (ctx, snapshotPage) {
                                return TXButtonPaginateWidget(
                                  page: bloc.currentPage,
                                  total: snapshot.data.questions.length,
                                  onNext: () {
                                    snapshot.data.questions.length >
                                        bloc.currentPage
                                        ? bloc.changePage(1)
                                        : bloc.saveMeasures();
                                  },
                                  onPrevious: bloc.currentPage > 1
                                      ? () {
                                    bloc.changePage(-1);
                                  }
                                      : null,
                                  nextTitle:
                                  snapshot.data.questions.length >
                                      bloc.currentPage
                                      ? R.string.next
                                      : R.string.save.toLowerCase(),
                                  previousTitle: R.string.previous,
                                );
                              },
                            )
                          ],
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        TXLoadingWidget(
          loadingStream: bloc.isLoadingStream,
        )
      ],
    );
  }

  Widget _getPageView(
      BuildContext context, QuestionModel question, int pageIndex) {
    question.selectedAnswerId = question.lastAnswer != 0
        ? question.lastAnswer
        : question.selectedAnswerId;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5)
                    .copyWith(top: 25, left: 10),
                child: TXBlurWidget(
                  child: Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(minHeight: 40),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5)
                        .copyWith(
                            left: pageIndex + 1 > 1
                                ? (pageIndex + 1 < 10 ? 25 : 45)
                                : 15),
                    child: TXTextWidget(
                      text: question.title,
                      textAlign: TextAlign.justify,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  child: TXTextWidget(
                    text: "${pageIndex + 1}",
                    color: Colors.white,
                    size: 50,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
            ],
          ),
          TXBottomSheetSelectorWidget(
            list: question.convertAnswersToSelectionModel(),
            onItemSelected: (value) {
              bloc.setAnswerValue(pageIndex, value.id);
            },
            title: "${R.string.answer}:",
            titleFont: FontWeight.w500,
            initialId: question.selectedAnswerId,
          ),
        ],
      ),
    );
  }
}
