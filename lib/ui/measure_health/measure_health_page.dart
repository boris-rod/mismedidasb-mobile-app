import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/domain/question/question_model.dart';
import 'package:mismedidasb/domain/single_selection_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_background_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottomsheet_selector_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_buttons_paginate_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_dialog_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/measure_health/health_measure_result_model.dart';
import 'package:mismedidasb/ui/measure_health/measure_health_bloc.dart';

class MeasureHealthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MeasureHealthState();
}

class _MeasureHealthState
    extends StateWithBloC<MeasureHealthPage, MeasureHealthBloC> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    bloc.iniDataResult();

    bloc.loadMeasures();
    bloc.pageResult.listen((onData) {
      pageController.animateToPage(onData,
          duration: Duration(milliseconds: 300), curve: Curves.linear);
    });
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
          title: R.string.myMeasureHealth,
          body: TXBackgroundWidget(
            iconRes: R.image.health_home,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                StreamBuilder<int>(
                  stream: bloc.pageResult,
                  initialData: bloc.currentPage,
                  builder: (context, snapshot) {
                    return TXTextWidget(
                      color: R.color.gray,
                      textAlign: TextAlign.justify,
                      text: "${snapshot.data + 1} / 3",
                    );
                  },
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: PageView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          controller: pageController,
                          itemBuilder: (ctx, index) {
                            List<Widget> list = [
                              getPersonalDataView(context),
                              getPeriodForPhysicalExerciseView(context),
                              getDietView(context),
                              getResultView(context)
                            ];
                            return list[index];
                          },
                          itemCount: 4,
                        ),
                      ),
                      TXTextWidget(
                        textAlign: TextAlign.center,
                        text: R.string.app_clinical_warning,
                        size: 12,
                        color: R.color.accent_color,
                      )
                    ],
                  ),
                ),
                Container(
                  child: StreamBuilder<int>(
                    stream: bloc.pageResult,
                    initialData: 0,
                    builder: (ctx, snapshot) {
                      return TXButtonPaginateWidget(
                        onNext: () async {
                          if (snapshot.data == 2) {
                            final result = await bloc.saveMeasures();
                            showTXModalBottomSheet(
                                context: context,
                                builder: (ctx) {
                                  bloc.saveMeasures();
                                  return Container(
                                    height: 300,
                                    child: Container(
                                      padding: EdgeInsets.only(left: 10),
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                child: TXTextWidget(
                                                  text: "Gracias",
                                                  maxLines: 2,
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                  size: 18,
                                                ),
                                              ),
                                              Container(
                                                width: 50,
                                                child: TXTextLinkWidget(
                                                  title: R.string.ok,
                                                  textColor:
                                                      R.color.primary_color,
                                                  onTap: () {
                                                    NavigationUtils.pop(
                                                        context);
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 20),
                                              child: Center(
                                                child: TXTextWidget(
                                                    textAlign:
                                                        TextAlign.justify,
                                                    text: result.result),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            bloc.changePage(true);
                          }
                        },
                        onPrevious: snapshot.data > 0
                            ? () {
                                bloc.changePage(false);
                              }
                            : null,
                        nextTitle:
                            snapshot.data < 2 ? R.string.next : R.string.update,
                        previousTitle: R.string.previous,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        TXLoadingWidget(
          loadingStream: bloc.isLoadingStream,
        )
      ],
    );
  }

  Widget getPersonalDataView(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: StreamBuilder<HealthMeasureResultModel>(
          stream: bloc.measureResult,
          initialData: bloc.healthMeasureResultModel,
          builder: (ctx, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  child: TXTextWidget(
                    text: "Datos personales",
                    size: 20,
                  ),
                ),
                TXBottomSheetSelectorWidget(
                  list: SingleSelectionModel.getAgeRange(),
                  onItemSelected: (model) {
                    bloc.setAge(model.id);
                  },
                  title: "Edad - (Años)",
                  initialId: bloc.healthMeasureResultModel.age,
                ),
                Divider(
                  height: 1,
                ),
                TXBottomSheetSelectorWidget(
                  list: SingleSelectionModel.getWeight(),
                  onItemSelected: (model) {
                    bloc.setWeight(model.id);
                  },
                  title: "Peso - (Kilogramos)",
                  initialId: bloc.healthMeasureResultModel.weight,
                ),
                Divider(
                  height: 1,
                ),
                TXBottomSheetSelectorWidget(
                  list: SingleSelectionModel.getHeight(),
                  onItemSelected: (model) {
                    bloc.setHeight(model.id);
                  },
                  title: "Estatura - (Centímetros)",
                  initialId: bloc.healthMeasureResultModel.height,
                ),
                Divider(
                  height: 1,
                ),
                TXBottomSheetSelectorWidget(
                  list: SingleSelectionModel.getSex(),
                  bottomSheetHeight: 200,
                  onItemSelected: (model) {
                    bloc.setSex(model.id);
                  },
                  title: "Sexo",
                  initialId: bloc.healthMeasureResultModel.sex,
                ),
                Divider(
                  height: 1,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getPeriodForPhysicalExerciseView(BuildContext context) {
    return Container(
      child: StreamBuilder<HealthMeasureResultModel>(
        stream: bloc.measureResult,
        initialData: bloc.healthMeasureResultModel,
        builder: (ctx, snapshot) {
          final elementList = QuestionModel.getPhysicalExerciseList();
          final poll = PollModel.getPollPhysicalExercise();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                child: TXTextWidget(
                  text: poll.name,
                  size: 20,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  final element = elementList[index];
                  return Column(
                    children: <Widget>[
                      TXBottomSheetSelectorWidget(
                        list: SingleSelectionModel.getPhysicalExercise(),
                        onItemSelected: (model) {
                          bloc.setPhysicalExercise(model.id, model.displayName);
                        },
                        title: element.title,
                        initialId:
                            bloc.healthMeasureResultModel.physicalExercise,
                      ),
                      Divider(
                        height: 1,
                      ),
                    ],
                  );
                },
                itemCount: elementList.length,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget getDietView(BuildContext context) {
    return Container(
      child: StreamBuilder<HealthMeasureResultModel>(
        stream: bloc.measureResult,
        initialData: bloc.healthMeasureResultModel,
        builder: (ctx, snapshot) {
          final elementList = QuestionModel.getDiets();
          final poll = PollModel.getPollDiet();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                child: TXTextWidget(
                  text: poll.name,
                  size: 20,
                ),
              ),
              ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  final element = elementList[index];
                  return Column(
                    children: <Widget>[
                      TXBottomSheetSelectorWidget(
                        list: SingleSelectionModel.getDiet(),
                        onItemSelected: (model) {
                          bloc.setDiet(model.id, model.displayName, index);
                        },
                        title: element.title,
                        initialId: bloc.healthMeasureResultModel.diet[index],
                      ),
                      Divider(
                        height: 1,
                      ),
                    ],
                  );
                },
                itemCount: elementList.length,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget getResultView(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: StreamBuilder<HealthMeasureResultModel>(
          stream: bloc.measureResult,
          initialData: bloc.healthMeasureResultModel,
          builder: (ctx, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  child: TXTextWidget(
                    text: "Resultados",
                    size: 20,
                  ),
                ),
                TXTextWidget(
                  text: snapshot.data.result,
                )
              ],
            );
          }),
    );
  }
}
