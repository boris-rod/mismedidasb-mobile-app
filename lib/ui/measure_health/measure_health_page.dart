import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/domain/health_concept/health_concept.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/domain/question/question_model.dart';
import 'package:mismedidasb/domain/single_selection_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_background_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_result_info.dart';
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
        TXMainAppBarWidget(
          leading: TXIconButtonWidget(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              NavigationUtils.pop(context);
            },
          ),
          title: widget.conceptModel.title ?? R.string.myMeasureHealth,
          body: StreamBuilder<List<PollModel>>(
            stream: bloc.pollsResult,
            initialData: [],
            builder: (ctx, snapshot) {
              return TXBackgroundWidget(
                iconRes: R.image.health_home,
                imageUrl: widget.conceptModel.image,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: PageView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              controller: pageController,
                              itemBuilder: (ctx, index) {
                                final model = snapshot.data[index];
                                return _getPageView(context, model, index);
                              },
                              itemCount: snapshot.data.length,
                            ),
                          ),
                          TXTextWidget(
                            textAlign: TextAlign.center,
                            text: snapshot.data.isNotEmpty
                                ? snapshot.data[bloc.currentPage - 1]
                                    .bottomTip()
                                : "",
                            size: 12,
                            color: R.color.accent_color,
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

  Widget _getPageView(BuildContext context, PollModel model, int pageIndex) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: TXTextWidget(
              text: model.name,
              textAlign: TextAlign.justify,
              size: 16,
            ),
          ),
          Column(
            children: _getQuestions(context, pageIndex, model),
          )
        ],
      ),
    );
  }

  List<Widget> _getQuestions(
      BuildContext context, int pollIndex, PollModel pollModel) {
    List<Widget> list = [];
    for (int i = 0; i < pollModel.questions.length; i++) {
      final w = TXBottomSheetSelectorWidget(
        list: pollModel.questions[i].convertAnswersToSelectionModel(),
        onItemSelected: (value) {
          bloc.setAnswerValue(pollIndex, i, value.id);
        },
        title: pollModel.questions[i].title,
        initialId: pollModel.questions[i].selectedAnswerId,
      );
      list.add(w);
    }

    return list;
  }

