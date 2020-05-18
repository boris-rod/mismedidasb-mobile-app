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
  final String email;
  final String password;

  const RegisterPage({Key key, this.email, this.password}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends StateWithBloC<RegisterPage, RegisterBloC> {
//  TextEditingController nameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();
  final _keyFormRegister = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailTextController.text = widget.email ?? '';
    passwordTextController.text = widget.password ?? '';

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
                  physics: BouncingScrollPhysics(),
                  child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
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
//                    SizedBox(
//                      height: 30,
//                    ),
//                    TXTextFieldWidget(
//                      label: R.string.userName,
//                      iconData: Icons.person,
//                      controller: nameTextController,
//                      validator: bloc.required(),
//                    ),
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
                      label: R.string.confirmPassword,
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
                              emailTextController.text,
                              passwordTextController.text,
                              confirmPasswordTextController.text);
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.arrow_back, size: 10, color: R.color.accent_color,),
                        TXTextLinkWidget(
                          title: R.string.previous,
                          textColor: R.color.accent_color,
                          onTap: () {
                            NavigationUtils.pop(context);
                          },
                        )
                      ],
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
