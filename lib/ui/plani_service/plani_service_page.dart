import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:mismedidasb/ui/plani_service/plani_service_bloc.dart';
import 'package:mismedidasb/ui/profile/tx_plani_icon_widget.dart';
import 'package:mismedidasb/utils/calendar_utils.dart';

class PlaniServicePage extends StatefulWidget {
  final UserModel userModel;

  const PlaniServicePage({Key key, this.userModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlaniServiceState();
}

class _PlaniServiceState
    extends StateWithBloC<PlaniServicePage, PlaniServiceBloC> {
  @override
  void initState() {
    super.initState();
    bloc.loadData(widget.userModel);
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: [
        TXMainAppBarWidget(
          title: "Servicios de Planifive",
          leading: TXIconButtonWidget(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              NavigationUtils.pop(context);
            },
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
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            TXTextWidget(text: "Ofertas"),
                            Card(
                              elevation: 2,
                              color: R.color.food_green,
                              child: InkWell(
                                onTap: () {
                                  _showBuyResume(
                                      context: context,
                                      serviceTitle:
                                          "Plani + Reporte alimenticio + Reporte nutricional",
                                      coins: 2500,
                                      onOK: () {
                                        bloc.buyOffer1();
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
                                          TXTextWidget(
                                            text:
                                                "Plani + Reporte alimenticio + Reporte nutricional",
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            size: 16,
                                          ),
                                          TXTextWidget(
                                            text:
                                                "Todos los servicios de Planifive",
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
                                        text: "2500",
                                        color: Colors.white,
                                      ),
                                      Icon(
                                        Icons.verified,
                                        size: 14,
                                        color: Colors.white,
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
                                        bloc.buySubscription(model);
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
                                                              FontWeight.normal,
                                                          fontSize: 14),
                                                      text: model.isActive
                                                          ? " activo"
                                                          : " inactivo"),
                                                ]),
                                          ),
                                          TXTextWidget(
                                            text: model.description,
                                            color: R.color.gray,
                                            textAlign: TextAlign.justify,
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
                                        text: model.valueCoins.toString(),
                                      ),
                                      Icon(
                                        Icons.verified,
                                        size: 14,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        TXLoadingWidget(
          loadingStream: bloc.isLoadingStream,
        )
      ],
    );
  }

  void _showBuyResume(
      {BuildContext context, String serviceTitle, int coins, Function onOK}) {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => TXCupertinoDialogWidget(
        title: "Activar servicio(s)",
        contentWidget: RichText(
          text: TextSpan(
              style: TextStyle(color: R.color.gray_darkest),
              text: "Está a punto de adquirir: ",
              children: [
                TextSpan(
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    text: serviceTitle),
                TextSpan(
                    style: TextStyle(color: R.color.gray_darkest),
                    text: " por el plazo de 1 mes. Se descontarán "),
                TextSpan(
                    style: TextStyle(
                        color: R.color.accent_color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    text: "$coins "),
                TextSpan(
                    style: TextStyle(color: R.color.gray_darkest),
                    text: "monedas."),
              ]),
        ),
        okText: "Continuar",
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
}
