import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:mismedidasb/utils/file_manager.dart';

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
                          width: double.infinity,
                          child: Stack(
                            children: <Widget>[
                              TXNetworkImage(
                                width: double.infinity,
                                height: double.infinity,
                                imageUrl: user.avatar,
                                placeholderImage: R.image.user,
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 15),
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(45))),
                                  height: 60,
                                  width: 60,
                                  child: Card(
                                    color: R.color.primary_color,
                                    shape: CircleBorder(),
                                    child: InkWell(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(45)),
                                      onTap: () {
                                        _showMediaSelector(context);
                                      },
                                      child: Icon(Icons.edit,
                                          size: 30, color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: R.color.gray,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TXTextWidget(
                          text: user.fullName ?? "asdasd",
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TXTextWidget(
                          text: user.email,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TXTextWidget(
                          text: user.phone,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TXTextWidget(
                          text: user.status,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TXTextWidget(
                          text: user.role,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TXButtonWidget(
                          title: R.string.changePassword,
                          onPressed: () {
                            NavigationUtils.push(context, ChangePasswordPage());
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TXButtonWidget(
                          title: R.string.logout,
                          onPressed: () {
                            _showDemoDialog(context: context);
                          },
                        )
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
                        text: 'Gallery',
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
                        text: 'Camera',
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
    final file = await FileManager.getImageFromSource(imageSource);
    if (file != null && file.existsSync()) {
      bloc.uploadAvatar(file);
    }
  }

  void _showDemoDialog({BuildContext context}) {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => TXCupertinoDialogWidget(
        title: R.string.logout,
        content: R.string.logoutContent,
        onOK: () {
          bloc.logout();
          Navigator.pop(context, 'Allow');
        },
        onCancel: () {
          Navigator.pop(context, 'Allow');
        },
      ),
    );
  }
}
