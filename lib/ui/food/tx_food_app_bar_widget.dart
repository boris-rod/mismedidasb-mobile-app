import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_main_app_bar_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_textfield_widget.dart';

class TXFoodAppBarWidget extends StatelessWidget {
  final Widget body;
  final String title;
  final TXIconButtonWidget leading;
  final ValueChanged<int> onItemTaped;
  final int selectedItemIndex;
  final Function onFilterTap;
  final Function onFloatingTap;

  TXFoodAppBarWidget(
      {Key key,
      @required this.body,
      this.title = "",
      this.leading,
      this.onItemTaped,
      this.onFilterTap,
      this.selectedItemIndex = 0,
      this.onFloatingTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: leading ??
            TXIconButtonWidget(
              icon: Image.asset(R.image.plani),
            ),
        title: TXTextWidget(
          text: title,
          color: Colors.white,
          size: 18,
        ),
        actions: [
          selectedItemIndex == 0
              ? TXIconButtonWidget(
                  icon: Icon(Icons.filter_list),
                  onPressed: onFilterTap,
                )
              : Container()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: Icon(selectedItemIndex == 0 ? Icons.search : Icons.add),
        onPressed: onFloatingTap,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: R.color.gray_light,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.apps,
              color:
                  selectedItemIndex == 0 ? R.color.primary_color : R.color.gray,
            ),
            title: TXTextWidget(
              text: "Alimentos",
              maxLines: 2,
              color:
                  selectedItemIndex == 0 ? R.color.primary_color : R.color.gray,
              textOverflow: TextOverflow.ellipsis,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_balance,
              color:
                  selectedItemIndex == 1 ? R.color.primary_color : R.color.gray,
            ),
            title: TXTextWidget(
              text: "Mis alimentos",
              maxLines: 2,
              color:
                  selectedItemIndex == 1 ? R.color.primary_color : R.color.gray,
              textOverflow: TextOverflow.ellipsis,
            ),
          ),
        ],
        currentIndex: selectedItemIndex,
        onTap: (index) => onItemTaped(index),
      ),
      body: body,
    );
  }
}
