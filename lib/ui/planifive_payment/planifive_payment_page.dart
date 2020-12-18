import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_dialog_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_divider_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/planifive_payment/planifive_payment_bloc.dart';
import 'package:mismedidasb/utils/calendar_utils.dart';

class PlanifivePaymentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlanifivePaymentState();
}

class _PlanifivePaymentState
    extends StateWithBloC<PlanifivePaymentPage, PlanifivePaymentBloC> {
  @override
  void initState() {
    super.initState();
    bloc.initPayment();
    bloc.loadProducts();
    bloc.paymentResult.listen((event) {
      NavigationUtils.pop(context, result: true);
    });
    bloc.showSavedCardsResult.listen((cards) {
      showTXModalBottomSheet(
          context: context,
          builder: (context) {
            return savedCards(context);
          });
    });
    bloc.showSaveCardResult.listen((event) {
      saveCard(context);
    });
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: [
        TXMainAppBarWidget(
          title: "Comprar monedas",
          leading: TXIconButtonWidget(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              NavigationUtils.pop(context);
            },
          ),
          body: Container(
            child: StreamBuilder<List<PlanifiveProductsModel>>(
              stream: bloc.productsResult,
              initialData: [],
              builder: (ctx, snapshotProducts) {
                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    itemCount: snapshotProducts.data.length,
                    itemBuilder: (ctx, index) {
                      final model = snapshotProducts.data[index];
                      return Card(
                        elevation: 2,
                        child: InkWell(
                          onTap: () {
                            bloc.addPayment(model.id);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Column(
                                  children: [
                                    TXTextWidget(
                                      text: model.name,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      size: 16,
                                    ),
                                    TXTextWidget(
                                      text: model.description,
                                      color: R.color.gray,
                                      size: 14,
                                    ),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                )),
                                Row(
                                  children: [
                                    TXTextWidget(
                                      text: "${model.price.toString()}",
                                      fontWeight: FontWeight.bold,
                                      size: 18,
                                    ),
                                    Icon(Icons.euro, size: 15,)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
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

  Widget savedCards(BuildContext context) {
    return Container(
      height: 300,
      child: StreamBuilder<List<CreditCardModel>>(
          stream: bloc.cardsResult,
          initialData: [],
          builder: (context, snapshot) {
            final cards = snapshot.data;
            return Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TXTextWidget(
                            text: "Tarjetas", color: Colors.black, size: 18),
                      ),
                      TXButtonWidget(
                        onPressed: () {
                          NavigationUtils.pop(context);
                          bloc.payWithCardFormRequest();
                        },
                        title: "Usar otra tarjeta",
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    final card = cards[index];
                    return Column(
                      children: [
                        ListTile(
                          onTap: () {
                            NavigationUtils.pop(context);
                            confirmCardUsage(context, card);
                          },
                          selected: true,
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  child: TXTextWidget(
                                    text: "**** **** **** ",
                                    size: 35,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  margin: EdgeInsets.only(top: 5)),
                              TXTextWidget(
                                text: "${card.last4}",
                                size: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              TXTextWidget(text: "Exp:"),
                              SizedBox(
                                width: 10,
                              ),
                              TXTextWidget(
                                text: "${card.expMonth}/${card.expYear}",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )
                            ],
                          ),
                          trailing: TXIconButtonWidget(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              if (cards.length <= 1) {
                                NavigationUtils.pop(context);
                              }
                              bloc.removeCardFromSavedList(card);
                            },
                          ),
                        ),
                        TXDividerWidget()
                      ],
                    );
                  },
                  itemCount: cards.length,
                ))
              ],
            );
          }),
    );
  }

  void saveCard(BuildContext context) {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => TXCupertinoDialogWidget(
        title: "Salvar tarjeta",
        content:
            "Desea salvar los datos de esta tarjeta para usarla en pagos futuros?",
        onOK: () {
          bloc.confirmPayment(true);
          Navigator.pop(context);
        },
        onCancel: () {
          bloc.confirmPayment(false);
          Navigator.pop(context);
        },
        okText: "Salvar",
        cancelText: "No salvar",
      ),
    );
  }

  void confirmCardUsage(BuildContext context, CreditCardModel card) {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => TXCupertinoDialogWidget(
        title: "Tarjeta de pago",
        content:
        "Desea usar la tarjeta **** **** **** ${card.last4} para realizar la compra de monedas?",
        onOK: () {
          bloc.confirmPayment(true, paymentMethodId: card.paymentMethodId);
          Navigator.pop(context);
        },
        onCancel: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
