import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_divider_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_navigator_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/videos/video_bloc.dart';
import 'package:mismedidasb/utils/file_manager.dart';

class VideoPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _VideoState();

}

class _VideoState extends StateWithBloC<VideoPage, VideoBloC>{
  @override
  Widget buildWidget(BuildContext context) {
    return TXMainAppBarWidget(
      title: "Videos",
      leading: Container(
        margin: EdgeInsets.only(left: 10),
        child: TXIconNavigatorWidget(
          onTap: () {
            NavigationUtils.pop(context);
          },
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              title: TXTextWidget(
                text: R.string.planiIntroHelper,
              ),
              trailing: Icon(Icons.play_circle_filled, color: R.color.button_color),
              contentPadding:
              EdgeInsets.only(right: 10, left: 10),
              onTap: () {
                FileManager.playVideo("main_menu.mp4");
              },
            ),
            TXDividerWidget(),
            ListTile(
              title: TXTextWidget(
                text: R.string.foodPlanHelper,
              ),
              trailing: Icon(Icons.play_circle_filled, color: R.color.button_color),
              contentPadding:
              EdgeInsets.only(right: 10, left: 10),
              onTap: () {
                FileManager.playVideo("my_food_plan.mp4");
              },
            ),
            TXDividerWidget(),
            ListTile(
              title: TXTextWidget(
                text: R.string.copyPlanHelper,
              ),
              trailing: Icon(Icons.play_circle_filled, color: R.color.button_color),
              contentPadding:
              EdgeInsets.only(right: 10, left: 10),
              onTap: () {
                FileManager.playVideo("copy_food_plan.mp4");
              },
            ),
            TXDividerWidget(),
            ListTile(
              title: TXTextWidget(
                text: R.string.portionFoodHelper,
              ),
              trailing: Icon(Icons.play_circle_filled, color: R.color.button_color),
              contentPadding:
              EdgeInsets.only(right: 10, left: 10),
              onTap: () {
                FileManager.playVideo("portions_food_sizes.mp4");
              },
            ),
            TXDividerWidget(),
            ListTile(
              title: TXTextWidget(
                text: R.string.profileSettingsHelper,
              ),
              trailing: Icon(Icons.play_circle_filled, color: R.color.button_color,),
              contentPadding:
              EdgeInsets.only(right: 10, left: 10),
              onTap: () {
                FileManager.playVideo("profile_settings.mp4");
              },
            ),
            TXDividerWidget()
          ],
        ),
      ),
    );
  }

}