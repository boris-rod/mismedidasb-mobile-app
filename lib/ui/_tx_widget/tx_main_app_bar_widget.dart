import 'package:flutter/material.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';

class TXMainAppBarWidget extends StatelessWidget {
  final Widget body;
  final String title;
  final bool centeredTitle;
  final TXIconButtonWidget leading;
  final List<Widget> actions;

  const TXMainAppBarWidget(
      {Key key,
      @required this.body,
      this.title = "",
      this.centeredTitle = false,
      this.leading,
      this.actions = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: centeredTitle,
        leading: leading ??
            TXIconButtonWidget(
              icon: Container(),
            ),
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: actions,
      ),
      body: body,
    );
  }
}
