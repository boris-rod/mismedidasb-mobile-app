import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';

class TXInstructionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 10, right: 20,bottom: 30),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TXTextWidget(
                    text: R.string.foodInstructionsTitle,
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                    size: 18,
                  ),
                ),
                Container(
                  width: 50,
                  child: TXTextLinkWidget(
                    title: R.string.ok,
                    textColor: R.color.primary_color,
                    onTap: () {
                      NavigationUtils.pop(context);
                    },
                  ),
                )
              ],
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TXTextWidget(
                      textAlign: TextAlign.justify,
                      fontWeight: FontWeight.bold,
                      text: "¡Planifica tu alimentación diaria!"),
                  TXTextWidget(
                      textAlign: TextAlign.justify,
                      text:
                          "Nuestra App te brinda la posibilidad de realizar una planificación de tu alimentación diaria ajustada a tus necesidades. Toma en cuenta para ello tu peso, estatura, edad, sexo y práctica de ejercicio físico. No se trata de una dieta, aunque se basa en la moderación en la ingestión de los alimentos. "),
                  SizedBox(
                    height: 10,
                  ),
                  TXTextWidget(
                      textAlign: TextAlign.justify,
                      fontWeight: FontWeight.bold,
                      text:
                          "¡Guarda tu planificación para que puedas utilizarla otro día!"),
                  TXTextWidget(
                      textAlign: TextAlign.justify,
                      text:
                          "Con el objetivo de que puedas optimizar tu tiempo, tienes la posibilidad de guardar tus planes de comida para que puedas utilizarlos en otra ocasión sin tener que empezar desde cero en cada ocasión. Lo puedes guardar tal y como lo tenías o bien puedes realizar ligeras modificaciones."),
                  SizedBox(
                    height: 10,
                  ),
                  TXTextWidget(
                      textAlign: TextAlign.justify,
                      fontWeight: FontWeight.bold,
                      text:
                          "¡Mide las porciones solamente usando las dimensiones de tu mano!"),
                  TXTextWidget(
                      textAlign: TextAlign.justify,
                      text:
                          "Hemos calculado las porciones de forma sencilla, las puedes medir usando las dimensiones tu mano y sentido común. No significa que debas tomar los alimentos con tus manos, o en tus manos, para comerlos o servirlos. Se trata solo de una guía visual basada en un cálculo aproximado."),
                  SizedBox(
                    height: 10,
                  ),
                  TXTextWidget(
                      textAlign: TextAlign.justify,
                      fontWeight: FontWeight.bold,
                      text: "¡Una planificación anti-atracones!"),
                  TXTextWidget(
                      textAlign: TextAlign.justify,
                      text:
                          "Con el objetivo de que puedas realizar una planificación lo más variada posible de todas tus comidas y que evites la tentación de comer en exceso, solo se permite seleccionar un ítem cada vez. Da igual que sea una fruta, una pequeña tostada o un sándwich, solo puedes elegir uno en cada comida del día. Recuerda que la idea es espaciar las comidas a lo largo del día, el principio es comer menos, pero de forma más variada y más veces al día."),
                  SizedBox(
                    height: 10,
                  ),
                  TXTextWidget(
                      textAlign: TextAlign.justify,
                      fontWeight: FontWeight.bold,
                      text: "¿Cómo saber si mi planificación es adecuada?"),
                  TXTextWidget(
                      textAlign: TextAlign.justify,
                      text:
                          "Te brindamos una guía visual de la adecuación de tu selección en cuanto a calorías y balance de proteínas, grasas, carbohidratos y fibra por día. Podrás visualizar si te acerca o alejas del porcentaje adecuado, pero no ofreceremos la cantidad de calorías o peso. Hemos observado en nuestra práctica clínica que numerosas personas pueden obsesionarse con estas cifras."),
                  TXTextWidget(
                      textAlign: TextAlign.justify,
                      text:
                          "También te brindamos un estimado de cómo debe ser el balance de tu plato en desayuno, comida y cena. Sin embargo, este cálculo es solo una aproximación didáctica, por lo que debes guiarte por el ajuste al balance diario que se ofrece en la parte superior de la pantalla."),
                  SizedBox(
                    height: 10,
                  ),
                  TXTextWidget(
                      textAlign: TextAlign.justify,
                      fontWeight: FontWeight.bold,
                      text: "¿Cómo seleccionar los alimentos?"),
                  TXTextWidget(
                      textAlign: TextAlign.justify,
                      text:
                          "Puedes teclear directamente el nombre del alimento en el buscador o buscar dentro de una categoría específica, eliminando las restantes. Puedes elegir un sándwich de jamo y queso o componer el mismo bocadillo desde sus elementos básicos."),
                  TXTextWidget(
                      textAlign: TextAlign.justify,
                      text:
                          "De igual forma, si eliges un café, debes elegir también el azúcar si quieres que la tenga. Si eliges una ensalada, debes también agregar el aceite, el vinagre, la sal y una salsa por separado. Por ejemplo, si eliges una ensalada César, debes buscar también la salsa César si deseas que la tenga. "),
                  TXTextWidget(
                      textAlign: TextAlign.justify,
                      text:
                          "Ponemos a tu disposición más de 700 alimentos, pero si observas que no contiene alguno frecuente en tu dieta, por favor te agradeceríamos que nos lo hicieras saber a través de nuestra dirección de contacto."),
                  SizedBox(
                    height: 10,
                  ),
                  TXTextWidget(
                      textAlign: TextAlign.justify,
                      fontWeight: FontWeight.bold,
                      text:
                          "¡Puedes personalizar tu dieta con una cita con un médico!"),
                  TXTextWidget(
                      textAlign: TextAlign.justify,
                      text:
                          "Si estás interesado en obtener una dieta médica personalizada puedes ponerte en contacto con nosotros."),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TXTextWidget(
              textAlign: TextAlign.center,
              text: R.string.appClinicalWarning,
              size: 10,
              color: R.color.accent_color,
            ),
          ],
        ),
      ),
    );
  }
}
