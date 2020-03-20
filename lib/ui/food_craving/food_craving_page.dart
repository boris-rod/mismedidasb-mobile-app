import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_background_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class FoodCravingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TXMainAppBarWidget(
      title: "Controlar el ansia",
      leading: TXIconButtonWidget(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          NavigationUtils.pop(context);
        },
      ),
      body: TXBackgroundWidget(
        iconRes: R.image.food_craving_home,
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(20),
                      child: TXTextWidget(
                        text: "Controlar el ansia por la comida",
                        size: 20,
                        textAlign: TextAlign.center,
                      ),
                    ),
//            TXTextWidget(
//              text: "-	el olor a eucalipto, pomada china o menta.",
//              color: Colors.black,
//              size: 20,
//            ),
//            SizedBox(
//              height: 20,
//            ),
                    TXTextWidget(
                      text:
                          "Si notas “hambre” o un deseo intenso de comer tras realizar tus comidas planificadas, con las cantidades y distribución adecuada (barra verde), es probable que sean ansias de comer y no hambre real. Para ello te brindamos a continuación un grupo de sugerencias para que puedas gestionar estos momentos.",
                      textAlign: TextAlign.justify,
                      color: R.color.primary_color,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TXTextWidget(
                      text:
                          "Estas sugerencias no tienen un orden específico, ni frecuencia determinada. Escoja la que mejor le parezca y utilícela en dependencia de la situación:",
                      textAlign: TextAlign.justify,
                      color: R.color.primary_color,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TXTextWidget(
                      text:
                          "Una vez que ha terminado de comer los alimentos planificados, espere 20 minutos si siente deseos de repetir.",
                      textAlign: TextAlign.justify,
                      color: R.color.primary_color,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TXTextWidget(
                      text: "1. Dar un paseo caminando durante 15 o 20 minutos.",
                      textAlign: TextAlign.justify,
                      color: R.color.primary_color,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TXTextWidget(
                      text:
                          "2. Beber un vaso de agua a sorbos pequeños durante 20 minutos.",
                      textAlign: TextAlign.justify,
                      color: R.color.primary_color,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TXTextWidget(
                      text:
                          "3. Describa sus metas, proyectos y aspiraciones en una extensión no mayor a un folio.",
                      textAlign: TextAlign.justify,
                      color: R.color.primary_color,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TXTextWidget(
                      text: "4. Jugar al Tetris  de 3-5 minutos.",
                      color: R.color.primary_color,
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TXTextWidget(
                      text:
                          "5. Imagine lo más vívidamente posible una de las siguientes opciones durante 5 minutos:",
                      textAlign: TextAlign.justify,
                      color: R.color.primary_color,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          children: <Widget>[
                            TXTextWidget(
                              text:
                                  "-	que está realizando su actividad favorita.",
                              textAlign: TextAlign.justify,
                              color: R.color.accent_color,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TXTextWidget(
                              text:
                                  "-	el olor a eucalipto, pomada china o menta.",
                              color: R.color.accent_color,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TXTextWidget(
                              text:
                                  "-	que come el alimento deseado 33 veces, a razón de 1 porción cada vez.",
                              textAlign: TextAlign.justify,
                              color: R.color.accent_color,
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TXTextWidget(
                textAlign: TextAlign.center,
                text: R.string.appClinicalWarningForAdvice,
                size: 10,
                color: R.color.accent_color,
              ),
            )
          ],
        ),
      ),
    );
  }
}
