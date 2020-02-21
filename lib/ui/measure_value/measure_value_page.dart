import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_background_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_buttons_paginate_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/measure_value/measure_value_bloc.dart';
import 'package:mismedidasb/ui/measure_value/measure_value_model.dart';

class MeasureValuePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MeasureValueState();
}

class _MeasureValueState
    extends StateWithBloC<MeasureValuePage, MeasureValueBloC> {
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
          title: R.string.myMeasureValues,
          body: StreamBuilder<int>(
              stream: bloc.pageResult,
              initialData: 0,
              builder: (ctx, snapshot) {
                return TXBackgroundWidget(
                  icon: Icons.videogame_asset,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: PageView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            if (index == bloc.valueResultModel.values.length) {
                              return _getPageViewResult(ctx);
                            } else {
                              final model = bloc.valueResultModel.values[index];
                              return _getPageView(ctx, model, index);
                            }
                          },
                          controller: pageController,
                          itemCount: bloc.valueResultModel.values.length + 1,
                        ),
                      ),
                      Container(
                        child: TXButtonPaginateWidget(
                          onNext: snapshot.data ==
                                  bloc.valueResultModel.values.length
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
                                  bloc.valueResultModel.values.length - 1
                              ? R.string.next
                              : R.string.update,
                          previousTitle: R.string.previous,
                        ),
                      )
                    ],
                  ),
                );
              }),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: TXTextWidget(
              text: R.string.valuesConcept,
              size: 20,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                final model = bloc.valueResultModel.results[index];
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TXTextWidget(
                    text: model,
                    color: index % 2 == 0
                        ? R.color.primary_color
                        : R.color.accent_color,
                  ),
                );
              },
              itemCount: bloc.valueResultModel.results.length,
            ),
          )
        ],
      ),
    );
  }

  Widget _getPageView(
      BuildContext context, MeasureValueModel model, int pageIndex) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: TXTextWidget(
              text: model.question.title,
              size: 20,
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
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
            ),
          )
        ],
      ),
    );
  }
}
