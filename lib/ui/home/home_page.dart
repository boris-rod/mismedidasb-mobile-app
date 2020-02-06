import 'package:flutter/material.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/home/home_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends StateWithBloC<HomePage, HomeBloC> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bloc.asd();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return TXMainAppBarWidget(
      title: "Mis medidas",
      body: Stack(
        children: <Widget>[
          GridView.count(
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 2
                    : 4,
            children: <Widget>[],
          ),
          TXLoadingWidget(
            loadingStream: bloc.isLoadingStream,
          )
        ],
      ),
    );
  }
}
