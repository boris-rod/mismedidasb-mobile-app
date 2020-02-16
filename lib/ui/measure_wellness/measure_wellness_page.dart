import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/res/values/colors.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
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
              return Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: PageView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          if (index ==
                              bloc.wellnessResultModel.wellness.length) {
                            return _getPageViewResult(ctx);
                          } else {
                            final model =
                                bloc.wellnessResultModel.wellness[index];
                            return _getPageView(ctx, model, index);
                          }
                        },
                        controller: pageController,
                        itemCount: bloc.wellnessResultModel.wellness.length + 1,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: TXButtonPaginateWidget(
                        onNext: snapshot.data ==
                                bloc.wellnessResultModel.wellness.length
                            ? null
                            : () {
                                bloc.changePage(1);
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

  Widget _getPageViewResult(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: TXTextWidget(
              text: bloc.wellnessResultModel.result[0],
              size: 20,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                final model = bloc.wellnessResultModel.result[index + 1];
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: TXTextWidget(
                    text: model,
                  ),
                );
              },
              itemCount: bloc.wellnessResultModel.result.length - 1,
            ),
          )
        ],
      ),
    );
  }

  Widget _getPageView(
      BuildContext context, MeasureWellnessModel model, int pageIndex) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(20),
              child: TXTextWidget(
                text: model.question.title,
                size: 20,
              ),
            ),
            ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: model.answers
                  .map((m) => Column(
                children: <Widget>[
                  RadioListTile(
                    groupValue: model.selectedAnswer.weight,
                    title: TXTextWidget(
                      text: m.title,
                    ),
                    value: m.weight,
                    onChanged: (val) {
                      setState(() {
                        bloc.setAnswerValue(pageIndex, m);
                      });
                    },
                  ),
                  Divider(
                    height: 1,
                  ),
                ],
              ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
