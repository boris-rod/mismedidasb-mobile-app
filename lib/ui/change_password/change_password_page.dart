import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_blur_dialog.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_gesture_hide_key_board.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textfield_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/change_password/change_password_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChangePasswordState();
}

class _ChangePasswordState
    extends StateWithBloC<ChangePasswordPage, ChangePasswordBloC> {
  TextEditingController oldTextController = TextEditingController();
  TextEditingController newTextController = TextEditingController();
  TextEditingController confirmTextController = TextEditingController();
  final _keyFormChangePassword = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    bloc.initView();
    bloc.changeResult.listen((onData){
      if(onData == true)
        NavigationUtils.pop(context);
    });
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        TXMainAppBarWidget(
          leading: TXIconButtonWidget(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              NavigationUtils.pop(context);
            },
          ),
          title: R.string.changePassword,
          body: TXGestureHideKeyBoard(
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Form(
                  key: _keyFormChangePassword,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Image.asset(
                        R.image.logo,
                        width: 100,
                        height: 100,
                        color: R.color.primary_color,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      StreamBuilder<String>(
                        stream: bloc.initResult,
                        initialData: "",
                        builder: (context, snapshot){
                          oldTextController.text = snapshot.data;
                          return TXTextFieldWidget(
                            label: R.string.oldPassword,
                            obscureText: true,
                            controller: oldTextController,
                            validator: bloc.password(),
                          );
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TXTextFieldWidget(
                        label: R.string.newPassword,
                        controller: newTextController,
                        obscureText: true,
                        validator: bloc.password(),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TXTextFieldWidget(
                        label: R.string.confirmPassword,
                        controller: confirmTextController,
                        obscureText: true,
                        validator: (value) {
                          if (value != newTextController.text) {
                            return R.string.passwordMatch;
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TXButtonWidget(
                        title: R.string.changePassword,
                        onPressed: () {
                          if (_keyFormChangePassword.currentState.validate()) {
                            _showDemoDialog(context: context, child: _getDialog(context));
                          }
                        },
                      ),
                    ],
                  ),
                )),
          ),
        ),
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
          'Cambiar contraseña'),
      content: const Text(
          'Su contraseña sera actualizada.'),
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text("Cancelar"),
          onPressed: () => Navigator.pop(context, 'Cancelar'),
        ),
        CupertinoDialogAction(
          child: const Text('Continuar'),
          onPressed: (){
            Navigator.pop(context, 'Continuar');
            bloc.changePassword(oldTextController.text,
                newTextController.text, confirmTextController.text);
          },
        ),
      ],
    );
  }

  void _showWarningDialog(BuildContext context) {
    showBlurDialog(
        context: context,
        builder: (ctx) {
          return Center(
            child: Container(
              height: 300,
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TXTextWidget(
                    text: R.string.emailWillBeReceived,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TXButtonWidget(
                    title: R.string.ok,
                    onPressed: () {
                      NavigationUtils.pop(context);
                      bloc.changePassword(oldTextController.text,
                          newTextController.text, confirmTextController.text);
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  TXTextLinkWidget(
                    title: R.string.cancel,
                    textColor: R.color.accent_color,
                    onTap: () {
                      NavigationUtils.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
