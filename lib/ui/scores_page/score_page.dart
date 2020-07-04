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
                                              text: "Monedas",
                                              fontWeight: FontWeight.bold,
                                              size: 10,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            TXTextWidget(
                                              text: model.coins.toString(),
                                              size: 20,
                                              textAlign: TextAlign.center,
                                            ),
                                            TXTextLinkWidget(
                                              textColor: R.color.accent_color,
                                              fontSize: 12,
                                              title: "Obtén más monedas",
                                              onTap: () {},
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
                                                    title: "Maxima racha",
                                                    value: model.eatMaxStreak
                                                        .toString(),
                                                    titleSize: 10,
                                                    valueSize: 20,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: TXStatWidget(
                                                    title: "Racha actual",
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
                                                    title: "Maxima racha",
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
                                                    title: "Racha actual",
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
                                  data:
                                      "Encuestas de Plani en los últimos <b><span>7</span></b> días.",
                                ),
                              ),
//                              TXTextLinkWidget(
//                                title: "Filtrar",'
//                                onTap: () {
//
//                                },
//                              )
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
                              child: Column(
                                children: <Widget>[
                                  TXTextWidget(
                                    text: "Estado de ánimo más frecuente",
                                    fontWeight: FontWeight.bold,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Icon(
                                            model.mostFrequentEmotion == -2
                                                ? Icons
                                                    .sentiment_very_dissatisfied
                                                : model.mostFrequentEmotion == -1
                                                    ? Icons
                                                        .sentiment_dissatisfied
                                                    : model.mostFrequentEmotion ==
                                                            -1
                                                        ? Icons
                                                            .sentiment_neutral
                                                        : model.mostFrequentEmotion ==
                                                                -1
                                                            ? Icons
                                                                .sentiment_satisfied
                                                            : Icons
                                                                .sentiment_very_satisfied,
                                            size: 20,
                                            color: model.mostFrequentEmotion ==
                                                    -2
                                                ? Colors.red
                                                : model.mostFrequentEmotion ==
                                                        -1
                                                    ? Colors.redAccent
                                                    : model.mostFrequentEmotion ==
                                                            -1
                                                        ? Colors.amber
                                                        : model.mostFrequentEmotion ==
                                                                -1
                                                            ? Colors.lightGreen
                                                            : Icons
                                                                .sentiment_very_satisfied,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Html(
                                            shrinkWrap: true,
                                            style: {
                                              "span": Style(
                                                  color: Colors.orange,
                                                  fontSize: FontSize.xLarge)
                                            },
                                            data:
                                                "${model.mostFrequentEmotionCount}</span></b> día${model.mostFrequentEmotionCount > 1 ? "s" : ""}",
                                          ),
                                        ),
                                      ),
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  )
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
                                    "Llevas <b><span>${model.bestComplyEatStreak}</span></b> día${model.bestComplyEatStreak > 1 ? "s" : ""} cumpliendo tu plan de comidas.",
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
                                    "Llevas <b><span>${model.totalDaysPlannedSport}</span></b> día${model.totalDaysPlannedSport > 1 ? "s" : ""} planificando ejercicios físicos. Y <b><span>${model.totalDaysPlannedSport}</span></b> día${model.totalDaysPlannedSport > 1 ? "s" : ""} realizándolos.",
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
}
