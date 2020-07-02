import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_blur_dialog.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_dialog_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_gesture_hide_key_board.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textfield_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/change_password/change_password_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  final String oldPassword;

  const ChangePasswordPage({Key key, this.oldPassword = ""}) : super(key: key);
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
    oldTextController.text = widget.oldPassword;
    bloc.changeResult.listen((onData){
      if(onData == true){
        Fluttertoast.showToast(msg: R.string.changePasswordSuccess);
        NavigationUtils.pop(context);
      }
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
              physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 30),
                child: Form(
                  key: _keyFormChangePassword,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Image.asset(
                        R.image.logo,
                        width: R.dim.logoInBody,
                        height: R.dim.logoInBody,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TXTextFieldWidget(
                        label: R.string.oldPassword,
                        obscureText: true,
                        controller: oldTextController,
                        validator: bloc.password(),
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
                            _showDialogChangePassword(context: context);
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

  void _showDialogChangePassword({BuildContext context}) {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => TXCupertinoDialogWidget(
        title: R.string.changePassword,
        content: R.string.changePasswordContent,
        onOK: () {
          bloc.changePassword(oldTextController.text,
              newTextController.text, confirmTextController.text);
          Navigator.pop(context, R.string.logout);
        },
        onCancel: () {
          Navigator.pop(context, R.string.cancel);
        },
      ),
    );
  }
}
