import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/measure_value/measure_value_bloc.dart';

class MeasureValuePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MeasureValueState();

}

class _MeasureValueState extends StateWithBloC<MeasureValuePage, MeasureValueBloC>{

  @override
  void initState() {
    super.initState();
    bloc.loadMeasures();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return TXMainAppBarWidget(
      leading: TXIconButtonWidget(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          NavigationUtils.pop(context);
        },
      ),
      title: R.string.myMeasureValues,
      body: Stack(
        children: <Widget>[
          TXLoadingWidget(
            loadingStream: bloc.isLoadingStream,
          )
        ],
      ),
    );
  }

}