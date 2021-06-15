import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/domain/planifit/planifit_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_divider_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/planifit/planifit_device/planifit_scan_bloc.dart';

import '../../../enums.dart';

class PlanifitScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlanifitScanState();
}

class _PlanifitScanState
    extends StateWithBloC<PlanifitScanPage, PlanifitScanBloC> {
  @override
  void dispose() {
    bloc.stopScan();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    bloc.init();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return TXMainAppBarWidget(
        title: R.string.scan,
        body: StreamBuilder<WatchScanStatus>(
            stream: bloc.scanResult,
            initialData: WatchScanStatus.Scanning,
            builder: (context, snapshot) {
              final scanStatus = snapshot.data;
              return Container(
                child: scanStatus == WatchScanStatus.Scanning
                    ? _getScanningWidget(context)
                    : _getDevicesListWidget(context),
              );
            }));
  }

  Widget _getScanningWidget(BuildContext context) {
    return Center(
      child: TXTextWidget(
        text: "Scanning",
      ),
    );
  }

  Widget _getDevicesListWidget(BuildContext context) {
    final List<BleDevice> list = bloc.bleMap.values.toList();
    return ListView.builder(
      itemBuilder: (ctx, index) {
        final model = list[index];
        return ListTile(
          onTap: () async {
            final status = await bloc.connect(address: model.address);
            if (status == WatchConnectedStatus.Disconnected) {
              Fluttertoast.showToast(
                  msg: "BLE no conectado",
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  toastLength: Toast.LENGTH_LONG);
            } else
              NavigationUtils.pop(context, result: true);
          },
          title: TXTextWidget(
            text: model.name,
          ),
          subtitle: TXTextWidget(
            text: "MAC: ${model.address}",
            color: R.color.gray,
            size: 13,
          ),
          trailing: TXTextWidget(
            text: model.rssi.toString(),
          ),
        );
      },
      itemCount: list.length,
    );
  }
}
