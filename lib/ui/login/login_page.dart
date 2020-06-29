import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/domain/session/session_model.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_background_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_checkbox_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_gesture_hide_key_board.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textfield_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/home/home_page.dart';
import 'package:mismedidasb/ui/legacy/legacy_page.dart';
import 'package:mismedidasb/ui/login/login_bloc.dart';
import 'package:mismedidasb/ui/recover_password/recover_password_page.dart';
import 'package:mismedidasb/ui/register/register_confirmation_page.dart';
import 'package:mismedidasb/ui/register/register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends StateWithBloC<LoginPage, LoginBloC> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  final _keyFormLogin = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    bloc.loginResult.listen((onData) async {
      if (onData is LOGIN_RESULT) {
        if (onData == LOGIN_RESULT.HOME) {
          NavigationUtils.pushReplacement(context, HomePage());
        } else if (onData == LOGIN_RESULT.REGISTER) {
          registrationProcess();
        } else if (onData == LOGIN_RESULT.CONFIRMATION_CODE) {
          final res = await NavigationUtils.push(
              context,
              RegisterConfirmationPage(
                email: emailTextController.text,
                password: passwordTextController.text,
                generateCode: true,
              ));

          if (res == LOGIN_RESULT.HOME) {
            NavigationUtils.pushReplacement(context, HomePage());
          }
        } else if (onData == LOGIN_RESULT.TERMS_COND) {
          final res = await NavigationUtils.push(
              context,
              LegacyPage(
                contentType: 1,
                termsCondAccepted: false,
              ));
          if (res is bool && res) {
            NavigationUtils.pushReplacement(context, HomePage());
          }
        } else {
          bloc.initView();
        }
      }
    });
    bloc.initView();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: StreamBuilder<UserCredentialsModel>(
              stream: bloc.userInitResult,
              initialData: UserCredentialsModel(),
              builder: (ctx, snapshot) {
                emailTextController.text = snapshot.data.email;
                passwordTextController.text = snapshot.data.password;
                return Form(
                  key: _keyFormLogin,
                  child: TXGestureHideKeyBoard(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 30),
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
                              textInputAction: TextInputAction.done,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TXTextFieldWidget(
                              label: R.string.password,
                              validator: bloc.password(),
                              obscureText: true,
                              controller: passwordTextController,
                              textInputAction: TextInputAction.done,
                            ),
                            StreamBuilder<bool>(
                              stream: bloc.saveCredentialsResult,
                              initialData: snapshot.data.saveCredentials,
                              builder: (saveCtx, snapshotSave) {
                                return TXCheckBoxWidget(
                                  text: R.string.remember,
                                  leading: true,
                                  textColor: R.color.accent_color,
                                  value: snapshotSave.data,
                                  onChange: (value) async {
                                    await bloc.saveCredentials(value);
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 30),
                            TXButtonWidget(
                                onPressed: () {
                                  if (_keyFormLogin.currentState.validate()) {
                                    bloc.login(emailTextController.text,
                                        passwordTextController.text);
                                  }
                                },
                                title: R.string.login),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                TXTextLinkWidget(
                                  textColor: R.color.accent_color,
                                  title: R.string.forgotPassword,
                                  onTap: () async {
                                    final res = await NavigationUtils.push(
                                        context,
                                        RecoverPasswordPage(
                                          email: emailTextController.text,
                                        ));
                                    if (res is bool && res)
                                      Fluttertoast.showToast(
                                          msg: R.string.checkEmail,
                                          toastLength: Toast.LENGTH_SHORT);
                                  },
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 10,
                                  color: R.color.accent_color,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                TXTextLinkWidget(
                                  title: R.string.register,
                                  textColor: R.color.accent_color,
                                  onTap: () {
                                    registrationProcess();
                                  },
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 10,
                                  color: R.color.accent_color,
                                )
                              ],
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
      ],
    );
  }

  void registrationProcess() async {
    final registerRes = await NavigationUtils.push(
        context,
        RegisterPage(
          email: emailTextController.text,
          password: passwordTextController.text,
        ));

    final email = await bloc.userEmail();
    final password = await bloc.userPassword();
    await bloc.saveCredentials(true);

    final confirmRes = await NavigationUtils.push(
        context,
        RegisterConfirmationPage(
          email: email,
          password: password,
        ));

    await bloc.initView();

    if (confirmRes is LOGIN_RESULT && confirmRes == LOGIN_RESULT.HOME) {
      bloc.login(email, password);
    }
  }
}
