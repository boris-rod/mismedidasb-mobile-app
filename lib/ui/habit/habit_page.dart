import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mismedidasb/domain/habit/habit_model.dart';
import 'package:mismedidasb/domain/health_concept/health_concept.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_background_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_custom_action_bar.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/habit/habit_bloc.dart';
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
          body: Stack(
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image:
                        ExactAssetImage(R.image.food_craving_home_blur),
                      ))),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: StreamBuilder<List<PollModel>>(
                    stream: bloc.pollsResult,
                    initialData: [],
                    builder: (context, snapshot) {
                      final poll =
                      snapshot.data.isNotEmpty ? snapshot.data[0] : null;
                      return poll == null
                          ? Container()
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.asset(
                            R.image.craving_title,
                            width: 300,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Html(
                                data: poll.htmlContent,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              )
            ],
          ),
        ),
        TXLoadingWidget(
          loadingStream: bloc.isLoadingStream,
        )
      ],
    );
  }

  _loadHtmlInWebView(String htmlContent) {
    _webViewController.loadUrl(Uri.dataFromString('<html><body>$htmlContent</body></html>',
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
