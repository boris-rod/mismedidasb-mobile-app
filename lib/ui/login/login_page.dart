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
  final _keyFormLogin = new GlobalKey<FormState>();

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
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 30),
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
                              textInputType: TextInputType.emailAddress,
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
                                  onChange: (value) {
                                    bloc.saveCredentials(value);
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
                            TXTextLinkWidget(
                              title: R.string.forgotPassword,
                              onTap: () {
                                NavigationUtils.push(
                                    context, RecoverPasswordPage());
                              },
                            ),
                            TXTextLinkWidget(
                              title: R.string.register,
                              onTap: () async {
                                final result = await NavigationUtils.push(
                                    context, RegisterPage());

                                if (result is bool && result) {
                                  bloc.initView();
                                }
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
      ],
    );
  }
}
