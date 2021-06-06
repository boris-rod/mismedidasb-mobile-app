import 'package:flutter/material.dart';
import 'package:mismedidasb/domain/planifit/planifit_model.dart';
import 'package:mismedidasb/enums.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/planifit/planifit_device/planifit_scan_page.dart';
import 'package:mismedidasb/ui/planifit/planifit_home/planifit_home_bloc.dart';
import 'package:mismedidasb/ui/planifit/planifit_home/planifit_home_model_UI.dart';

class PlanifitHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlanifitState();
}

class _PlanifitState extends StateWithBloC<PlanifitHomePage, PlanifitHomeBloC> {
  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    bloc.init();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return StreamBuilder<PlanifitHomeModelUI>(
        stream: bloc.mainResult,
        initialData: bloc.planifitHomeModelUI,
        builder: (context, snapshot) {
          final model = snapshot.data;
          return Scaffold(
            body: model.selectedTab == 0
                ? _getHomePage(model)
                : model.selectedTab == 1
                    ? _getDevicePage(model)
                    : Container(
                        child: TXTextWidget(
                          text: "Vacio",
                        ),
                      ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: R.color.gray_light,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: model.selectedTab == 0
                        ? R.color.primary_color
                        : R.color.gray,
                  ),
                  label: R.string.home,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.watch,
                    color: model.selectedTab == 1
                        ? R.color.primary_color
                        : R.color.gray,
                  ),
                  label: R.string.device,
                ),
              ],
              currentIndex: model.selectedTab,
              onTap: (index) {
                if (index != bloc.planifitHomeModelUI.selectedTab) {
                  bloc.planifitHomeModelUI.selectedTab = index;
                  bloc.refreshData;
                }
              },
            ),
          );
        });
  }

  Widget _getHomePage(PlanifitHomeModelUI model) {
    return Container(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Container(
                  width: 150,
                  height: 100,
                  color: R.color.blue_transparent,
                ),
                background: Container(
                  color: R.color.primary_color,
                ),
              ),
            ),
            new SliverPadding(
              padding: new EdgeInsets.all(0.0),
              sliver: new SliverList(
                delegate: new SliverChildListDelegate([
                  Container(
                      color: R.color.primary_color,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: _getMainDataHeaderWidget(
                                title: R.string.goal, subTitle: "8000"),
                          ),
                          Expanded(
                            flex: 1,
                            child: _getMainDataHeaderWidget(
                                title: R.string.distance, subTitle: "0.02km"),
                          ),
                          Expanded(
                            flex: 1,
                            child: _getMainDataHeaderWidget(
                                title: R.string.calories, subTitle: "1.1kcal"),
                          )
                        ],
                      )),
                ]),
              ),
            ),
          ];
        },
        body: Container(
          child: Text(
            "Collapsing Toolbar",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getMainDataHeaderWidget({String title, String subTitle}) {
    return Container(
      child: Column(
        children: [
          TXTextWidget(
            text: title,
            size: 12,
            fontWeight: FontWeight.w300,
            color: R.color.white_color,
          ),
          TXTextWidget(
            text: subTitle,
            size: 16,
            fontWeight: FontWeight.bold,
            color: R.color.white_color,
          ),
        ],
      ),
    );
  }

  Widget _getDevicePage(PlanifitHomeModelUI model) {
    return model.connectedStatus == WatchConnectedStatus.Connected
        ? _getDevicePagePaired(model)
        : _getDevicePageNotPaired(model);
  }

  Widget _getDevicePagePaired(PlanifitHomeModelUI model) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            TXButtonWidget(
                onPressed: () {
                  bloc.disconnect();
                },
                title: R.string.unpair)
          ],
        ),
      ),
    );
  }

  Widget _getDevicePageNotPaired(PlanifitHomeModelUI model) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            color: R.color.primary_color,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TXTextWidget(
                  textAlign: TextAlign.center,
                  text: R.string.addDeviceInfo,
                  color: R.color.white_color,
                ),
              ),
            ),
          ),
          TXButtonWidget(
              onPressed: () async {
                final result =
                    await NavigationUtils.push(context, PlanifitScanPage());
                if (result ?? false) {
                  bloc.planifitHomeModelUI.connectedStatus =
                      WatchConnectedStatus.Connected;
                  bloc.refreshData;
                }
              },
              title: R.string.addNewDevice)
        ],
      ),
    );
  }
}
