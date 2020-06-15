import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
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
import 'package:mismedidasb/ui/food_craving/food_craving_bloc.dart';

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
          actionBarColor: R.color.craving_color,
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
                      final poll = snapshot.data.isNotEmpty ? snapshot.data[0] : null;
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
//                        TXTextWidget(
//                          textAlign: TextAlign.center,
//                          text: R.string.appClinicalWarningForAdvice,
//                          size: 10,
//                          color: R.color.accent_color,
//                        ),
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
}
