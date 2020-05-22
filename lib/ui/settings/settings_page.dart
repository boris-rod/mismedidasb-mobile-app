import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mismedidasb/domain/setting/setting_model.dart';
import 'package:mismedidasb/enums.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_selector_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_checkbox_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_dialog_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_divider_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/legacy/legacy_page.dart';
import 'package:mismedidasb/ui/profile/profile_page.dart';
import 'package:mismedidasb/ui/profile/tx_profile_item_option_widget.dart';
import 'package:mismedidasb/ui/settings/settings_bloc.dart';

enum SettingAction { logout, languageCodeChanged, removeAccount }

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends StateWithBloC<SettingsPage, SettingsBloC> {
  _navBack() {
    NavigationUtils.pop(context, result: bloc.settingAction);
  }

  @override
  void initState() {
    super.initState();
    bloc.logoutResult.listen((res) {
      NavigationUtils.pop(context, result: bloc.settingAction);
    });

    bloc.removeAccountResult.listen((res) {
      NavigationUtils.pop(context, result: bloc.settingAction);
    });

    bloc.initData();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          StreamBuilder<SettingModel>(
              stream: bloc.settingsResult,
              initialData: SettingModel(
                  showResumeBeforeSave: false,
                  languageCodeId: 1,
                  languageCode: "",
                  isDarkMode: false),
              builder: (ctx, snapshot) {
                return snapshot.data == null
                    ? Container()
                    : TXMainAppBarWidget(
                        leading: TXIconButtonWidget(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            _navBack();
                          },
                        ),
                        title: R.string.settings,
                        actions: <Widget>[
                          PopupMenuButton(
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              ),
                              itemBuilder: (ctx) {
                                return [..._popupActions()];
                              },
                              onSelected: (key) async {
                                if (key == PopupActionKey.terms_cond) {
                                  NavigationUtils.push(
                                      context,
                                      LegacyPage(
                                        contentType: 1,
                                      ));
                                } else if (key ==
                                    PopupActionKey.privacy_policies) {
                                  NavigationUtils.push(
                                      context,
                                      LegacyPage(
                                        contentType: 0,
                                      ));
                                }else if(key == PopupActionKey.logout){
                                  _showDemoDialogLogout(context: context);
                                }else if(key == PopupActionKey.remove_account){
                                  showTXModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return _showWarning(
                                          context,
                                        );
                                      });
                                }
                              })
                        ],
                        body: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 30),
                          child: Column(
                            children: <Widget>[
//                                    Container(
//                                      padding: EdgeInsets.symmetric(
//                                          horizontal: 10, vertical: 10),
//                                      child: Column(
//                                        children: <Widget>[
//                                          TXTextWidget(
//                                            text: R.string.preferredLanguage,
//                                            color: Colors.black,
//                                          ),
//                                          Row(
//                                            children: <Widget>[
//                                              TXButtonSelectorWidget(
//                                                onPressed: () {
//                                                  if (snapshot
//                                                          .data.languageCode !=
//                                                      'es')
//                                                    bloc.setLanguageCode("es");
//                                                },
//                                                text: R.string.spanish,
//                                                isSelected: snapshot
//                                                        .data.languageCode ==
//                                                    "es",
//                                              ),
//                                              TXButtonSelectorWidget(
//                                                onPressed: () {
//                                                  if (snapshot
//                                                          .data.languageCode !=
//                                                      'en')
//                                                    bloc.setLanguageCode("en");
//                                                },
//                                                text: R.string.english,
//                                                isSelected: snapshot
//                                                        .data.languageCode ==
//                                                    "en",
//                                              ),
//                                              TXButtonSelectorWidget(
//                                                onPressed: () {
//                                                  if (snapshot
//                                                          .data.languageCode !=
//                                                      'it')
//                                                    bloc.setLanguageCode("it");
//                                                },
//                                                text: R.string.italian,
//                                                isSelected: snapshot
//                                                        .data.languageCode ==
//                                                    "it",
//                                              ),
//                                            ],
//                                            mainAxisAlignment:
//                                                MainAxisAlignment.spaceBetween,
//                                          ),
//                                        ],
//                                        crossAxisAlignment:
//                                            CrossAxisAlignment.start,
//                                      ),
//                                    ),
//                                    TXDividerWidget(),
                              Container(
                                child: TXCheckBoxWidget(
                                  padding: EdgeInsets.only(left: 10),
                                  text: R.string.showResumePlanBeforeSave,
                                  leading: false,
                                  value:
                                  snapshot.data.showResumeBeforeSave,
                                  onChange: (value) {
                                    bloc.setShowResumeBeforeSave(value);
                                  },
                                  textColor: Colors.black,
                                ),
                              ),
                              TXDividerWidget(),
                            ],
                          ),
                        ),
                      );
              }),
          TXLoadingWidget(
            loadingStream: bloc.isLoadingStream,
          )
        ],
      ),
      onWillPop: () async {
        _navBack();
        return false;
      },
    );
  }

  List<PopupMenuItem> _popupActions() {
    List<PopupMenuItem> list = [];

    final temrsCond = PopupMenuItem(
      value: PopupActionKey.terms_cond,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.announcement,
              size: 20,
              color: R.color.primary_color,
            ),
            SizedBox(
              width: 10,
            ),
            TXTextWidget(
              text: R.string.termsCond,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
    final privPoliciy = PopupMenuItem(
      value: PopupActionKey.privacy_policies,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.description,
              size: 20,
              color: R.color.primary_color,
            ),
            SizedBox(
              width: 10,
            ),
            TXTextWidget(
              text: R.string.privacyPolicies,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
    final logout = PopupMenuItem(
      value: PopupActionKey.logout,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.exit_to_app,
              size: 20,
              color: R.color.primary_color,
            ),
            SizedBox(
              width: 10,
            ),
            TXTextWidget(
              text: R.string.logout,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
    final removeAccount = PopupMenuItem(
      value: PopupActionKey.remove_account,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.remove_circle_outline,
              size: 20,
              color: Colors.redAccent,
            ),
            SizedBox(
              width: 10,
            ),
            TXTextWidget(
              text: R.string.removeAccount,
              color: Colors.redAccent,
            )
          ],
        ),
      ),
    );
    list.add(temrsCond);
    list.add(privPoliciy);
    list.add(logout);
    list.add(removeAccount);
    return list;
  }

  void _showDemoDialogLogout({BuildContext context}) {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => TXCupertinoDialogWidget(
        title: R.string.logout,
        content: R.string.logoutContent,
        onOK: () {
          bloc.logout();
          Navigator.pop(context, R.string.logout);
        },
        onCancel: () {
          Navigator.pop(context, R.string.cancel);
        },
      ),
    );
  }

  Widget _showWarning(BuildContext context) {
    return Container(
      height: 300,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.topLeft,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TXTextWidget(
                    text: R.string.removeAccount,
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                    size: 18,
                  ),
                ),
                Container(
                  child: TXTextLinkWidget(
                      title: R.string.cancel,
                      textColor: R.color.primary_color,
                      onTap: () {
                        NavigationUtils.pop(context);
                      }),
                )
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 20, bottom: 10),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          TXTextWidget(
                            text: R.string.removeAccountWarning,
                          ),
                          StreamBuilder<bool>(
                            stream: bloc.forceRemoveResult,
                            initialData: false,
                            builder: (ctx, snapshot) {
                              return TXCheckBoxWidget(
                                text: R.string.forceRemove,
                                leading: true,
                                textColor: R.color.accent_color,
                                value: snapshot.data,
                                onChange: (value) {
                                  bloc.forceRemoveAccount = value;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    TXButtonWidget(
                        mainColor: Colors.red,
                        onPressed: () {
                          NavigationUtils.pop(context);
                          bloc.removeAccount();
                        },
                        title: R.string.removeAccount),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
