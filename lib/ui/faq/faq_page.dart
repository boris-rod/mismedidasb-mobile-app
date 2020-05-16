import 'package:flutter/material.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/faq/faq_bloc.dart';

class FAQPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FAQState();
}

class _FAQState extends StateWithBloC<FAQPage, FAQBloC> {
  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        TXMainAppBarWidget(
          title: "FAQ",
          leading: TXIconButtonWidget(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              NavigationUtils.pop(context);
            },
          ),
          body: Container(),
        )
      ],
    );
  }
}
