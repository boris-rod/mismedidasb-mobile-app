import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_gesture_hide_key_board.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textfield_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/register/register_bloc.dart';
import 'package:mismedidasb/ui/register/register_confirmation_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends StateWithBloC<RegisterPage, RegisterBloC> {
  TextEditingController nameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();
  final _keyFormRegister = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    bloc.registerResult.listen((res) {
      if (res) {
        NavigationUtils.pushReplacement(
            context,
            RegisterConfirmationPage(
              email: emailTextController.text,
              password: passwordTextController.text,
            ));
      }
    });
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: Form(
            key: _keyFormRegister,
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
                      label: R.string.userName,
                      iconData: Icons.person,
                      controller: nameTextController,
                      validator: bloc.required(),
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
                    TXTextFieldWidget(
                      label: R.string.password,
                      validator: bloc.password(),
                      controller: passwordTextController,
                      obscureText: true,
                      onChanged: (value) {
                        bloc.currentPassword = value;
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TXTextFieldWidget(
                      label: R.string.password,
                      validator: (value) {
                        if (value != passwordTextController.text) {
                          return R.string.passwordMatch;
                        } else {
                          return null;
                        }
                      },
                      obscureText: true,
                      controller: confirmPasswordTextController,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TXButtonWidget(
                      title: R.string.register,
                      onPressed: () {
                        if (_keyFormRegister.currentState.validate()) {
                          bloc.register(
                              nameTextController.text,
                              emailTextController.text,
                              passwordTextController.text,
                              confirmPasswordTextController.text);
                        }
                      },
                    ),
                    TXTextLinkWidget(
                      title: R.string.login,
                      onTap: () {
                        NavigationUtils.pop(context);
                      },
                    )
                  ],
                ),
              )),
            ),
          ),
        ),
        TXLoadingWidget(
          loadingStream: bloc.isLoadingStream,
        )
      ],
    );
  }
}
