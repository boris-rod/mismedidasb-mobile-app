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
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: TXTextWidget(
                  text: R.string.referencesLink4,
                ),
                trailing: Icon(
                  Icons.link,
                  color: R.color.food_blue_dark,
                ),
                contentPadding: EdgeInsets.only(right: 10, left: 10),
                onTap: () {
                  launch("https://www.nhs.uk/live-well/eat-well/the-eatwell-guide");
                },
              ),
            ),
            TXDividerWidget(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: TXTextWidget(
                  text: R.string.referencesLink5,
                ),
                trailing: Icon(
                  Icons.link,
                  color: R.color.food_blue_dark,
                ),
                contentPadding: EdgeInsets.only(right: 10, left: 10),
                onTap: () {
                  launch("https://www.hsph.harvard.edu/nutritionsource/healthy-eating-plate");
                },
              ),
            ),
            TXDividerWidget(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: TXTextWidget(
                  text: R.string.referencesLink6,
                ),
                trailing: Icon(
                  Icons.link,
                  color: R.color.food_blue_dark,
                ),
                contentPadding: EdgeInsets.only(right: 10, left: 10),
                onTap: () {
                  launch("https://www.hsph.harvard.edu/nutritionsource/healthy-eating-pyramid");
                },
              ),
            ),
            TXDividerWidget(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: TXTextWidget(
                  text: R.string.referencesLink7,
                ),
                trailing: Icon(
                  Icons.link,
                  color: R.color.food_blue_dark,
                ),
                contentPadding: EdgeInsets.only(right: 10, left: 10),
                onTap: () {
                  launch("https://www.gov.uk/government/publications/the-eatwell-guide");
                },
              ),
            ),
            TXDividerWidget(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: TXTextWidget(
                  text: R.string.referencesLink8,
                ),
                trailing: Icon(
                  Icons.link,
                  color: R.color.food_blue_dark,
                ),
                contentPadding: EdgeInsets.only(right: 10, left: 10),
                onTap: () {
                  launch("https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/386521/ERG_eat well_Portion_Size_final.pdf");
                },
              ),
            ),
            TXDividerWidget(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: TXTextWidget(
                  text: R.string.referencesLink9,
                ),
                trailing: Icon(
                  Icons.link,
                  color: R.color.food_blue_dark,
                ),
                contentPadding: EdgeInsets.only(right: 10, left: 10),
                onTap: () {
                  launch("https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/347873/Adults_toolkit.pdf");
                },
              ),
            ),
            TXDividerWidget(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: TXTextWidget(
                  text: R.string.referencesLink10,
                ),
                trailing: Icon(
                  Icons.link,
                  color: R.color.food_blue_dark,
                ),
                contentPadding: EdgeInsets.only(right: 10, left: 10),
                onTap: () {
                  launch("https://www.gov.uk/government/publications/composition-of-foods-integrated-datasetcofid");
                },
              ),
            ),
            TXDividerWidget(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: TXTextWidget(
                  text: R.string.referencesLink11,
                ),
                trailing: Icon(
                  Icons.link,
                  color: R.color.food_blue_dark,
                ),
                contentPadding: EdgeInsets.only(right: 10, left: 10),
                onTap: () {
                  launch("http://www.imss.gob.mx/sites/all/statics/salud/guias_salud/alimentacion-saludable-2019.pdf");
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
