import 'package:flutter/material.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_checkbox_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_gesture_hide_key_board.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textfield_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/home/home_page.dart';
import 'package:mismedidasb/ui/login/login_bloc.dart';
import 'package:mismedidasb/ui/recover_change_password/recover_password_page.dart';
import 'package:mismedidasb/ui/register/register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends StateWithBloC<LoginPage, LoginBloC> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  final _keyForm = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    bloc.loginResult.listen((onData) {
      if (onData is UserModel)
        NavigationUtils.pushReplacement(context, HomePage());
    });
    bloc.initView();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(children: <Widget>[
      Scaffold(
        body: StreamBuilder<UserCredentialsModel>(
            stream: bloc.userInitResult,
            initialData: UserCredentialsModel(),
            builder: (ctx, snapshot) {
              emailTextController.text = snapshot.data.email;
              passwordTextController.text = snapshot.data.password;
              return Form(
                key: _keyForm,
                child: TXGestureHideKeyBoard(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          TXTextFieldWidget(
                            label: "User Name",
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TXTextFieldWidget(
                            label: "Password",
                          ),
                          StreamBuilder<bool>(
                            stream: bloc.saveCredentialsResult,
                            initialData: snapshot.data.saveCredentials,
                            builder: (saveCtx, snapshotSave) {
                              return TXCheckBoxWidget(
                                text: "Remember",
                                leading: true,
                                textColor: R.color.accent_color,
                                value: snapshotSave.data,
                                onChange: (value) {
                                  bloc.saveCredentials(value);
                                },
                              );
                            },
                          ),
                          SizedBox(height: 30),
                          TXButtonWidget(onPressed: () {
                            bloc.login();
                          }, title: "Entrar"),
                          TXTextLinkWidget(
                            title: "Forgot Password",
                            opTap: () {
                              NavigationUtils.push(
                                  context, RecoverPasswordPage());
                            },
                          ),
                          TXTextLinkWidget(
                            title: "Register",
                            opTap: () {
                              NavigationUtils.push(context, RegisterPage());
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
      TXLoadingWidget(
        loadingStream: bloc.isLoadingStream,
      )
    ],);
  }
}
