import 'package:flutter/material.dart';
import 'package:mismedidasb/domain/setting/setting_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_checkbox_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_loading_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/settings/settings_bloc.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends StateWithBloC<SettingsPage, SettingsBloC> {

  @override
  void initState() {
    super.initState();
    bloc.initData();
  }
  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        TXMainAppBarWidget(
          leading: TXIconButtonWidget(
            icon: Icon(Icons.close),
            onPressed: () {
              NavigationUtils.pop(context);
            },
          ),
          title: R.string.settings,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 30),
            child: StreamBuilder<SettingModel>(
              stream: bloc.settingsResult,
              initialData: null,
              builder: (ctx, snapshot) {
                return snapshot.data == null
                    ? Container()
                    : Column(
                        children: <Widget>[
                          Container(
                            child: TXCheckBoxWidget(
                              padding: EdgeInsets.only(left: 10),
                              text: R.string.showResumePlanBeforeSave,
                              leading: false,
                              value: snapshot.data.showResumeBeforeSave,
                              onChange: (value) {
                                bloc.setShowResumeBeforeSave(value);
                              },
                              textColor: R.color.gray_darkest,
                            ),
                          ),
                          Container(
                            height: .5,
                            padding: EdgeInsets.only(),
                            color: R.color.gray,
                          ),
                        ],
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
}
