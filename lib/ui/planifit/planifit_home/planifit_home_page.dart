import 'package:flutter/material.dart';
import 'package:mismedidasb/domain/planifit/planifit_model.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/planifit/planifit_device/planifit_scan_page.dart';
import 'package:mismedidasb/ui/planifit/planifit_home/planifit_home_bloc.dart';

class PlanifitHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlanifitState();
}

class _PlanifitState extends StateWithBloC<PlanifitHomePage, PlanifitHomeBloC> {
  @override
  void initState() {
    super.initState();
    bloc.init();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return TXMainAppBarWidget(
        title: "Planifit",
        body: Container(
          child: TXButtonWidget(
            title: "Scan",
            onPressed: () async{
              final result = await NavigationUtils.push(context, PlanifitScanPage());
              if(result != null && result is BleDevice){
                bloc.connect(address: result.address);
              }
            },
          ),
        ));
  }
}
