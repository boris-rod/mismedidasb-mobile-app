import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textfield_widget.dart';

class TXSearchAppBarWidget extends StatelessWidget {
  final Widget body;
  final String title;
  final bool centeredTitle;
  final TXIconButtonWidget leading;
  final bool isSearching;
  final Function onSearchTap;
  final TextEditingController searchController;
  final ValueChanged<String> onQueryChanged;

  const TXSearchAppBarWidget(
      {Key key,
      @required this.body,
      this.title = "",
      this.centeredTitle = false,
      this.leading,
      this.isSearching = false,
      this.onSearchTap,
      this.searchController,
      this.onQueryChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: centeredTitle,
        leading: leading ??
            TXIconButtonWidget(
              icon: Image.asset(R.image.logo),
            ),
        title: isSearching
            ? TextField(
                autofocus: true,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.search,
                onChanged: (value) {
                  onQueryChanged(value);
                },
                style: TextStyle(color: Colors.white, decoration: TextDecoration.none),
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: "Buscar...",
                    hintStyle: TextStyle(
                        color: Colors.white, fontStyle: FontStyle.italic),
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    border: null,
                    disabledBorder: null,
                    enabledBorder: null,
                    focusedErrorBorder: null,
                    errorBorder: null,
                    focusedBorder: null),
              )
            : TXTextWidget(
                text: title,
                color: Colors.white,
                size: 18,
              ),
        actions: [
          TXIconButtonWidget(
            onPressed: onSearchTap,
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: body,
    );
  }
}
