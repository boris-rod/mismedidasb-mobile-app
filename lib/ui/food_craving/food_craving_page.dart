import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
    bloc.loadData(widget.conceptModel.id);
  }
  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        TXMainAppBarWidget(
          title: widget.conceptModel.title,
          leading: TXIconButtonWidget(
            icon: Icon(Icons.close),
            onPressed: () {
              NavigationUtils.pop(context);
            },
          ),
          body: TXBackgroundWidget(
            iconRes: R.image.food_craving_home,
            imageUrl: widget.conceptModel.image,
            child: Container(
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
//                        Container(
//                          alignment: Alignment.center,
//                          padding: EdgeInsets.all(20),
//                          child: TXTextWidget(
//                            text: poll.name,
//                            size: 20,
//                          ),
//                        ),
                        Expanded(
                          child: SingleChildScrollView(
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
