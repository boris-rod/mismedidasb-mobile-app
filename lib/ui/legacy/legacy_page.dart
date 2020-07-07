import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/domain/legacy/legacy_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_checkbox_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/legacy/legacy_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LegacyPage extends StatefulWidget {
  final int contentType;
  final bool termsCondAccepted;

  const LegacyPage({Key key, this.contentType, this.termsCondAccepted = true})
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
            backgroundColorAppBar: R.color.profile_options_color,
            title: bloc.getTitleBar(widget.contentType),
            leading: widget.termsCondAccepted
                ? TXIconButtonWidget(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      NavigationUtils.pop(context);
                    },
                  )
                : null,
            actions: <Widget>[Image.asset(R.image.logo)],
            centeredTitle: true,
            body: Container(
              color: R.color.profile_options_color,
              child: StreamBuilder<LegacyModel>(
                stream: bloc.legacyResult,
                initialData: null,
                builder: (ctx, snapshot) {
                  return snapshot.data == null
                      ? Container()
                      : Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Html(
                                    onLinkTap: (link) {
                                      _launchURL(link);
                                    },
                                    shrinkWrap: true,
                                    data: snapshot.data.content,
                                    style: {
                                      "p>*": Style(
                                        color: Colors.white,
                                      ),
                                      "p>a": Style(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      "p": Style(color: Colors.white),
                                      "ul": Style(color: Colors.white),
                                      "li": Style(color: Colors.white),
                                      "li>*": Style(color: Colors.white),
                                    },
                                  ),
                                  physics: BouncingScrollPhysics(),
                                ),
//                  WebView(
//                                initialUrl: 'about:blank',
//                                onWebViewCreated:
//                                    (WebViewController webViewController) {
//                                  _controller = webViewController;
//                                  _loadHtmlFromAssets(snapshot.data.content);
//                                },
//                              ),
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
                          ),
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
    _controller.loadUrl(Uri.dataFromString(
            '<html><body style="background-color: #194F7D">$html</body></html>',
            mimeType: 'text/html',
            encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
