import 'package:flutter/material.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_text_widget.dart';

class TXActionChipWidget extends StatelessWidget {
  final TagModel tag;
  final Function onTap;

  const TXActionChipWidget({Key key, this.tag, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: TXTextWidget(
        text: tag.name,
        size: 12,
        color: tag.isSelected ? R.color.primary_color : R.color.gray_dark,
      ),
      labelStyle: TextStyle(color: R.color.primary_color),
      elevation: tag.isSelected ? 5 : 1,
      onPressed: onTap,
      avatar: Icon(
        tag.isSelected ? Icons.close : Icons.add,
        size: 12,
        color: tag.isSelected ? R.color.primary_color : R.color.gray_dark,
      ),
    );
  }
}
