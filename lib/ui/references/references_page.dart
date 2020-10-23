import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_divider_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferencesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TXMainAppBarWidget(
      title: R.string.references,
      leading: TXIconButtonWidget(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          NavigationUtils.pop(context);
        },
      ),
      body: Container(
        child: SingleChildScrollView(
            child: Column(
          children: [
            TXDividerWidget(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: TXTextWidget(
                  text: R.string.referencesLink1,
                ),
                trailing: Icon(
                  Icons.link,
                  color: R.color.food_blue_dark,
                ),
                contentPadding: EdgeInsets.only(right: 10, left: 10),
                onTap: () {
                  launch("https://cataleg.uoc.edu/record=b1044457~S1*cat");
                },
              ),
            ),
            TXDividerWidget(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: TXTextWidget(
                  text: R.string.referencesLink2,
                ),
                trailing: Icon(
                  Icons.link,
                  color: R.color.food_blue_dark,
                ),
                contentPadding: EdgeInsets.only(right: 10, left: 10),
                onTap: () {
                  launch("https://doi.org/10.1016/j.appet.2013.02.006");
                },
              ),
            ),
            TXDividerWidget(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: TXTextWidget(
                  text: R.string.referencesLink3,
                ),
                trailing: Icon(
                  Icons.link,
                  color: R.color.food_blue_dark,
                ),
                contentPadding: EdgeInsets.only(right: 10, left: 10),
                onTap: () {
                  launch("https://doi.org/10.3389/fpsyg.2015.00021");
                },
              ),
            ),
            TXDividerWidget(),
          ],
        )),
      ),
    );
  }
}
