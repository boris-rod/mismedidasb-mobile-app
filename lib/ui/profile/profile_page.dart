import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mismedidasb/data/api/remote/endpoints.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/enums.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_bottom_sheet.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_dialog_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_cupertino_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_divider_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_divider_widget1.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_navigator_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_network_image.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_video_intro_widet.dart';
import 'package:mismedidasb/ui/change_password/change_password_page.dart';
import 'package:mismedidasb/ui/contact_us/contact_us_page.dart';
import 'package:mismedidasb/ui/invite_page/invite_page.dart';
import 'package:mismedidasb/ui/legacy/legacy_page.dart';
import 'package:mismedidasb/ui/plani_service/plani_service_page.dart';
import 'package:mismedidasb/ui/profile/profile_bloc.dart';
import 'package:mismedidasb/ui/profile/tx_cell_selection_option_widget.dart';
import 'package:mismedidasb/ui/profile/tx_cell_selection_option_widget1.dart';
import 'package:mismedidasb/ui/profile/tx_stat_widget.dart';
import 'package:mismedidasb/ui/profile_edit/profile_edit_page.dart';
import 'package:mismedidasb/ui/scores_page/score_page.dart';
import 'package:mismedidasb/ui/settings/settings_bloc.dart';
import 'package:mismedidasb/ui/settings/settings_page.dart';
import 'package:mismedidasb/ui/videos/video_page.dart';
import 'package:mismedidasb/utils/file_manager.dart';
import 'package:mismedidasb/utils/mail_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

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
    bloc.loadVersion();
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
            backgroundColorAppBar: R.color.food_action_bar,
            titleFont: FontWeight.w300,
            leading: Container(
              margin: EdgeInsets.only(left: 10),
              child: TXIconNavigatorWidget(
                onTap: () {
                  _navBack();
                },
              ),
            ),
            title: R.string.profile,
            actions: <Widget>[
              PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  color: R.color.food_nutri_info,
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
            body: Container(
              height: double.infinity,
              color: R.color.profile_color,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: 30),
                child: StreamBuilder<UserModel>(
                  stream: bloc.userResult,
                  initialData: UserModel(),
                  builder: (context, snapshot) {
                    final user = snapshot.data;
                    return Container(
                      padding: EdgeInsets.all(10).copyWith(top: 30),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 235,
                            width: double.infinity,
                            child: Stack(
                              children: <Widget>[
                                Align(
                                  child: Container(
                                    width: 250,
                                    height: 200,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        color: R.color.gray_dark),
                                    child: Container(
                                      child: TXNetworkImage(
                                        boxFitImage: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        imageUrl: user.avatar,
                                        placeholderImage: R.image.logo,
                                      ),
                                    ),
                                  ),
                                  alignment: Alignment.topCenter,
                                ),
                                Positioned(
                                  bottom: 25,
                                  left: 0,
                                  right: 0,
                                  child: TXDividerWidget1(),
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 0,
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
                                    ))
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: TXNetworkImage(
                                    width: 60,
                                    height: 60,
                                    imageUrl: R.image.logo,
                                    placeholderImage: R.image.logo,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    TXTextWidget(
                                      text:
                                          user?.username?.trim()?.isNotEmpty ==
                                                  true
                                              ? "@${user.username}"
                                              : "",
                                      fontWeight: FontWeight.bold,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    TXTextWidget(
                                      text: user?.fullName ?? "",
                                      color: Colors.white,
                                      maxLines: 1,
                                      textOverflow: TextOverflow.ellipsis,
                                      size: 12,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TXTextWidget(
                                      text: user?.email ?? "---",
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TXDividerWidget1(),
                          TXCellSelectionOptionWidget1(
                            leading: Icons.group_add,
                            optionName: "Invita y gana una recompensa!",
                            onOptionTap: () async {
                              final res = await NavigationUtils.push(
                                  context, InvitePeoplePage());
                              if (res) {
                                _keyInviteProfile.currentState.showSnackBar(
                                    getSnackBarWidget(
                                        "Felicidades, recibirás una recompensa!"));
                              }
                            },
                          ),
                          TXDividerWidget1(),
                          TXCellSelectionOptionWidget1(
                            leading: Icons.contacts,
                            optionName: "Invita a tus contactos!",
                            onOptionTap: () {
                              final shareContent =
                                  "PlaniFive - GooglePlay: https://play.google.com/store/apps/details?id=com.metriri.mismedidasb \n\n PlaniFive - AppleStore: https://itunes.apple.com/us/app/sutiawbapp/id1506658015?ls=1&mt=8";
                              Share.share(shareContent, subject: "PlaniFive");
                            },
                          ),
                          TXDividerWidget1(),
                          TXCellSelectionOptionWidget1(
                            leading: Icons.school,
                            optionName: "Ver puntuaciones",
                            onOptionTap: () {
                              NavigationUtils.push(context, ScorePage());
                            },
                          ),
                          TXDividerWidget1(),
                          TXCellSelectionOptionWidget1(
                            leading: Icons.cloud_done,
                            optionName: "Servicios de Planifive",
                            onOptionTap: () async {
                              final res = await NavigationUtils.push(
                                  context,
                                  PlaniServicePage(
                                    userModel: snapshot.data,
                                  ));
                            },
                          ),
                          TXDividerWidget1(),
                          TXCellSelectionOptionWidget1(
                            leading: Icons.video_library,
                            optionName: "Ver tutoriales",
                            onOptionTap: () {
                              NavigationUtils.push(context, VideoPage());
                            },
                          ),
                          TXDividerWidget1(),
                          SizedBox(
                            height: 10,
                          ),
                          StreamBuilder<String>(
                            stream: bloc.appVersionResult,
                            initialData: "",
                            builder: (ctx, snapshotVersion) {
                              return TXTextWidget(
                                text: snapshotVersion.data,
                                color: Colors.white,
                              );
                            },
                          )
//                        InkWell(
//                          onTap: (){
//
//                            showTXModalBottomSheet(
//                                context: context,
//                                builder: (ctx) {
//                                  return Container(
//                                    height: 400,
//                                    child: Column(
//                                      crossAxisAlignment: CrossAxisAlignment.center,
//                                      children: <Widget>[
//
//                                        Row(
//                                          children: <Widget>[
//                                            Expanded(
//                                              child: Column(
//                                                children: <Widget>[
//
//                                                ],
//                                              ),
//                                            ),
//                                            Expanded(
//                                              child: Column(
//                                                children: <Widget>[
//
//                                                ],
//                                              ),
//                                            ),
//                                          ],
//                                        )
//                                      ],
//                                    ),
//                                  );
//                                });
//                          },
//                          child: Container(
//                              padding: EdgeInsets.only(right: 10),
//                              height: 50,
//                              child: Row(
//                                children: <Widget>[
//                                  Image.asset(R.image.logo, width: 35, height: 35,),
//                                  Expanded(
//                                    child: TXTextWidget(
//                                      text: "Elige tu Plani favorito",
//                                      maxLines: 1,
//                                      textOverflow: TextOverflow.ellipsis,
//                                      color: Colors.black,
//                                    ),
//                                  ),
//                                  Icon(
//                                    Icons.keyboard_arrow_right,
//                                    color: R.color.primary_dark_color,
//                                    size: 25,
//                                  )
//                                ],
//                              )),
//                        ),
//                        TXDividerWidget(),
//                        InkWell(
//                          child: Container(
//                            padding: EdgeInsets.symmetric(horizontal: 10),
//                            height: 50,
//                            child: Row(
//                              children: <Widget>[
//                                Image.asset(R.image.logo),
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
          ),
          TXLoadingWidget(
            loadingStream: bloc.isLoadingStream,
          ),
          StreamBuilder<bool>(
              stream: bloc.showFirstTimeResult,
              initialData: false,
              builder: (context, snapshotShow) {
                return snapshotShow.data
                    ? TXVideoIntroWidget(
                        title: R.string.profileSettingsHelper,
                        onSeeVideo: () {
                          bloc.setNotFirstTime();
                          launch(Endpoint.profileSettingsVideo);
//                          FileManager.playVideo("profile_settings.mp4");
                        },
                        onSkip: () {
                          bloc.setNotFirstTime();
                        },
                      )
                    : Container();
              }),
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
              R.image.plani,
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
