import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_dialog_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_network_image.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/change_password/change_password_page.dart';
import 'package:mismedidasb/ui/profile/profile_bloc.dart';
import 'package:mismedidasb/ui/profile/tx_profile_item_option_widget.dart';
import 'package:mismedidasb/ui/settings/settings_bloc.dart';
import 'package:mismedidasb/ui/settings/settings_page.dart';
import 'package:mismedidasb/utils/file_manager.dart';
import 'package:mismedidasb/utils/mail_manager.dart';
import 'package:permission_handler/permission_handler.dart';

enum profileAction { logout, changeAvatar, updateProfile, changePassword }

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends StateWithBloC<ProfilePage, ProfileBloC> {
  TextEditingController userNameTextController = TextEditingController();
  final _keyFormProfile = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    bloc.logoutResult.listen((res) {
      NavigationUtils.pop(context, result: profileAction.logout);
    });
    bloc.getProfile();
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
          title: R.string.profile,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 30),
            child: StreamBuilder<UserModel>(
              stream: bloc.userResult,
              initialData: UserModel(),
              builder: (context, snapshot) {
                final user = snapshot.data;
                return Form(
                  key: _keyFormProfile,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 220,
                          color: R.color.gray_light,
                          child: Stack(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: TXNetworkImage(
                                        width: double.infinity,
                                        height: double.infinity,
                                        imageUrl: user.avatar,
                                        placeholderImage: R.image.logo_blue,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: .5,
                                    color: R.color.gray,
                                    margin: EdgeInsets.only(bottom: 25),
                                  )
                                ],
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 20,
                                  child: InkWell(
                                    onTap: () {
                                      _showMediaSelector(context);
                                    },
                                    child: CircleAvatar(
                                      radius: 25,
                                      child: Icon(Icons.edit,
                                          size: 25, color: Colors.white),
                                      backgroundColor: R.color.primary_color,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          color: R.color.gray_light,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: TXNetworkImage(
                                  width: 60,
                                  height: 60,
                                  imageUrl: R.image.logo_blue,
                                  placeholderImage: R.image.logo_blue,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TXTextWidget(
                                    text: user.fullName ?? "---",
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TXTextWidget(
                                    text: user.email ?? "---",
                                    fontWeight: FontWeight.bold,
                                    size: 16,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: .5,
                          color: R.color.gray,
                        ),
                        TXProfileItemOptionWidget(
                          icon: Icons.visibility,
                          optionName: R.string.changePassword,
                          onOptionTap: () {
                            NavigationUtils.push(context, ChangePasswordPage());
                          },
                        ),
                        Container(
                          height: .5,
                          color: R.color.gray,
                        ),
                        TXProfileItemOptionWidget(
                          icon: Icons.settings,
                          optionName: R.string.settings,
                          onOptionTap: () {
                            NavigationUtils.push(context, SettingsPage());
                          },
                        ),
                        Container(
                          height: .5,
                          color: R.color.gray,
                        ),
                        TXProfileItemOptionWidget(
                          icon: Icons.help_outline,
                          optionName: R.string.help,
                          onOptionTap: () async {
//                            await MainManager.sendEmail(
//                                recipient: "borisrod@gmail.com");
                          },
                        ),
                        Container(
                          height: .5,
                          color: R.color.gray,
                        ),
                        TXProfileItemOptionWidget(
                          icon: Icons.exit_to_app,
                          optionName: R.string.logout,
                          onOptionTap: () {
                            _showDemoDialogLogout(context: context);
                          },
                        ),
                        Container(
                          height: .5,
                          color: R.color.gray,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        TXLoadingWidget(
          loadingStream: bloc.isLoadingStream,
        )
      ],
    );
  }

  void _showMediaSelector(BuildContext context) {
    showTXModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            height: 100,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.photo_library,
                        color: R.color.primary_color,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      TXTextWidget(
                        text: R.string.gallery,
                        color: R.color.primary_color,
                      ),
                    ],
                  ),
                  onPressed: () async {
                    await NavigationUtils.pop(context);
                    _launchMediaView(context, ImageSource.gallery);
                  },
                ),
                FlatButton(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.camera,
                        color: R.color.primary_color,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      TXTextWidget(
                        text: R.string.camera,
                        color: R.color.primary_color,
                      ),
                    ],
                  ),
                  onPressed: () async {
                    await NavigationUtils.pop(context);
                    _launchMediaView(context, ImageSource.camera);
                  },
                ),
              ],
            ),
          );
        });
  }

  void _launchMediaView(BuildContext context, ImageSource imageSource) async {
    try {
      final file = await FileManager.getImageFromSource(imageSource);
      if (file != null && file.existsSync()) {
        bloc.uploadAvatar(file);
      }
    } catch (ex) {
      if (ex is PlatformException) {
        if (ex.code == "photo_access_denied") {
          _showDialogPermissions(
              context: context,
              onOkAction: () async {
                openAppSettings();
              });
        }
      }
    }
  }

  void _showDialogPermissions({BuildContext context, Function onOkAction}) {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => TXCupertinoDialogWidget(
        title: R.string.deniedPermissionTitle,
        content: R.string.deniedPermissionContent,
        onOK: () {
          Navigator.pop(context, R.string.ok);
          onOkAction();
        },
        onCancel: () {
          Navigator.pop(context, R.string.cancel);
        },
      ),
    );
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
}
