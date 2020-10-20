import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/domain/health_concept/health_concept.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/domain/single_selection_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_blur_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_custom_action_bar.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_video_intro_widet.dart';
import 'package:mismedidasb/ui/food_craving/food_craving_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class FoodCravingPage extends StatefulWidget {
  final HealthConceptModel conceptModel;

  const FoodCravingPage({Key key, this.conceptModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FoodCravingState();
}

class _FoodCravingState
    extends StateWithBloC<FoodCravingPage, FoodCravingBloC> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: R.color.craving_color));
    bloc.loadData(widget.conceptModel.id);
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        TXCustomActionBar(
          // showGifInfo: 2,
          actionBarColor: R.color.craving_color,
          body: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: -40,
                right: 0,
                bottom: 0,
                child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                  fit: BoxFit.contain,
                  image: ExactAssetImage(R.image.food_craving_home_blur),
                ))),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
                  Widget>[
                Image.asset(
                  R.image.craving_title,
                  width: 300,
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TXTextWidget(
                        text:
                            "Si notas que te quedas con \"hambre\" tras realizar tus comidas, elige una de estas sugerencias:",
                        color: Colors.white,
                        size: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin:
                        EdgeInsets.only(left: 40, bottom: 30, top: 0, right: 40),
                        width: double.infinity,
                        child: TXBlurWidget(),
                      ),
                      Container(
                        margin:
                        EdgeInsets.only(left: 30, bottom: 30, top: 0, right: 40),
                        child: StreamBuilder<List<TitleSubTitlesModel>>(
                            stream: bloc.pollsResult,
                            initialData: [],
                            builder: (context, snapshot) {
                              return SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Container(
                                  padding: EdgeInsets.only(right: 10),
                                  width: double.infinity,
                                  child: Column(
                                    children: <Widget>[
                                      ..._getCravingsView(snapshot.data)
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      TXTextWidget(
                        text:
                            "Estas sugerencias no tienen un orden específico, ni frecuencia determinada. Debes escoger la que mejor te parezca y utilizarla en dependencia de la situación. Si funciona, perfecto y si no, prueba con otra.",
                        color: Colors.white,
                        size: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TXTextWidget(
                        text:
                            "Nota: Hacemos referencia a sentir \"hambre\" después de realizar las comidas planificadas, con las cantidades y distribución adecuadas (barra verde). Si ello ocurre, es probable que lo que sientas sean ansias de comer y no hambre real o fisiológica.",
                        color: Colors.white,
                        size: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                )
              ]),
            ],
          ),
        ),
        TXLoadingWidget(
          loadingStream: bloc.isLoadingStream,
        ),
        StreamBuilder<bool>(
            stream: bloc.showFirstTimeResult,
            initialData: false,
            builder: (context, snapshotShow) {
              return snapshotShow.data
                  ? TXVideoIntroWidget(
                title: R.string.cravingHelper,
                onSeeVideo: () {
                  bloc.setNotFirstTime();
                  launch(Endpoint.planiCravingVideo);
//                          FileManager.playVideo("profile_settings.mp4");
                },
                onSkip: () {
                  bloc.setNotFirstTime();
                },
              )
                  : Container();
            })
      ],
    );
  }

  List<Widget> _getCravingsView(List<TitleSubTitlesModel> habits) {
    List<Widget> list = [];

    habits.forEach((h) {
      final w = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: TXTextWidget(
              text: h.number.toString(),
              color: R.color.craving_number_color,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              size: 50,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                TXTextWidget(
                  text: h.title,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  size: 14,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    ..._getHabitsSubtitles(h.subTitles)
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )
        ],
      );
      list.add(w);
    });

    return list;
  }

  List<Widget> _getHabitsSubtitles(List<String> subtitles) {
    List<Widget> list = [];
    subtitles.forEach((s) {
      final w = TXTextWidget(
        text: s,
        color: Colors.white,
        fontWeight: FontWeight.w500,
        size: 14,
      );
      list.add(w);
    });
    return list;
  }
}
