import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_gesture_hide_key_board.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textfield_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/recover_change_password/recover_password_bloc.dart';

class RecoverPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState
    extends StateWithBloC<RecoverPasswordPage, RecoverPasswordBloC> {
  TextEditingController emailTextController = TextEditingController();
  final _keyFormRecover = new GlobalKey<FormState>();

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
            body: Form(
              key: _keyFormRecover,
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
                              label: R.string.email,
                              iconData: Icons.email,
                              validator: bloc.email(),
                              textInputType: TextInputType.emailAddress,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TXButtonWidget(
                              title: R.string.recover,
                              onPressed: () {
                                if (_keyFormRecover.currentState.validate()) {}
                              },
                            ),
                            TXTextLinkWidget(
                              title: R.string.login,
                              onTap: () {
                                NavigationUtils.pop(context);
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
