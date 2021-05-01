import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_dialog_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_divider_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_video_intro_widet.dart';
import 'package:mismedidasb/ui/plani_service/plani_service_bloc.dart';
import 'package:mismedidasb/ui/planifive_payment/planifive_payment_page.dart';
import 'package:mismedidasb/ui/profile/tx_plani_icon_widget.dart';
import 'package:mismedidasb/utils/calendar_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaniServicePage extends StatefulWidget {
  final UserModel userModel;
  final bool fromMenus;

  const PlaniServicePage({Key key, this.userModel, this.fromMenus = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlaniServiceState();
}

class _PlaniServiceState
    extends StateWithBloC<PlaniServicePage, PlaniServiceBloC> {
  @override
  void initState() {
    super.initState();
    widget.userModel == null
        ? bloc.loadProfileFirst()
        : bloc.loadData(widget.userModel);
    bloc.loadCoins();
    if(widget.fromMenus) {
      Fluttertoast.showToast(msg: "Para acceder a los menús active el servicio.");
    }
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: [
        TXMainAppBarWidget(
          title: R.string.planifiveServices,
          leading: TXIconButtonWidget(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              NavigationUtils.pop(context);
            },
          ),
          floatingActionButton: Container(
            margin: EdgeInsets.only(bottom: 20),
            child: FloatingActionButton(
              backgroundColor: R.color.food_green,
              child: Icon(Icons.add),
              onPressed: () async {
                final res =
                    await NavigationUtils.push(context, PlanifivePaymentPage());
                if (res ?? false) {
                  bloc.loadCoins();
                }
              },
            ),
          ),
          body: Container(
            child: StreamBuilder<List<SubscriptionModel>>(
              stream: bloc.subscriptionsResult,
              initialData: [],
              builder: (ctx, snapshotSubscriptions) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<int>(
                        builder: (ctx, snapshotCoins) {
                          return Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(right: 20, top: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TXTextWidget(text: "${R.string.coins}: "),
                                TXTextWidget(
                                  text: snapshotCoins.data.toString(),
                                  color: R.color.food_blue_dark,
                                  fontWeight: FontWeight.bold,
                                  size: 20,
                                ),
                                Image.asset(
                                  R.image.coins,
                                  width: 20,
                                  height: 20,
                                ),
                                // SizedBox(
                                //   width: 5,
                                // ),
                                // InkWell(
                                //   onTap: () async {
                                //     final res =
                                //         await NavigationUtils.push(
                                //         context,
                                //         PlanifivePaymentPage());
                                //     if (res ?? false) {
                                //       bloc.loadCoins();
                                //     }
                                //   },
                                //   child: Container(
                                //     // padding: EdgeInsets.all(3)
                                //     //     .copyWith(left: 5, right: 5),
                                //     // decoration: BoxDecoration(
                                //     //   borderRadius:
                                //     //       BorderRadius.all(Radius.circular(4)),
                                //     //   border: Border.all(
                                //     //       color: R.color.gray_darkest,
                                //     //       width: 1),
                                //     // ),
                                //       child: Icon(Icons.add_circle,color: R.color.food_green, size: 21,)),
                                // ),
                              ],
                            ),
                          );
                        },
                        stream: bloc.coinsResult,
                        initialData: 0,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            TXTextWidget(text: R.string.offerts),
                            Card(
                              elevation: 2,
                              color: R.color.food_green,
                              child: InkWell(
                                onTap: () {
                                  if (!_haveFullPackage(
                                      snapshotSubscriptions.data)) {
                                    _showBuyResume(
                                        context: context,
                                        serviceTitle: R.string.offert1Title,
                                        coins: 3000,
                                        onOK: () {
                                          bloc.buyOffer1().then((value) {
                                            if (value != null &&
                                                value is int &&
                                                value == 0) {
                                              _showBuyMoreDialog();
                                            }
                                          });
                                        });
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Todas sus suscripciones se encuentran activas",
                                        toastLength: Toast.LENGTH_LONG);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Column(
                                        children: [
                                          TXTextWidget(
                                            text: R.string.offert1Title,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            size: 16,
                                          ),
                                          TXTextWidget(
                                            text: R.string.offert1Description,
                                            color: R.color.gray_light,
                                            size: 14,
                                          ),
                                        ],
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                      )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      TXTextWidget(
                                        text: "3000",
                                        color: Colors.white,
                                      ),
                                      Image.asset(
                                        R.image.coins,
                                        width: 20,
                                        height: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TXDividerWidget(),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          itemCount: snapshotSubscriptions.data.length,
                          itemBuilder: (ctx, index) {
                            final model = snapshotSubscriptions.data[index];
                            return Card(
                              elevation: 2,
                              child: InkWell(
                                onTap: () {
                                  _showBuyResume(
                                      context: context,
                                      serviceTitle: model.name,
                                      coins: model.valueCoins,
                                      onOK: () {
                                        bloc
                                            .buySubscription(model)
                                            .then((value) {
                                          if (value != null &&
                                              value is int &&
                                              value == 0) {
                                            _showBuyMoreDialog();
                                          }
                                        });
                                      });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Column(
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                                text: model.name,
                                                children: [
                                                  TextSpan(
                                                      style: TextStyle(
                                                          color: model.isActive
                                                              ? R.color
                                                                  .food_green
                                                              : R.color
                                                                  .food_red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14),
                                                      text: model.isActive
                                                          ? " (${R.string.active} - ${model.validAt != null ? CalendarUtils.showInFormat("MMMd/yyyy", model.validAt) : ""})."
                                                          : " ${R.string.inactive}."),
                                                ]),
                                          ),
                                          TXTextWidget(
                                            text: model.description,
                                            color: R.color.gray_darkest,
                                            textAlign: TextAlign.justify,
                                            size: 14,
                                          ),
                                        ],
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                      )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      TXTextWidget(
                                        text: model.valueCoins.toString(),
                                      ),
                                      Image.asset(
                                        R.image.coins,
                                        width: 20,
                                        height: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                  padding: EdgeInsets.only(bottom: 40),
                );
              },
            ),
          ),
        ),
        TXLoadingWidget(
          loadingStream: bloc.isLoadingStream,
        ),
        StreamBuilder<bool>(
            stream: bloc.showFirstTimeResult,
            initialData: false,
            builder: (context, snapshotShow) {
              return snapshotShow.data
                  ? TXVideoIntroWidget(
                title: R.string.nutritionalReport,
                onSeeVideo: () {
                  bloc.setNotFirstTime();
                  launch(Endpoint.nutritionalReport);
//                          FileManager.playVideo("profile_settings.mp4");
                },
                onSkip: () {
                  bloc.setNotFirstTime();
                },
              )
                  : Container();
            }),
      ],
    );
  }

  void _showBuyMoreDialog() {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => TXCupertinoDialogWidget(
        title: "Fondos insuficientes",
        contentWidget: TXTextWidget(
          text: R.string.noEnoughCoinsToActivateService,
        ),
        okText: R.string.continueAction,
        onOK: () async {
          Navigator.pop(context);
          final res =
              await NavigationUtils.push(context, PlanifivePaymentPage());
          if (res ?? false) {
            bloc.loadCoins();
          }
        },
        onCancel: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showBuyResume(
      {BuildContext context, String serviceTitle, int coins, Function onOK}) {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => TXCupertinoDialogWidget(
        title: R.string.activateService,
        contentWidget: RichText(
          text: TextSpan(
              style: TextStyle(color: R.color.gray_darkest),
              text: R.string.activateServiceWarning1,
              children: [
                TextSpan(
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    text: serviceTitle),
                TextSpan(
                    style: TextStyle(color: R.color.gray_darkest),
                    text: R.string.activateServiceWarning2),
                TextSpan(
                    style: TextStyle(
                        color: R.color.accent_color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    text: "$coins "),
                TextSpan(
                    style: TextStyle(color: R.color.gray_darkest),
                    text: R.string.activateServiceWarning3),
              ]),
        ),
        okText: R.string.continueAction,
        onOK: () {
          Navigator.pop(context);
          onOK();
        },
        onCancel: () {
          Navigator.pop(context, R.string.cancel);
        },
      ),
    );
  }

  bool _haveFullPackage(List<SubscriptionModel> subscriptions) {
    for (int i = 0; i < subscriptions.length; i++) {
      if (!subscriptions[i].isActive) return false;
    }
    return true;
  }
}
