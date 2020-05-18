import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_blur_dialog.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_gesture_hide_key_board.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textfield_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/recover_password/recover_password_bloc.dart';

class RecoverPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState
    extends StateWithBloC<RecoverPasswordPage, RecoverPasswordBloC> {
  TextEditingController emailTextController = TextEditingController();
  final _keyFormRecover = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    bloc.recoverResult.listen((res) {
      NavigationUtils.pop(context, result: true);
    });
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
            body: Form(
              key: _keyFormRecover,
              child: TXGestureHideKeyBoard(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 30,
                            ),
                            Image.asset(
                              R.image.logo_blue,
                              width: R.dim.logoInBody,
                              height: R.dim.logoInBody,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TXTextFieldWidget(
                              label: R.string.email,
                              iconData: Icons.email,
                              controller: emailTextController,
                              validator: bloc.email(),
                              textInputType: TextInputType.emailAddress,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TXButtonWidget(
                              title: R.string.recover,
                              onPressed: () {
                                if (_keyFormRecover.currentState.validate()) {
                                  _showDemoDialog(context: context, child: _getDialog(context));
//                                  _showWarningDialog(context);
                                }
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.arrow_back,
                                  size: 10,
                                  color: R.color.accent_color,
                                ),
                                TXTextLinkWidget(
                                  title: R.string.login,
                                  textColor: R.color.accent_color,
                                  onTap: () {
                                    NavigationUtils.pop(context);
                                  },
                                )
                              ],
                            )
                          ]),
                    ),
                  )),
            )),
        TXLoadingWidget(
          loadingStream: bloc.isLoadingStream,
        )
      ],
    );
  }

  void _showDemoDialog({BuildContext context, Widget child}) {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => child,
    );
  }

  Widget _getDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text(
          'Recuperar contraseña'),
      content: const Text(
          'Recibira un correo con la nueva contraseña.'),
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text("Cancelar"),
          onPressed: () => Navigator.pop(context, 'Cancelar'),
        ),
        CupertinoDialogAction(
          child: const Text('Continuar'),
          onPressed: (){
            Navigator.pop(context, 'Continuar');
            bloc.recoverPassword(emailTextController.text);
          },
        ),
      ],
    );
  }
}
