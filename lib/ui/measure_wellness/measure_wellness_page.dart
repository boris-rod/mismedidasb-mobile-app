import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/measure_wellness/measure_wellness_bloc.dart';

class MeasureWellnessPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MeasureWellnessState();
}

class _MeasureWellnessState
    extends StateWithBloC<MeasureWellnessPage, MeasureWellnessBloC> {
  @override
  Widget buildWidget(BuildContext context) {
    return TXMainAppBarWidget(
      leading: TXIconButtonWidget(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          NavigationUtils.pop(context);
        },
      ),
      title: R.string.myMeasureWellness,
      body: Container(),
    );
  }
}
