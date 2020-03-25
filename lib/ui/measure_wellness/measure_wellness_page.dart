import 'package:flutter/material.dart';
import 'package:mismedidasb/domain/health_concept/health_concept.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/domain/question/question_model.dart';
import 'package:mismedidasb/domain/single_selection_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/res/values/colors.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_background_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_result_info.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottomsheet_selector_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_buttons_paginate_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/measure_wellness/measure_wellness_bloc.dart';
import 'package:mismedidasb/ui/measure_wellness/measure_wellness_model.dart';

class MeasureWellnessPage extends StatefulWidget {
  final HealthConceptModel conceptModel;

  const MeasureWellnessPage({Key key, this.conceptModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MeasureWellnessState();
}

class _MeasureWellnessState
    extends StateWithBloC<MeasureWellnessPage, MeasureWellnessBloC> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    bloc.pageResult.listen((onData) {
      pageController.animateToPage(onData,
          duration: Duration(milliseconds: 300), curve: Curves.linear);
    });
    bloc.pollSaveResult.listen((onData) {
      if (onData is String && onData.isNotEmpty) {
        showTXModalBottomSheet(
            context: context,
            builder: (ctx) {
              return TXBottomResultInfo(content: onData,);
            });
      }
    });
    bloc.loadPolls(widget.conceptModel.id);
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        TXMainAppBarWidget(
          leading: TXIconButtonWidget(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              NavigationUtils.pop(context);
            },
          ),
          title: widget.conceptModel.title ?? R.string.myMeasureWellness,
          body: StreamBuilder<PollModel>(
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
                          ),
                        )
                      : TXBackgroundWidget(
                          iconRes: R.image.values_home,
                          imageUrl: snapshot.data.conceptModel.image,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 30,
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
                                    nextTitle: snapshot.data.questions.length >
                                            bloc.currentPage
                                        ? R.string.next
                                        : R.string.update,
                                    previousTitle: R.string.previous,
                                  );
                                },
                              )
                            ],
                          ),
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
      BuildContext context, QuestionModel model, int pageIndex) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: TXTextWidget(
              text: model.title,
              textAlign: TextAlign.justify,
              size: 16,
            ),
          ),
          TXBottomSheetSelectorWidget(
            list: model.convertAnswersToSelectionModel(),
            onItemSelected: (value) {
              bloc.setAnswerValue(pageIndex, value.id);
            },
            title: R.string.answer,
            initialId: model.selectedAnswerId,
          ),
        ],
      ),
    );
  }
}
