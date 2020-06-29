import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXMainAppBarWidget extends StatelessWidget {
  final Widget body;
  final String title;
  final bool centeredTitle;
  final TXIconButtonWidget leading;
  final List<Widget> actions;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const TXMainAppBarWidget(
      {Key key,
      @required this.body,
      this.title = "",
      this.centeredTitle = false,
      this.leading,
      this.actions = const [], this.scaffoldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        leading: leading ??
            TXIconButtonWidget(
              icon: Image.asset(R.image.logo),
            ),
        title: TXTextWidget(
          text: title,
          color: Colors.white,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
          size: 18,
        ),
        actions: actions,
      ),
      body: body,
    );
  }
}
