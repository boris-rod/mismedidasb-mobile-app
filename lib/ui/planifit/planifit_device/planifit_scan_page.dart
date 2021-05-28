import 'package:flutter/material.dart';
import 'package:mismedidasb/domain/planifit/planifit_model.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
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
        title: "Scan",
        body: StreamBuilder<WatchScanStatus>(
            stream: bloc.scanResult,
            initialData: WatchScanStatus.Scanning,
            builder: (context, snapshot) {
              final scanStatus = snapshot.data;
              return Container(
                child: scanStatus == WatchScanStatus.Discovered
                    ? _getDevicesListWidget(context)
                    : scanStatus == WatchScanStatus.Scanning
                        ? _getScanningWidget(context)
                        : _getStartScanWidget(context),
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

  Widget _getStartScanWidget(BuildContext context) {
    return Center(
      child: TXButtonWidget(
        title: "Scan",
        onPressed: () {
          bloc.scan();
        },
      ),
    );
  }

  Widget _getDevicesListWidget(BuildContext context) {
    return StreamBuilder<Map<String, BleDevice>>(
        stream: bloc.devicesDataResult,
        initialData: Map<String, BleDevice>(),
        builder: (context, snapshot) {
          final map = snapshot.data.values.toList();
          return ListView.builder(
            itemBuilder: (ctx, index) {
              final model = map[index];
              return ListTile(
                onTap: () {
                  NavigationUtils.pop(context, result: model);
                },
                title: TXTextWidget(
                  text: model.name,
                ),
                subtitle: TXTextWidget(
                  text: model.address,
                ),
                trailing: TXTextWidget(
                  text: model.rssi.toString(),
                ),
              );
            },
            itemCount: map.length,
          );
        });
  }
}