//  Widget getPersonalDataView(BuildContext context) {
//    return Container(
//      child: SingleChildScrollView(
//        child: StreamBuilder<HealthMeasureResultModel>(
//          stream: bloc.measureResult,
//          initialData: bloc.healthMeasureResultModel,
//          builder: (ctx, snapshot) {
//            return Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              children: <Widget>[
//                Container(
//                  alignment: Alignment.center,
//                  padding: EdgeInsets.all(20),
//                  child: TXTextWidget(
//                    text: "Datos personales",
//                    size: 20,
//                  ),
//                ),
//                TXBottomSheetSelectorWidget(
//                  list: SingleSelectionModel.getAgeRange(),
//                  onItemSelected: (model) {
//                    bloc.setAge(model.id);
//                  },
//                  title: "Edad - (Años)",
//                  initialId: bloc.healthMeasureResultModel.age,
//                ),
//                Divider(
//                  height: 1,
//                ),
//                TXBottomSheetSelectorWidget(
//                  list: SingleSelectionModel.getWeight(),
//                  onItemSelected: (model) {
//                    bloc.setWeight(model.id);
//                  },
//                  title: "Peso - (Kilogramos)",
//                  initialId: bloc.healthMeasureResultModel.weight,
//                ),
//                Divider(
//                  height: 1,
//                ),
//                TXBottomSheetSelectorWidget(
//                  list: SingleSelectionModel.getHeight(),
//                  onItemSelected: (model) {
//                    bloc.setHeight(model.id);
//                  },
//                  title: "Estatura - (Centímetros)",
//                  initialId: bloc.healthMeasureResultModel.height,
//                ),
//                Divider(
//                  height: 1,
//                ),
//                TXBottomSheetSelectorWidget(
//                  list: SingleSelectionModel.getSex(),
//                  bottomSheetHeight: 200,
//                  onItemSelected: (model) {
//                    bloc.setSex(model.id);
//                  },
//                  title: "Sexo",
//                  initialId: bloc.healthMeasureResultModel.sex,
//                ),
//                Divider(
//                  height: 1,
//                ),
//              ],
//            );
//          },
//        ),
//      ),
//    );
//  }
//
//  Widget getPeriodForPhysicalExerciseView(BuildContext context) {
//    return Container(
//      child: StreamBuilder<HealthMeasureResultModel>(
//        stream: bloc.measureResult,
//        initialData: bloc.healthMeasureResultModel,
//        builder: (ctx, snapshot) {
//          final elementList = QuestionModel.getPhysicalExerciseList();
//          final poll = PollModel.getPollPhysicalExercise();
//          return Column(
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              Container(
//                alignment: Alignment.center,
//                padding: EdgeInsets.all(20),
//                child: TXTextWidget(
//                  text: poll.name,
//                  size: 20,
//                ),
//              ),
//              ListView.builder(
//                shrinkWrap: true,
//                itemBuilder: (ctx, index) {
//                  final element = elementList[index];
//                  return Column(
//                    children: <Widget>[
//                      TXBottomSheetSelectorWidget(
//                        list: SingleSelectionModel.getPhysicalExercise(),
//                        onItemSelected: (model) {
//                          bloc.setPhysicalExercise(model.id, model.displayName);
//                        },
//                        title: element.title,
//                        initialId:
//                            bloc.healthMeasureResultModel.physicalExercise,
//                      ),
//                      Divider(
//                        height: 1,
//                      ),
//                    ],
//                  );
//                },
//                itemCount: elementList.length,
//              ),
//            ],
//          );
//        },
//      ),
//    );
//  }
//
//  Widget getDietView(BuildContext context) {
//    return Container(
//      child: StreamBuilder<HealthMeasureResultModel>(
//        stream: bloc.measureResult,
//        initialData: bloc.healthMeasureResultModel,
//        builder: (ctx, snapshot) {
//          final elementList = QuestionModel.getDiets();
//          final poll = PollModel.getPollDiet();
//          return Column(
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              Container(
//                alignment: Alignment.center,
//                padding: EdgeInsets.all(20),
//                child: TXTextWidget(
//                  text: poll.name,
//                  size: 20,
//                ),
//              ),
//              ListView.builder(
//                physics: BouncingScrollPhysics(),
//                shrinkWrap: true,
//                itemBuilder: (ctx, index) {
//                  final element = elementList[index];
//                  return Column(
//                    children: <Widget>[
//                      TXBottomSheetSelectorWidget(
//                        list: SingleSelectionModel.getDiet(),
//                        onItemSelected: (model) {
//                          bloc.setDiet(model.id, model.displayName, index);
//                        },
//                        title: element.title,
//                        initialId: bloc.healthMeasureResultModel.diet[index],
//                      ),
//                      Divider(
//                        height: 1,
//                      ),
//                    ],
//                  );
//                },
//                itemCount: elementList.length,
//              ),
//            ],
//          );
//        },
//      ),
//    );
//  }
//
//  Widget getResultView(BuildContext context) {
//    return Container(
//      padding: EdgeInsets.all(20),
//      child: StreamBuilder<HealthMeasureResultModel>(
//          stream: bloc.measureResult,
//          initialData: bloc.healthMeasureResultModel,
//          builder: (ctx, snapshot) {
//            return Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              children: <Widget>[
//                Container(
//                  alignment: Alignment.center,
//                  padding: EdgeInsets.all(20),
//                  child: TXTextWidget(
//                    text: "Resultados",
//                    size: 20,
//                  ),
//                ),
//                TXTextWidget(
//                  text: snapshot.data.result,
//                )
//              ],
//            );
//          }),
//    );
//  }
}
