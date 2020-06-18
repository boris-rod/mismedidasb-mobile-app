import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_gesture_hide_key_board.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textfield_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/invite_page/invite_bloc.dart';

class InvitePeoplePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InvitePeopleState();
}

class _InvitePeopleState
    extends StateWithBloC<InvitePeoplePage, InvitePeopleBloC> {
  TextEditingController emailController = TextEditingController();
  final _keyFormInvite = new GlobalKey<FormState>();
  final _keyInvite = new GlobalKey<ScaffoldState>();

  _navBack() {
    NavigationUtils.pop(context, result: bloc.invited);
  }

  @override
  void initState() {
    super.initState();
    bloc.loadData();
    bloc.inviteResult.listen((event) {
      if (bloc.invited)
        _navBack();
      else
        _keyInvite.currentState
            .showSnackBar(getSnackBarWidget("Algunas invitaciones han fallado"));
    });
  }

  @override
  Widget buildWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navBack();
        return false;
      },
      child: Stack(
        children: <Widget>[
          TXMainAppBarWidget(
            scaffoldKey: _keyInvite,
            title: "Invitar",
            leading: TXIconButtonWidget(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                _navBack();
              },
            ),
            body: Container(
              height: double.infinity,
              width: double.infinity,
              child: StreamBuilder<List<String>>(
                  stream: bloc.emailsResult,
                  initialData: [],
                  builder: (context, snapshot) {
                    return TXGestureHideKeyBoard(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Form(
                          key: _keyFormInvite,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                ..._getEmailsWidget(snapshot.data),
                                SizedBox(
                                  height: 10,
                                ),
                                TXTextFieldWidget(
                                  label: "Email...",
                                  controller: emailController,
                                  validator: bloc.email(),
                                  onSubmitted: (value) {
                                    if (_keyFormInvite.currentState
                                        .validate()) {
                                      bloc.addEmail(emailController.text);
                                      emailController.text = "";
                                    }
                                  },
                                  onChanged: (value) {
                                    bloc.enableAdd(
                                        _keyFormInvite.currentState.validate());
                                  },
                                ),
                                StreamBuilder<bool>(
                                    stream: bloc.addEnableResult,
                                    initialData: false,
                                    builder: (context, snapshotAddEnabled) {
                                      return Container(
                                        alignment: Alignment.centerRight,
                                        child: TXTextLinkWidget(
                                          title: "Adicionar",
                                          textColor: snapshotAddEnabled.data
                                              ? R.color.primary_color
                                              : R.color.gray,
                                          onTap: () {
                                            if (_keyFormInvite.currentState
                                                .validate()) {
                                              bloc.addEmail(
                                                  emailController.text);
                                              emailController.text = "";
                                            }
                                          },
                                        ),
                                        width: double.infinity,
                                      );
                                    }),
                                SizedBox(
                                  height: 30,
                                ),
                                StreamBuilder<bool>(
                                    stream: bloc.inviteEnabledResult,
                                    initialData: false,
                                    builder: (context, snapshotInviteEnabled) {
                                      return TXButtonWidget(
                                        title: "Invitar",
                                        mainColor: snapshotInviteEnabled.data
                                            ? R.color.primary_color
                                            : R.color.gray_darkest,
                                        textColor: snapshotInviteEnabled.data
                                            ? Colors.white
                                            : Colors.black,
                                        onPressed: snapshotInviteEnabled.data
                                            ? () {
                                                if (snapshot.data.isNotEmpty) {
                                                  bloc.invite();
                                                }
                                              }
                                            : null,
                                      );
                                    })
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
          TXLoadingWidget(
            loadingStream: bloc.isLoadingStream,
          )
        ],
      ),
    );
  }

  List<Widget> _getEmailsWidget(List<String> emails) {
    List<Widget> list = [];
    emails.forEach((element) {
      final w = Card(
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
          width: double.infinity,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TXTextWidget(
                  text: element,
                ),
              ),
              TXIconButtonWidget(
                icon: Icon(
                  Icons.close,
                  color: R.color.primary_color,
                ),
                onPressed: () {
                  bloc.removeEmail(element);
                },
              )
            ],
          ),
        ),
      );
      list.add(w);
    });

    return list;
  }

  SnackBar getSnackBarWidget(String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.white,
      content: Row(
        children: <Widget>[
          Container(
            child: Image.asset(
              R.image.logo,
              width: 60,
              height: 60,
            ),
          ),
          Expanded(
              child: TXTextWidget(
            text: message,
          ))
        ],
      ),
    );
    return snackBar;
  }
}
