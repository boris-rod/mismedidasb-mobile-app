import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/domain/habit/habit_model.dart';
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
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_video_intro_widet.dart';
import 'package:mismedidasb/ui/habit/habit_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HabitPage extends StatefulWidget {
  final HealthConceptModel conceptModel;

  const HabitPage({Key key, this.conceptModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HabitState();
}

class _HabitState extends StateWithBloC<HabitPage, HabitBloC> {
  WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    bloc.loadData(widget.conceptModel.id);
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        TXCustomActionBar(
          showGifInfo: 1,
          actionBarColor: R.color.habits_color,
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
                  image: ExactAssetImage(R.image.habits_home_blur),
                ))),
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      R.image.habits_title,
                      width: 300,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                left: 40, bottom: 30, top: 0, right: 40),
                            width: double.infinity,
                            child: TXBlurWidget(),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 30, bottom: 30, top: 0, right: 40),
                            child: StreamBuilder<List<TitleSubTitlesModel>>(
                                stream: bloc.pollsResult,
                                initialData: [],
                                builder: (context, snapshot) {
                                  return SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.only(right: 10),
                                      child: Column(
                                        children: <Widget>[
                                          ..._getHabitsView(snapshot.data)
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    )
                  ])
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
                title: R.string.habitsHelper,
                onSeeVideo: () {
                  bloc.setNotFirstTime();
                  launch(Endpoint.planiHabitsVideo);
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

  List<Widget> _getHabitsView(List<TitleSubTitlesModel> habits) {
    List<Widget> list = [];

    habits.forEach((h) {
      final w = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: TXTextWidget(
              text: h.number.toString(),
              color: R.color.habits_number_color,
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
      final w = Column(
        children: <Widget>[
          s.contains("<https://link>")
              ? InkWell(
                  onTap: () {
                    launch("https://www.amazon.com/dp/B08DN2V7WL");
                  },
                  child: RichText(
                    text: TextSpan(
                        text: s.replaceFirst("<https://link>", ""),
                        children: [
                          TextSpan(
                              text: "saber más...",
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                  ),
                )
              : TXTextWidget(
                  text: s,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  size: 14,
                ),
          SizedBox(
            height: 3,
          )
        ],
      );
      list.add(w);
    });
    return list;
  }
}
