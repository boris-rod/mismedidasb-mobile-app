import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mismedidasb/domain/legacy/legacy_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_checkbox_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/legacy/legacy_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LegacyPage extends StatefulWidget {
  final int contentType;
  final bool termsCondAccepted;

  const LegacyPage({Key key, this.contentType, this.termsCondAccepted = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _LegacyState();
}

class _LegacyState extends StateWithBloC<LegacyPage, LegacyBloC> {
  WebViewController _controller;

  @override
  void initState() {
    super.initState();
    bloc.loadData(widget.contentType);
    bloc.termsCondResult.listen((onData) {
      _navBack();
    });
  }

  void _navBack() {
    NavigationUtils.pop(context, result: bloc.termsCondAccepted);
  }

  @override
  Widget buildWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navBack();
        return false;
      },
      child: Stack(
        children: <Widget>[
          TXMainAppBarWidget(
            title: widget.contentType == 0
                ? R.string.privacyPolicies
                : R.string.termsCond,
            leading: widget.termsCondAccepted
                ? TXIconButtonWidget(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      NavigationUtils.pop(context);
                    },
                  )
                : null,
            centeredTitle: true,
            body: Container(
              child: StreamBuilder<LegacyModel>(
                stream: bloc.legacyResult,
                initialData: null,
                builder: (ctx, snapshot) {
                  return snapshot.data == null
                      ? Container()
                      : Column(
                          children: <Widget>[
                            Expanded(
                              child: WebView(
                                initialUrl: 'about:blank',
                                onWebViewCreated:
                                    (WebViewController webViewController) {
                                  _controller = webViewController;
                                  _loadHtmlFromAssets(snapshot.data.content);
                                },
                              ),
                            ),
                            !widget.termsCondAccepted
                                ? Container(
                                    child: TXCheckBoxWidget(
                                      text: R.string.iAgree,
                                      leading: true,
                                      value: false,
                                      onChange: (value) {
                                        bloc.acceptTermsCond();
                                      },
                                    ),
                                  )
                                : Container()
                          ],
                        );
                },
              ),
            ),
          ),
          TXLoadingWidget(
            loadingStream: bloc.isLoadingStream,
          )
        ],
      ),
    );
  }

  _loadHtmlFromAssets(String html) async {
    _controller.loadUrl(Uri.dataFromString(html,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
