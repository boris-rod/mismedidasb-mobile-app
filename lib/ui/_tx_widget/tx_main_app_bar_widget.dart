import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXMainAppBarWidget extends StatelessWidget {
  final Widget body;
  final String title;
  final bool centeredTitle;
  final Widget leading;
  final List<Widget> actions;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Color backgroundColorAppBar;
  final FontWeight titleFont;

  const TXMainAppBarWidget(
      {Key key,
      @required this.body,
      this.title = "",
      this.centeredTitle = false,
      this.leading,
      this.actions = const [],
      this.scaffoldKey,
      this.backgroundColorAppBar, this.titleFont})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: backgroundColorAppBar,
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
          fontWeight: titleFont,
        ),
        actions: actions,
      ),
      body: body,
    );
  }
}
