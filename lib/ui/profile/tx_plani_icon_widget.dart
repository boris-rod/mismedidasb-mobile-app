import 'package:flutter/material.dart';

class TXPlaniIconWidget extends StatelessWidget {
  final int planiId;
  final Function onPlaniSelected;
  final bool isSelected;

  const TXPlaniIconWidget(
      {Key key, this.planiId, this.onPlaniSelected, this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPlaniSelected,
        child: Container(
          child: Image.asset(""),
        ),
      ),
    );
  }
}
