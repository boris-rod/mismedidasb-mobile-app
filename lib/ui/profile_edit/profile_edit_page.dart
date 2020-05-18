import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_dialog_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_divider_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_network_image.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textfield_widget.dart';
import 'package:mismedidasb/ui/change_password/change_password_page.dart';
import 'package:mismedidasb/ui/profile/tx_profile_item_option_widget.dart';
import 'package:mismedidasb/ui/profile_edit/profile_edit_bloc.dart';
import 'package:mismedidasb/utils/file_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileEditPage extends StatefulWidget {
  final UserModel userModel;

  const ProfileEditPage({Key key, this.userModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileEditState();
}

class _ProfileEditState
    extends StateWithBloC<ProfileEditPage, ProfileEditBloC> {
  TextEditingController userNameTextController = TextEditingController();
  final _keyFormProfile = new GlobalKey<FormState>();

  _navBack() async {
    NavigationUtils.pop(context,
        result: bloc.userEdited ? await bloc.userResult.first : null);
  }

  @override
  void initState() {
    super.initState();
    bloc.initData(widget.userModel);
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        TXMainAppBarWidget(
          leading: TXIconButtonWidget(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              _navBack();
            },
          ),
          title: R.string.editProfile,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 30),
            child: StreamBuilder<UserModel>(
              stream: bloc.userResult,
              initialData: UserModel(),
              builder: (context, snapshot) {
                final user = snapshot.data;
                userNameTextController.text = user.fullName;
                return Form(
                  key: _keyFormProfile,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 200,
                          color: R.color.gray_light,
                          child: Stack(
                            children: <Widget>[
                              TXNetworkImage(
                                width: double.infinity,
                                height: double.infinity,
                                imageUrl: user.avatar,
                                placeholderImage: R.image.logo_blue,
                                boxFitImage: BoxFit.cover,
                              ),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    _showMediaSelector(context);
                                  },
                                  child: Icon(
                                    Icons.photo_camera,
                                    color: R.color.dialog_background,
                                    size: 200,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        TXDividerWidget(),
                        TXProfileItemOptionWidget(
                          icon: Icons.visibility,
                          optionName: R.string.changePassword,
                          onOptionTap: () {
                            NavigationUtils.push(
                                context,
                                ChangePasswordPage(
                                  oldPassword: bloc.currentPassword,
                                ));
                          },
                        ),
                        TXDividerWidget(),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TXTextFieldWidget(
                            label: R.string.userName,
                            iconData: Icons.person,
                            controller: userNameTextController,
                            validator: bloc.required(),
                            textInputAction: TextInputAction.done,
                            onSubmitted: (value) {
                              if (_keyFormProfile.currentState.validate()) {
                                bloc.updateUserName(
                                    userNameTextController.text);
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TXDividerWidget(),
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
      final file = await FileManager.getImageFromSource(context, imageSource);
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
}