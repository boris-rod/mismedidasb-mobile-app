import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_gesture_hide_key_board.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textfield_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/register/register_bloc.dart';

class RegisterConfirmationPage extends StatefulWidget {
  final String email;
  final String password;
  final bool generateCode;

  const RegisterConfirmationPage(
      {Key key, this.email, this.password, this.generateCode = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterConfirmationState();
}

class _RegisterConfirmationState
    extends StateWithBloC<RegisterConfirmationPage, RegisterBloC> {
  TextEditingController codeTextController = TextEditingController();
  final _keyFormActivate = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if(widget.generateCode)
      bloc.resendCode(widget.email);

    bloc.confirmedResult.listen((onData) {
      if (onData != null && onData) {
        NavigationUtils.pop(context, result: true);
      }
    });
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
            body: Form(
              key: _keyFormActivate,
              child: TXGestureHideKeyBoard(
                  child: SingleChildScrollView(
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
                              R.image.logo,
                              width: 100,
                              height: 100,
                              color: R.color.primary_color,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TXTextFieldWidget(
                              label: R.string.code,
                              controller: codeTextController,
                              iconData: Icons.confirmation_number,
                              validator: bloc.required(),
                              textInputType: TextInputType.number,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TXButtonWidget(
                              title: R.string.activateAccount,
                              onPressed: () {
                                if (_keyFormActivate.currentState.validate()) {
                                  bloc.activateAccount(
                                      widget.email, widget.password,
                                      codeTextController.text);
                                }
                              },
                            ),
                            TXTextLinkWidget(
                              title: R.string.reSendCode,
                              textColor: R.color.accent_color,
                              onTap: () {
                                bloc.resendCode(widget.email);
                              },
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
}
