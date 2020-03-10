import 'package:flutter/material.dart';
import 'package:mismedidasb/domain/single_selection_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/res/values/colors.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_background_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottomsheet_selector_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_buttons_paginate_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/measure_wellness/measure_wellness_bloc.dart';
import 'package:mismedidasb/ui/measure_wellness/measure_wellness_model.dart';

class MeasureWellnessPage extends StatefulWidget {
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
    bloc.iniDataResult();
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
          title: R.string.myMeasureWellness,
          body: StreamBuilder<int>(
            stream: bloc.pageResult,
            initialData: 0,
            builder: (ctx, snapshot) {
              return TXBackgroundWidget(
                iconRes: R.image.wellness_home,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    TXTextWidget(
                      color: R.color.gray,
                      textAlign: TextAlign.justify,
                      text:
                          "${bloc.currentPage + 1} / ${bloc.wellnessResultModel.wellness.length}",
                    ),
                    Expanded(
                      child: PageView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          final model =
                              bloc.wellnessResultModel.wellness[index];
                          return _getPageView(ctx, model, index);
                        },
                        controller: pageController,
                        itemCount: bloc.wellnessResultModel.wellness.length,
                      ),
                    ),
                    Container(
                      child: TXButtonPaginateWidget(
                        onNext: () {
                          snapshot.data ==
                                  bloc.wellnessResultModel.wellness.length - 1
                              ? showTXModalBottomSheet(
                                  context: context,
                                  builder: (ctx) {
                                    bloc.saveMeasures();
                                    return Container(
                                      height: 300,
                                      child: TXTextWidget(
                                        text: "Gracias",
                                      ),
                                    );
                                  })
                              : bloc.changePage(1);
                        },
                        onPrevious: snapshot.data > 0
                            ? () {
                                bloc.changePage(-1);
                              }
                            : null,
                        nextTitle: snapshot.data <
                                bloc.wellnessResultModel.wellness.length - 1
                            ? R.string.next
                            : R.string.update,
                        previousTitle: R.string.previous,
                      ),
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
      BuildContext context, MeasureWellnessModel model, int pageIndex) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: TXTextWidget(
              text: model.question.title,
              textAlign: TextAlign.justify,
              size: 16,
            ),
          ),
          TXBottomSheetSelectorWidget(
            list: SingleSelectionModel.getWellness(),
            onItemSelected: (value) {
              bloc.setAnswerValue(pageIndex, value.id);
            },
            title: "Respuesta",
            initialId: model.selectedAnswer.id,
          ),
        ],
      ),
    );
  }
}
