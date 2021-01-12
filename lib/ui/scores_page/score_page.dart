import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_divider_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_network_image.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/planifive_payment/planifive_payment_page.dart';
import 'package:mismedidasb/ui/profile/tx_stat_widget.dart';
import 'package:mismedidasb/ui/scores_page/score_bloc.dart';
import 'package:mismedidasb/ui/scores_page/tx_score_position_widget.dart';

class ScorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScoreState();
}

class _ScoreState extends StateWithBloC<ScorePage, ScoreBloC> {
  @override
  void initState() {
    super.initState();
    bloc.loadData();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        TXMainAppBarWidget(
          title: "Puntuaciones",
          leading: TXIconButtonWidget(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              NavigationUtils.pop(context);
            },
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 30),
              child: Column(
                children: <Widget>[
                  StreamBuilder<ScoreModel>(
                      stream: bloc.scoresResult,
                      initialData: null,
                      builder: (context, snapshot) {
                        if (snapshot.data == null) return Container();
                        final model = snapshot.data;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Card(
                              child: Container(
                                width: double.infinity,
                                child: Stack(
                                  children: <Widget>[
                                    TXScorePositionWidget(
                                        percentageBehind: model
                                            .personalRanking.percentageBehind
                                            .toDouble() //model.personalRanking.percentageBehind.toDouble(),
                                        ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10, bottom: 5),
                                        width: 200,
                                        child: Row(
                                          children: <Widget>[
                                            TXNetworkImage(
                                              shape: BoxShape.circle,
                                              width: 30,
                                              height: 30,
                                              imageUrl: model.user.avatar,
                                              boxFitImage: BoxFit.cover,
                                              placeholderImage: R.image.logo,
                                              boxFitPlaceholderImage:
                                                  BoxFit.cover,
                                            ),
                                            Expanded(
                                              child: Html(
                                                style: {
                                                  "span": Style(
                                                      color: Colors.orange)
                                                },
                                                data:
                                                    "Estas por encima del <b><span>${model.personalRanking.percentageBehind}%</span></b> de los usuarios.",
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: Card(
                                color: R.color.gray_light,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            TXTextWidget(
                                              text: "General",
                                              fontWeight: FontWeight.bold,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            TXStatWidget(
                                              title: "Puntuación máxima",
                                              value: model.points.toString(),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            TXTextWidget(
                                              text: R.string.coins,
                                              fontWeight: FontWeight.bold,
                                              size: 10,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                TXTextWidget(
                                                  text: model.coins.toString(),
                                                  size: 20,
                                                  textAlign: TextAlign.center,
                                                ),
                                                Image.asset(R.image.coins, width: 20, height: 20,)
                                              ],
                                              mainAxisAlignment: MainAxisAlignment.center,
                                            ),
                                            TXTextLinkWidget(
                                              textColor: R.color.accent_color,
                                              fontSize: 12,
                                              title: "comprar",
                                              onTap: () async {
                                                final res =
                                                    await NavigationUtils.push(
                                                        context,
                                                        PlanifivePaymentPage());
                                                if (res ?? false) {
                                                  bloc.loadData();
                                                }
                                                // bloc.addPayment();
                                              },
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Card(
                                      color: R.color.gray_light,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Column(
                                          children: <Widget>[
                                            TXTextWidget(
                                              text: "Plan diario",
                                              fontWeight: FontWeight.bold,
                                              size: 10,
                                            ),
                                            TXTextWidget(
                                              text: "-días consecutivos-",
                                              size: 10,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child: TXStatWidget(
                                                    title: "Récord",
                                                    value: model.eatMaxStreak
                                                        .toString(),
                                                    titleSize: 10,
                                                    valueSize: 20,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: TXStatWidget(
                                                    title: "Actual",
                                                    value: model
                                                        .eatCurrentStreak
                                                        .toString(),
                                                    titleSize: 10,
                                                    valueSize: 20,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Card(
                                      color: R.color.gray_light,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Column(
                                          children: <Widget>[
                                            TXTextWidget(
                                              text: "Platos balanceados",
                                              fontWeight: FontWeight.bold,
                                              size: 10,
                                            ),
                                            TXTextWidget(
                                              text: "-días consecutivos-",
                                              size: 10,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child: TXStatWidget(
                                                    title: "Récord",
                                                    value: model
                                                        .balancedEatMaxStreak
                                                        .toString(),
                                                    titleSize: 10,
                                                    valueSize: 20,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: TXStatWidget(
                                                    title: "Actual",
                                                    value: model
                                                        .balancedEatCurrentStreak
                                                        .toString(),
                                                    titleSize: 10,
                                                    valueSize: 20,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder<SoloQuestionStatsModel>(
                    stream: bloc.soloQuestionStatsResult,
                    initialData: null,
                    builder: (ctx, snapshot) {
                      if (snapshot.data == null) return Container();
                      final model = snapshot.data;
                      return Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image.asset(
                                R.image.plani,
                                width: 30,
                                height: 30,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Html(
                                  shrinkWrap: true,
                                  style: {
                                    "span": Style(
                                        color: Colors.orange,
                                        fontSize: FontSize.xLarge)
                                  },
                                  data: "Últimos <b><span>7</span></b> días.",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TXDividerWidget(),
                          SizedBox(
                            height: 5,
                          ),
                          Card(
                            color: R.color.gray_light,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Row(
                                children: <Widget>[
                                  ..._getFeelingFaces(
                                      model.mostFrequentEmotions,
                                      model.mostFrequentEmotionCount)
                                ],
                              ),
                            ),
                          ),
                          Card(
                            color: R.color.gray_light,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Html(
                                shrinkWrap: true,
                                style: {
                                  "span": Style(
                                      color: Colors.orange,
                                      fontSize: FontSize.xLarge)
                                },
                                data:
                                    "<b><span>${model.bestComplyEatStreak}</span></b> día${model.bestComplyEatStreak > 1 ? "s" : ""} has cumplido tu Plan de Comidas.",
                              ),
                            ),
                          ),
                          Card(
                            color: R.color.gray_light,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Html(
                                shrinkWrap: true,
                                style: {
                                  "span": Style(
                                      color: Colors.orange,
                                      fontSize: FontSize.xLarge)
                                },
                                data:
                                    "<b><span>${model.totalDaysPlannedSport}</span></b> día${model.totalDaysPlannedSport > 1 ? "s" : ""} has planificado hacer ejercicios.",
                              ),
                            ),
                          ),
                          Card(
                            color: R.color.gray_light,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Html(
                                shrinkWrap: true,
                                style: {
                                  "span": Style(
                                      color: Colors.orange,
                                      fontSize: FontSize.xLarge)
                                },
                                data:
                                    "<b><span>${model.totalDaysComplySportPlan}</span></b> día${model.totalDaysComplySportPlan > 1 ? "s" : ""} has hecho ejercicios.",
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        TXLoadingWidget(
          loadingStream: bloc.isLoadingStream,
        )
      ],
    );
  }

  List<Widget> _getFeelingFaces(List<int> faces, int count) {
    List<Widget> list = [];

    faces.forEach((face) {
      final w = Icon(
        face == -2
            ? Icons.sentiment_very_dissatisfied
            : face == -1
                ? Icons.sentiment_dissatisfied
                : face == 0
                    ? Icons.sentiment_neutral
                    : face == 1
                        ? Icons.sentiment_satisfied
                        : Icons.sentiment_very_satisfied,
        size: 30,
        color: face == -2
            ? Colors.red
            : face == -1
                ? Colors.redAccent
                : face == 0
                    ? Colors.amber
                    : face == 1 ? Colors.lightGreen : Colors.green,
      );
      list.add(w);
    });

    list.add(Expanded(
      child: Html(
        shrinkWrap: true,
        style: {"span": Style(color: Colors.orange, fontSize: FontSize.xLarge)},
        data: "<b><span>${count}</span></b> día${count > 1 ? "s." : "."}",
      ),
    ));

    return list;
  }
}
