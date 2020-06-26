import 'package:flutter/material.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
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
    bloc.getScores();
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
              child: StreamBuilder<ScoreModel>(
                  stream: bloc.scoresResult,
                  initialData: null,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) return Container();
                    final model = snapshot.data;
                    return Column(
                      children: <Widget>[
                        Card(
                          child: Container(
                            width: double.infinity,
                            child: TXScorePositionWidget(
                                percentage:
                                0 //model.personalRanking.percentageBehind.toDouble(),
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
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        TXTextWidget(
                                          text: "Platos balanceados",
                                          fontWeight: FontWeight.bold,
                                          size: 10,
                                        ),
                                        SizedBox(
                                          height: 20,
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
                                  )
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                          ),
                        ),
//                        Container(
//                          child: Row(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Expanded(
//                                flex: 1,
//                                child: Card(
//                                  color: R.color.gray_light,
//                                  child: Container(
//                                    padding: EdgeInsets.symmetric(
//                                        vertical: 10, horizontal: 10),
//                                    child: Column(
//                                      children: <Widget>[
//                                        TXTextWidget(
//                                          text: "Platos saludables",
//                                          fontWeight: FontWeight.bold,
//                                          size: 10,
//                                        ),
//                                        SizedBox(
//                                          height: 10,
//                                        ),
//                                        Row(
//                                          crossAxisAlignment:
//                                              CrossAxisAlignment.start,
//                                          children: <Widget>[
//                                            Expanded(
//                                              flex: 1,
//                                              child: TXStatWidget(
//                                                title: "Maxima racha",
//                                                value: model.eatMaxStreak.toString(),
//                                                titleSize: 10,
//                                                valueSize: 20,
//                                              ),
//                                            ),
//                                            Expanded(
//                                              flex: 1,
//                                              child: TXStatWidget(
//                                                title: "Racha actual",
//                                                value: model.eatCurrentStreak.toString(),
//                                                titleSize: 10,
//                                                valueSize: 20,
//                                              ),
//                                            ),
//                                          ],
//                                        )
//                                      ],
//                                    ),
//                                  ),
//                                ),
//                              ),
//                              SizedBox(
//                                width: 5,
//                              ),
//                              Expanded(
//                                flex: 1,
//                                child: Card(
//                                  color: R.color.gray_light,
//                                  child: Container(
//                                    padding: EdgeInsets.symmetric(
//                                        vertical: 10, horizontal: 10),
//                                    child: Column(
//                                      children: <Widget>[
//                                        TXTextWidget(
//                                          text: "Platos balanceados",
//                                          fontWeight: FontWeight.bold,
//                                          size: 10,
//                                        ),
//                                        SizedBox(
//                                          height: 10,
//                                        ),
//                                        Row(
//                                          crossAxisAlignment:
//                                              CrossAxisAlignment.start,
//                                          children: <Widget>[
//                                            Expanded(
//                                              flex: 1,
//                                              child: TXStatWidget(
//                                                title: "Maxima racha",
//                                                value: model.balancedEatMaxStreak.toString(),
//                                                titleSize: 10,
//                                                valueSize: 20,
//                                              ),
//                                            ),
//                                            Expanded(
//                                              flex: 1,
//                                              child: TXStatWidget(
//                                                title: "Racha actual",
//                                                value: model.balancedEatCurrentStreak.toString(),
//                                                titleSize: 10,
//                                                valueSize: 20,
//                                              ),
//                                            ),
//                                          ],
//                                        )
//                                      ],
//                                    ),
//                                  ),
//                                ),
//                              )
//                            ],
//                          ),
//                        )
                      ],
                    );
                  }),
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
