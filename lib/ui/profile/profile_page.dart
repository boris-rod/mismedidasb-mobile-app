import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/enums.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_dialog_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_divider_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_network_image.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/change_password/change_password_page.dart';
import 'package:mismedidasb/ui/contact_us/contact_us_page.dart';
import 'package:mismedidasb/ui/invite_page/invite_page.dart';
import 'package:mismedidasb/ui/legacy/legacy_page.dart';
import 'package:mismedidasb/ui/profile/profile_bloc.dart';
import 'package:mismedidasb/ui/profile/tx_cell_selection_option_widget.dart';
import 'package:mismedidasb/ui/profile/tx_stat_widget.dart';
import 'package:mismedidasb/ui/profile_edit/profile_edit_page.dart';
import 'package:mismedidasb/ui/scores_page/score_page.dart';
import 'package:mismedidasb/ui/settings/settings_bloc.dart';
import 'package:mismedidasb/ui/settings/settings_page.dart';
import 'package:mismedidasb/utils/file_manager.dart';
import 'package:mismedidasb/utils/mail_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends StateWithBloC<ProfilePage, ProfileBloC> {
  final _keyInviteProfile = new GlobalKey<ScaffoldState>();

  _navBack() {
    NavigationUtils.pop(context, result: bloc.settingAction);
  }

  @override
  void initState() {
    super.initState();
    bloc.getProfile();
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
            scaffoldKey: _keyInviteProfile,
            leading: TXIconButtonWidget(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                _navBack();
              },
            ),
            title: R.string.profile,
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
                  if (key == PopupActionKey.faq) {
                    NavigationUtils.push(
                        context,
                        LegacyPage(
                          contentType: 3,
                        ));
                  } else if (key == PopupActionKey.about_us) {
                    NavigationUtils.push(
                        context,
                        LegacyPage(
                          contentType: 2,
                        ));
                  } else if (key == PopupActionKey.contact_us) {
                    NavigationUtils.push(context, ContactUsPage());
                  } else if (key == PopupActionKey.profile_settings) {
                    final result =
                        await NavigationUtils.push(context, SettingsPage());
                    if (result is SettingAction) {
                      bloc.settingAction = result;
                      if (result == SettingAction.logout ||
                          result == SettingAction.removeAccount) {
                        _navBack();
                      }
                    }
                  }
                },
              )
            ],
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 30),
              child: StreamBuilder<UserModel>(
                stream: bloc.userResult,
                initialData: UserModel(),
                builder: (context, snapshot) {
                  final user = snapshot.data;
                  return Container(
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
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          child: Stack(
                                            children: <Widget>[
                                              TXNetworkImage(
                                                width: double.infinity,
                                                height: double.infinity,
                                                imageUrl: user.avatar,
                                                placeholderImage:
                                                    R.image.logo_blue,
                                                boxFitImage: BoxFit.cover,
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                color:
                                                    R.color.dialog_background,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: TXNetworkImage(
                                            width: double.infinity,
                                            height: double.infinity,
                                            imageUrl: user.avatar,
                                            placeholderImage: R.image.logo_blue,
                                          ),
                                        )
                                      ],
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
                                    onTap: () async {
                                      final res = await NavigationUtils.push(
                                          context,
                                          ProfileEditPage(
                                            userModel:
                                                await bloc.userResult.first,
                                          ));
                                      if (res != null) {
                                        bloc.updateUser = res;
                                      }
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
                                    text: "@${user.username}" ?? "---",
                                    fontWeight: FontWeight.bold,
                                    size: 16,
                                  ),
                                  TXTextWidget(
                                    text: user.fullName ?? "---",
                                    color: R.color.gray,
                                    maxLines: 1,
                                    textOverflow: TextOverflow.ellipsis,
                                    size: 12,
                                  ),
                                  SizedBox(height: 5,),
                                  TXTextWidget(
                                    text: user.email ?? "---",
                                    size: 12,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        TXDividerWidget(),
                        TXCellSelectionOptionWidget(
                          leading: Icons.group_add,
                          optionName: "Invita y gana una recompensa!",
                          onOptionTap: () async {
                            final res = await NavigationUtils.push(
                                context, InvitePeoplePage());
                            if (res) {
                              _keyInviteProfile.currentState.showSnackBar(
                                  getSnackBarWidget(
                                      "Felicidades, será recompensado!"));
                            }
                          },
                        ),
                        TXDividerWidget(),
                        TXCellSelectionOptionWidget(
                          leading: Icons.contacts,
                          optionName: "Hazle saber a tus contactos!",
                          onOptionTap: () {},
                        ),
                        TXDividerWidget(),
                        TXCellSelectionOptionWidget(
                          leading: Icons.school,
                          optionName: "Ver puntuaciones",
                          onOptionTap: () {
                            NavigationUtils.push(context, ScorePage());
                          },
                        ),
//                        TXDividerWidget(),
//                        InkWell(
//                          child: Container(
//                            padding: EdgeInsets.symmetric(horizontal: 10),
//                            height: 50,
//                            child: Row(
//                              children: <Widget>[
//                                Image.asset(R.image.plani),
//                                Expanded(child: TXTextWidget(text: "Escoge tu Plani",)),
//                                Icon(
//                                  Icons.keyboard_arrow_right,
//                                  color: R.color.primary_dark_color,
//                                  size: 25,
//                                )
//                              ],
//                            ),
//                          ),
//                        ),
                        TXDividerWidget(),

//                          Container(
//                            padding: EdgeInsets.symmetric(horizontal: 10),
//                            child: Card(
//                              color: R.color.gray_light,
//                              child: Container(
//                                padding: EdgeInsets.symmetric(
//                                    vertical: 10, horizontal: 10),
//                                child: Column(
//                                  children: <Widget>[
//                                    TXTextWidget(
//                                      text: "General",
//                                      fontWeight: FontWeight.bold,
//                                    ),
//                                    SizedBox(
//                                      height: 10,
//                                    ),
//                                    Row(
//                                      crossAxisAlignment:
//                                          CrossAxisAlignment.start,
//                                      children: <Widget>[
//                                        Expanded(
//                                          flex: 1,
//                                          child: TXStatWidget(
//                                            title: "Puntuación máxima",
//                                            value: "900",
//                                          ),
//                                        ),
//                                        Expanded(
//                                          flex: 1,
//                                          child: TXStatWidget(
//                                            title: "Puntuación actual",
//                                            value: "850",
//                                          ),
//                                        ),
//                                        Expanded(
//                                          flex: 1,
//                                          child: TXStatWidget(
//                                            title: "Máxima racha",
//                                            value: "135",
//                                          ),
//                                        )
//                                      ],
//                                    )
//                                  ],
//                                ),
//                              ),
//                            ),
//                          ),
//                          Container(
//                            padding: EdgeInsets.symmetric(horizontal: 10),
//                            child: Row(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: <Widget>[
//                                Expanded(
//                                  flex: 1,
//                                  child: Card(
//                                    color: R.color.gray_light,
//                                    child: Container(
//                                      padding: EdgeInsets.symmetric(
//                                          vertical: 10, horizontal: 10),
//                                      child: Column(
//                                        children: <Widget>[
//                                          TXTextWidget(
//                                            text: "Platos saludables",
//                                            fontWeight: FontWeight.bold,
//                                            size: 10,
//                                          ),
//                                          SizedBox(
//                                            height: 10,
//                                          ),
//                                          Row(
//                                            crossAxisAlignment:
//                                                CrossAxisAlignment.start,
//                                            children: <Widget>[
//                                              Expanded(
//                                                flex: 1,
//                                                child: TXStatWidget(
//                                                  title: "Maxima racha",
//                                                  value: "100",
//                                                  titleSize: 10,
//                                                  valueSize: 20,
//                                                ),
//                                              ),
//                                              Expanded(
//                                                flex: 1,
//                                                child: TXStatWidget(
//                                                  title: "Racha actual",
//                                                  value: "40",
//                                                  titleSize: 10,
//                                                  valueSize: 20,
//                                                ),
//                                              ),
//                                            ],
//                                          )
//                                        ],
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                                SizedBox(width: 5,),
//                                Expanded(
//                                  flex: 1,
//                                  child: Card(
//                                    color: R.color.gray_light,
//                                    child: Container(
//                                      padding: EdgeInsets.symmetric(
//                                          vertical: 10, horizontal: 10),
//                                      child: Column(
//                                        children: <Widget>[
//                                          TXTextWidget(
//                                            text: "Platos balanceados",
//                                            fontWeight: FontWeight.bold,
//                                            size: 10,
//                                          ),
//                                          SizedBox(
//                                            height: 10,
//                                          ),
//                                          Row(
//                                            crossAxisAlignment:
//                                                CrossAxisAlignment.start,
//                                            children: <Widget>[
//                                              Expanded(
//                                                flex: 1,
//                                                child: TXStatWidget(
//                                                  title: "Maxima racha",
//                                                  value: "60",
//                                                  titleSize: 10,
//                                                  valueSize: 20,
//                                                ),
//                                              ),
//                                              Expanded(
//                                                flex: 1,
//                                                child: TXStatWidget(
//                                                  title: "Racha actual",
//                                                  value: "55",
//                                                  titleSize: 10,
//                                                  valueSize: 20,
//                                                ),
//                                              ),
//                                            ],
//                                          )
//                                        ],
//                                      ),
//                                    ),
//                                  ),
//                                )
//                              ],
//                            ),
//                          ),
                      ],
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
      ),
    );
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

  List<PopupMenuItem> _popupActions() {
    List<PopupMenuItem> list = [];

    final faq = PopupMenuItem(
      value: PopupActionKey.faq,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.assignment,
              size: 20,
              color: R.color.primary_color,
            ),
            SizedBox(
              width: 10,
            ),
            TXTextWidget(
              text: R.string.faq,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
    final aboutUs = PopupMenuItem(
      value: PopupActionKey.about_us,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.insert_emoticon,
              size: 20,
              color: R.color.primary_color,
            ),
            SizedBox(
              width: 10,
            ),
            TXTextWidget(
              text: R.string.aboutUs,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
    final contactUs = PopupMenuItem(
      value: PopupActionKey.contact_us,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.contact_mail,
              size: 20,
              color: R.color.primary_color,
            ),
            SizedBox(
              width: 10,
            ),
            TXTextWidget(
              text: R.string.contactUs,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
    final settings = PopupMenuItem(
      value: PopupActionKey.profile_settings,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.settings,
              size: 20,
              color: R.color.primary_color,
            ),
            SizedBox(
              width: 10,
            ),
            TXTextWidget(
              text: R.string.settings,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
    list.add(aboutUs);
    list.add(contactUs);
    list.add(faq);
    list.add(settings);
    return list;
  }
}
