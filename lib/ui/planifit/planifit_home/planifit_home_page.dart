import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mismedidasb/domain/planifit/planifit_model.dart';
import 'package:mismedidasb/enums.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/planifit/planifit_device/planifit_scan_page.dart';
import 'package:mismedidasb/ui/planifit/planifit_home/planifit_home_bloc.dart';
import 'package:mismedidasb/ui/planifit/planifit_home/planifit_home_model_UI.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PlanifitHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlanifitState();
}

class _PlanifitState extends StateWithBloC<PlanifitHomePage, PlanifitHomeBloC>
    with TickerProviderStateMixin {
  final double expandedHeight = 320.0;
  final double circularProgressSize = 100;
  RefreshController _refreshController = RefreshController();

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
          return Container(
            color: R.color.primary_color,
            child: SafeArea(
              bottom: false,
              right: false,
              left: false,
              child: Scaffold(
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
              ),
            ),
          );
        });
  }

  Widget _getHomePage(PlanifitHomeModelUI model) {
    var top = 0.0;
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: expandedHeight,
              floating: false,
              pinned: true,
              actions: [
                Container(
                  margin: EdgeInsets.only(right: 15, top: 10, bottom: 10),
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(45)),
                        onTap: () {},
                        child: Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.all(Radius.circular(45)),
                              border: Border.all(color: Colors.grey.withOpacity(0.1),width: 1),
                            ),
                            child: Icon(
                              Icons.watch,
                              color: Colors.white.withOpacity(0.3),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: R.color.white_color,
                ),
                onPressed: () {
                  NavigationUtils.pop(context);
                },
              ),
              flexibleSpace: LayoutBuilder(
                builder: (context, constraint) {
                  top = constraint.biggest.height;
                  return FlexibleSpaceBar(
                    title: SizedBox(
                      height: expandedHeight / 2 + kToolbarHeight,
                      child: Container(
                        child: Center(
                            child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.0, end: 0.7),
                          duration: const Duration(milliseconds: 1000),
                          builder: (context, value, _) => AbsorbPointer(
                            child: Stack(
                              children: [
                                AnimatedOpacity(
                                  opacity: top <= circularProgressSize
                                      ? 0
                                      : top / expandedHeight,
                                  duration: Duration(milliseconds: 100),
                                  child: Center(
                                    child: SizedBox(
                                      height: circularProgressSize,
                                      width: circularProgressSize,
                                      child: CircularProgressIndicator(
                                        value: value,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                        backgroundColor:
                                            R.color.food_blue_light,
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: TXTextWidget(
                                    text: "${(value * 8000).round()}",
                                    fontWeight: FontWeight.bold,
                                    color: R.color.white_color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.zero,
              sliver: new SliverList(
                delegate: new SliverChildListDelegate([
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
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
        body: SmartRefresher(
          controller: _refreshController,
          enablePullUp: false,
          physics: ClampingScrollPhysics(),
          header: WaterDropMaterialHeader(
            backgroundColor: R.color.primary_color,
            distance: 40,
          ),
          onLoading: () {
            Future.delayed(Duration(seconds: 2), () {
              _refreshController.loadComplete();
            });
          },
          onRefresh: () {
            Future.delayed(Duration(seconds: 2), () {
              _refreshController.refreshCompleted();
            });
          },
          child: Container(
            child: Text(
              "Collapsing Toolbar",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
          ),
        ));
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
    return SafeArea(
      child: Container(
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
                  bloc.planifitHomeModelUI.selectedTab = 0;
                  bloc.refreshData;
                }
              },
              title: R.string.addNewDevice)
        ],
      ),
    );
  }
}
