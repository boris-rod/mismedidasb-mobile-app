import 'package:flutter/material.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/about_us/about_us_bloc.dart';

class AboutUsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AboutUsState();
}

class _AboutUsState extends StateWithBloC<AboutUsPage, AboutUsBloC> {

  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        TXMainAppBarWidget(
          title: "Acerca de nosotros",
          leading: TXIconButtonWidget(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              NavigationUtils.pop(context);
            },
          ),
          body: Container(
          ),
        )
      ],
    );
  }
}
