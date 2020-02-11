import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/domain/question/question_model.dart';
import 'package:mismedidasb/domain/single_selection_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_buttons_paginate_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
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
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: StreamBuilder<int>(
                    stream: bloc.pageResult,
                    initialData: 0,
                    builder: (ctx, snapshot) {
                      return TXButtonPaginateWidget(
                        onNext: snapshot.data == 3
                            ? null
                            : () {
                                bloc.changePage(true);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  child: TXTextWidget(
                    text: "Datos personales",
                    size: 20,
                  ),
                ),
                ListTile(
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    showTXModalBottomSheet(
                        context: context,
                        builder: (ctx) {
                          return TXCupertinoPickerWidget(
                            height: 200,
                            list: SingleSelectionModel.getAgeRange(),
                            onItemSelected: (model) {
                              bloc.setAge(model.id);
                            },
                            title: "Edad",
                            initialId: bloc.healthMeasureResultModel.age,
                          );
                        });
                  },
                  title: Container(
                    padding: EdgeInsets.all(10),
                    child: TXTextWidget(
                      text: "Edad: ${snapshot.data.age}años",
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                ),
                ListTile(
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    showTXModalBottomSheet(
                        context: context,
                        builder: (ctx) {
                          return TXCupertinoPickerWidget(
                            height: 200,
                            list: SingleSelectionModel.getWeight(),
                            onItemSelected: (model) {
                              bloc.setWeight(model.id);
                            },
                            title: "Peso",
                            initialId: bloc.healthMeasureResultModel.weight,
                          );
                        });
                  },
                  title: Container(
                    padding: EdgeInsets.all(10),
                    child: TXTextWidget(
                      text: "Peso: ${snapshot.data.weight}kg",
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                ),
                ListTile(
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    showTXModalBottomSheet(
                        context: context,
                        builder: (ctx) {
                          return TXCupertinoPickerWidget(
                            height: 200,
                            list: SingleSelectionModel.getHeight(),
                            onItemSelected: (model) {
                              bloc.setHeight(model.id);
                            },
                            title: "Talla",
                            initialId: bloc.healthMeasureResultModel.height,
                          );
                        });
                  },
                  title: Container(
                    padding: EdgeInsets.all(10),
                    child: TXTextWidget(
                      text: "Talla: ${snapshot.data.height}cm",
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                ),
                ListTile(
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    showTXModalBottomSheet(
                        context: context,
                        builder: (ctx) {
                          return TXCupertinoPickerWidget(
                            height: 200,
                            list: SingleSelectionModel.getSex(),
                            onItemSelected: (model) {
                              bloc.setSex(model.id);
                            },
                            title: "Sexo",
                            initialId: bloc.healthMeasureResultModel.sex,
                          );
                        });
                  },
                  title: Container(
                    padding: EdgeInsets.all(10),
                    child: TXTextWidget(
                      text:
                          "Sexo: ${snapshot.data.sex == 1 ? "Hombre" : "Mujer"}",
                    ),
                  ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      ListTile(
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          showTXModalBottomSheet(
                              context: context,
                              builder: (ctx) {
                                return TXCupertinoPickerWidget(
                                  height: 200,
                                  list: SingleSelectionModel
                                      .getPhysicalExercise(),
                                  onItemSelected: (model) {
                                    bloc.setPhysicalExercise(
                                        model.id, model.displayName);
                                  },
                                  title: poll.name,
                                  initialId: bloc.healthMeasureResultModel
                                      .physicalExercise,
                                );
                              });
                        },
                        title: TXTextWidget(
                          text: element.title,
                        ),
                        dense: true,
                        subtitle: Container(
                          child: TXTextWidget(
                            text: snapshot.data.physicalExerciseValue,
                            color: R.color.gray_darkest,
                            size: 20,
                          ),
                        ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      ListTile(
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          showTXModalBottomSheet(
                              context: context,
                              builder: (ctx) {
                                return TXCupertinoPickerWidget(
                                  height: 200,
                                  list: SingleSelectionModel.getDiet(),
                                  onItemSelected: (model) {
                                    bloc.setDiet(
                                        model.id, model.displayName, index);
                                  },
                                  title: poll.name,
                                  initialId:
                                      bloc.healthMeasureResultModel.diet[index],
                                );
                              });
                        },
                        title: TXTextWidget(
                          text: element.title,
                        ),
                        dense: true,
                        subtitle: Container(
                          child: TXTextWidget(
                            text: snapshot.data.dietValue[index],
                            color: R.color.gray_darkest,
                            size: 20,
                          ),
                        ),
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
