import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/domain/question/question_model.dart';
import 'package:mismedidasb/domain/setting/setting_model.dart';
import 'package:mismedidasb/domain/single_selection_model.dart';
import 'package:mismedidasb/enums.dart';
import 'package:mismedidasb/lnm/lnm.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_selector_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_checkbox_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_dialog_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_divider_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textlink_widget.dart';
import 'package:mismedidasb/ui/legacy/legacy_page.dart';
import 'package:mismedidasb/ui/profile/profile_page.dart';
import 'package:mismedidasb/ui/references/references_page.dart';
import 'package:mismedidasb/ui/settings/settings_bloc.dart';
import 'package:mismedidasb/ui/settings/tx_reminder_setting_cell_widget.dart';

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
              initialData: null,
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
                                } else if (key == PopupActionKey.references) {
                                  NavigationUtils.push(
                                      context, ReferencesPage());
                                } else if (key == PopupActionKey.logout) {
                                  _showDemoDialogLogout(context: context);
                                } else if (key ==
                                    PopupActionKey.remove_account) {
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
                              ListTile(
                                title: TXTextWidget(
                                  text: "Unidad de medidad de altura",
                                ),
                                trailing: TXTextWidget(
                                    text: snapshot.data.heightUnit ==
                                            heightUnit.centimeter
                                                .toString()
                                                .split('.')
                                                .last
                                        ? R.string.centimeter
                                        : R.string.feet,
                                color: R.color.gray_darkest),
                                contentPadding:
                                    EdgeInsets.only(right: 5, left: 10),
                                onTap: () {
                                  showTXModalBottomSheet(context: context, builder: (context) {
                                    return TXCupertinoPickerWidget(
                                      height: 200,
                                      title: "Medidas de altura",
                                      list: [
                                        ..._getHeightSelector(snapshot.data.heightUnit)
                                      ],
                                      onItemSelected: (item) {
                                        bloc.setHeight(item.key);
                                      },
                                      initialId: 0,
                                    );
                                  });
                                },
                              ),
                              TXDividerWidget(),
                              ListTile(
                                title: TXTextWidget(
                                  text: "Unidad de medidad de peso",
                                ),
                                trailing: TXTextWidget(
                                    text: snapshot.data.weightUnit ==
                                        weightUnit.kilogram
                                            .toString()
                                            .split('.')
                                            .last
                                        ? R.string.kilogram
                                        : R.string.pounds,
                                  color: R.color.gray_darkest),
                                contentPadding:
                                EdgeInsets.only(right: 5, left: 10),
                                onTap: () {
                                  showTXModalBottomSheet(context: context, builder: (context) {
                                    print(snapshot.data.heightUnit);
                                    return TXCupertinoPickerWidget(
                                      height: 200,
                                      title: "Medidas de peso",
                                      list: [
                                        ..._getWeightSelector(snapshot.data.weightUnit)
                                      ],
                                      onItemSelected: (item) {
                                        bloc.setWeight(item.key);
                                      },
                                      initialId: 0,
                                    );
                                  });
                                },
                              ),
                              TXDividerWidget(),
                              ListTile(
                                title: TXTextWidget(
                                  text: R.string.showResumePlanBeforeSave,
                                ),
                                trailing: Checkbox(
                                  onChanged: (value) {
                                    bloc.setShowResumeBeforeSave(value);
                                  },
                                  value: snapshot.data.showResumeBeforeSave,
                                ),
                                contentPadding:
                                    EdgeInsets.only(right: 0, left: 10),
                              ),
//                              Container(
//                                child: TXCheckBoxWidget(
//                                  padding: EdgeInsets.only(left: 10),
//                                  text: R.string.showResumePlanBeforeSave,
//                                  leading: false,
//                                  value: snapshot.data.showResumeBeforeSave,
//                                  onChange: (value) {
//                                    bloc.setShowResumeBeforeSave(value);
//                                  },
//                                  textColor: Colors.black,
//                                ),
//                              ),
                              TXDividerWidget(),
                              TXReminderSettingCellWidget(
                                title: "Mostrar recordatorio para el Desayuno",
                                time: snapshot.data.breakfastTime,
                                onActiveTap: () async {
                                  await bloc.activeReminder(
                                      SharedKey.showBreakFastTime,
                                      !snapshot.data.showBreakFastNoti);
                                },
                                minimumDate: snapshot.data.breakfastTime
                                    .subtract(Duration(hours: 1)),
                                maximumDate: snapshot.data.breakfastTime
                                    .add(Duration(hours: 1)),
                                isActive: snapshot.data.showBreakFastNoti,
                                onDateSelected: (newDateTime) {
                                  if (newDateTime.hour !=
                                          snapshot.data.breakfastTime.hour ||
                                      newDateTime.minute !=
                                          snapshot.data.breakfastTime.minute) {
                                    bloc.scheduleReminder(
                                        SharedKey.breakFastTime, newDateTime);
                                  }
                                },
                              ),
                              TXDividerWidget(),
                              TXReminderSettingCellWidget(
                                title: "Mostrar recordatorio para el Tentempié",
                                time: snapshot.data.snack1Time,
                                onActiveTap: () async {
                                  await bloc.activeReminder(
                                      SharedKey.showSnack1Time,
                                      !snapshot.data.showSnack1Noti);
                                },
                                isActive: snapshot.data.showSnack1Noti,
                                minimumDate: snapshot.data.snack1Time
                                    .subtract(Duration(hours: 1)),
                                maximumDate: snapshot.data.snack1Time
                                    .add(Duration(hours: 1)),
                                onDateSelected: (newDateTime) {
                                  if (newDateTime.hour !=
                                          snapshot.data.snack1Time.hour ||
                                      newDateTime.minute !=
                                          snapshot.data.snack1Time.minute) {
                                    bloc.scheduleReminder(
                                        SharedKey.snack1Time, newDateTime);
                                  }
                                },
                              ),
                              TXDividerWidget(),
                              TXReminderSettingCellWidget(
                                title: "Mostrar recordatorio para la Comida",
                                time: snapshot.data.lunchTime,
                                onActiveTap: () async {
                                  await bloc.activeReminder(
                                      SharedKey.showLunchTime,
                                      !snapshot.data.showLunchNoti);
                                },
                                isActive: snapshot.data.showLunchNoti,
                                minimumDate: snapshot.data.lunchTime
                                    .subtract(Duration(hours: 1)),
                                maximumDate: snapshot.data.lunchTime
                                    .add(Duration(hours: 1)),
                                onDateSelected: (newDateTime) {
                                  if (newDateTime.hour !=
                                          snapshot.data.lunchTime.hour ||
                                      newDateTime.minute !=
                                          snapshot.data.lunchTime.minute) {
                                    bloc.scheduleReminder(
                                        SharedKey.lunchTime, newDateTime);
                                  }
                                },
                              ),
                              TXDividerWidget(),
                              TXReminderSettingCellWidget(
                                title: "Mostrar recordatorio para la Merienda",
                                time: snapshot.data.snack2Time,
                                onActiveTap: () async {
                                  await bloc.activeReminder(
                                      SharedKey.showSnack2Time,
                                      !snapshot.data.showSnack2Noti);
                                },
                                isActive: snapshot.data.showSnack2Noti,
                                minimumDate: snapshot.data.snack2Time
                                    .subtract(Duration(hours: 1)),
                                maximumDate: snapshot.data.snack2Time
                                    .add(Duration(hours: 1)),
                                onDateSelected: (newDateTime) {
                                  if (newDateTime.hour !=
                                          snapshot.data.snack2Time.hour ||
                                      newDateTime.minute !=
                                          snapshot.data.snack2Time.minute) {
                                    bloc.scheduleReminder(
                                        SharedKey.snack2Time, newDateTime);
                                  }
                                },
                              ),
                              TXDividerWidget(),
                              TXReminderSettingCellWidget(
                                title: "Mostrar recordatorio para la Cena",
                                time: snapshot.data.dinnerTime,
                                onActiveTap: () async {
                                  await bloc.activeReminder(
                                      SharedKey.showDinnerTime,
                                      !snapshot.data.showDinnerNoti);
                                },
                                isActive: snapshot.data.showDinnerNoti,
                                minimumDate: snapshot.data.dinnerTime
                                    .subtract(Duration(hours: 1)),
                                maximumDate: snapshot.data.dinnerTime
                                    .add(Duration(minutes: 30)),
                                onDateSelected: (newDateTime) {
                                  if (newDateTime.hour !=
                                          snapshot.data.dinnerTime.hour ||
                                      newDateTime.minute !=
                                          snapshot.data.dinnerTime.minute) {
                                    bloc.scheduleReminder(
                                        SharedKey.dinnerTime, newDateTime);
                                  }
                                },
                              ),
                              TXDividerWidget(),
                              TXReminderSettingCellWidget(
                                title: "Mostrar recordatorio para beber agua",
                                time: snapshot.data.drinkWaterTime,
                                onActiveTap: () async {
                                  await bloc.activeReminder(
                                      SharedKey.showDrinkWater,
                                      !snapshot.data.showDrinkWaterNoti);
                                },
                                isActive: snapshot.data.showDrinkWaterNoti,
                                minimumDate: snapshot.data.drinkWaterTime
                                    .subtract(Duration(hours: 1)),
                                maximumDate: snapshot.data.drinkWaterTime
                                    .add(Duration(minutes: 30)),
                                onDateSelected: (newDateTime) {
                                  if (newDateTime.hour !=
                                          snapshot.data.drinkWaterTime.hour ||
                                      newDateTime.minute !=
                                          snapshot.data.drinkWaterTime.minute) {
                                    bloc.scheduleReminder(
                                        SharedKey.drinkWater1Time, newDateTime);
                                  }
                                },
                              ),
                              TXDividerWidget(),
                              TXReminderSettingCellWidget(
                                title:
                                    "Mostrar recordatorio para planificar comidas de mañana",
                                time: snapshot.data.planFoodsTime,
                                onActiveTap: () async {
                                  await bloc.activeReminder(
                                      SharedKey.showPlanFoods,
                                      !snapshot.data.showPlanFoodsNoti);
                                },
                                minimumDate: snapshot.data.planFoodsTime
                                    .subtract(Duration(hours: 1)),
                                maximumDate: snapshot.data.planFoodsTime
                                    .add(Duration(hours: 1)),
                                isActive: snapshot.data.showPlanFoodsNoti,
                                onDateSelected: (newDateTime) {
                                  if (newDateTime.hour !=
                                          snapshot.data.planFoodsTime.hour ||
                                      newDateTime.minute !=
                                          snapshot.data.planFoodsTime.minute) {
                                    bloc.scheduleReminder(
                                        SharedKey.planFoodsTime, newDateTime);
                                  }
                                },
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
    final references = PopupMenuItem(
      value: PopupActionKey.references,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.link,
              size: 20,
              color: R.color.primary_color,
            ),
            SizedBox(
              width: 10,
            ),
            TXTextWidget(
              text: R.string.references,
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
    list.add(references);
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

  List<SingleSelectionModel> _getWeightSelector(String selected) {
    final kgKey = weightUnit.kilogram.toString().split('.').last;
    final poundKey = weightUnit.pound.toString().split('.').last;
    return selected == kgKey ? [
      SingleSelectionModel(
        id: 0,
        displayName: R.string.kilogram,
        index: 0,
        key: kgKey,
      ),
      SingleSelectionModel(
        index: 1,
        displayName: R.string.pounds,
        id: 1,
        key: poundKey,
      ),
    ] : [
      SingleSelectionModel(
        index: 0,
        displayName: R.string.pounds,
        id: 0,
        key: poundKey,
      ),
      SingleSelectionModel(
        id: 1,
        displayName: R.string.kilogram,
        index: 1,
        key: kgKey,
      ),
    ];
  }

  List<SingleSelectionModel> _getHeightSelector(String selected) {
    final feetKey = heightUnit.feet.toString().split('.').last;
    final cmKey = heightUnit.centimeter.toString().split('.').last;
    return selected == cmKey ? [
      SingleSelectionModel(
        id: 0,
        displayName: R.string.centimeter,
        index: 0,
        key: cmKey,
      ),
      SingleSelectionModel(
        index: 1,
        displayName: R.string.feet,
        id: 1,
        key: feetKey,
      ),
    ] : [
      SingleSelectionModel(
        index: 0,
        displayName: R.string.feet,
        id: 0,
        key: feetKey,
      ),
      SingleSelectionModel(
        id: 1,
        displayName: R.string.centimeter,
        index: 1,
        key: cmKey,
      ),
    ];
  }
}
