import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/domain/contact_us/contact_us_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_dialog_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_gesture_hide_key_board.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textfield_widget.dart';
import 'package:mismedidasb/ui/contact_us/contact_us_bloc.dart';

class ContactUsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContactUsState();
}

class _ContactUsState extends StateWithBloC<ContactUsPage, ContactUsBloC> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _keyFormContactUs = new GlobalKey<FormState>();

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        TXMainAppBarWidget(
          title: R.string.contactUs,
          leading: TXIconButtonWidget(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              NavigationUtils.pop(context);
            },
          ),
          body: Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding:
                  EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 30),
              child: Form(
                key: _keyFormContactUs,
                child: TXGestureHideKeyBoard(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Image.asset(
                        R.image.logo,
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TXTextFieldWidget(
                        label: R.string.subject,
                        iconData: Icons.title,
                        controller: titleController,
                        validator: bloc.required(),
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TXTextFieldWidget(
                        label: R.string.description,
                        iconData: Icons.description,
                        maxLine: 10,
                        validator: bloc.required(),
                        controller: descriptionController,
                        textInputType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TXButtonWidget(
                          onPressed: () async{
                            if (_keyFormContactUs.currentState.validate()) {
                              final res = await bloc.sedInfo(titleController.text,
                                  descriptionController.text);
                              _showDemoDialogContactUs(context: context);
                            }
                          },
                          title: R.string.sendInfo),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        TXLoadingWidget(
          loadingStream: bloc.isLoadingStream,
        )
      ],
    );
  }

  void _showDemoDialogContactUs({BuildContext context}) {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => TXCupertinoDialogWidget(
        title: R.string.thanks,
        content: R.string.contactUsResult,
        onOK: (){
          NavigationUtils.pop(context);
          NavigationUtils.pop(context);
        },
      ),
    );
  }
}
