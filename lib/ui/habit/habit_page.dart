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
        TXMainAppBarWidget(
          leading: TXIconButtonWidget(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              NavigationUtils.pop(context);
            },
          ),
          title: widget.conceptModel.title,
          body: TXBackgroundWidget(
            iconRes: R.image.habits_home,
            imageUrl: widget.conceptModel.image,
            child: Container(
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
//                              Container(
//                                alignment: Alignment.center,
//                                padding: EdgeInsets.all(20),
//                                child: TXTextWidget(
//                                  text: poll.name,
//                                  size: 20,
//                                ),
//                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Html(
                                    data: poll.htmlContent,
                                  ),
                                ),
                              ),
//                              Expanded(
//                                child: WebView(
//                                  initialUrl: 'about:blank',
//                                  onWebViewCreated: (controller) {
//                                    _webViewController = controller;
//                                    _loadHtmlInWebView(poll.htmlContent);
//                                  },
//                                ),
//                              ),
//                        TXTextWidget(
//                          textAlign: TextAlign.center,
//                          text: R.string.appClinicalWarningForAdvice,
//                          size: 10,
//                          color: R.color.accent_color,
//                        ),
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

  _loadHtmlInWebView(String htmlContent) {
    _webViewController.loadUrl(Uri.dataFromString('<html><body>$htmlContent</body></html>',
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
