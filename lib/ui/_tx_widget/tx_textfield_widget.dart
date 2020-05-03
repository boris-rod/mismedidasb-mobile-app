import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_tx_widget/tx_icon_button_widget.dart';

class TXTextFieldWidget extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final FormFieldValidator validator;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final bool obscureText;
  final IconData iconData;
  final ValueChanged<String> onChanged;
  final int maxLine;

  const TXTextFieldWidget(
      {Key key,
      this.label,
      this.controller,
      this.validator,
      this.textInputAction,
      this.textInputType,
      this.obscureText = false,
      this.iconData,
      this.onChanged, this.maxLine})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TXTextFieldWidgetState();
}

class _TXTextFieldWidgetState extends State<TXTextFieldWidget> {
  bool passwordVisible = false;

  IconData get passwordIcon {
    if (passwordVisible)
      return Icons.visibility;
    else
      return Icons.visibility_off;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      maxLines: widget.maxLine ?? 1,
      keyboardType: widget.textInputType ?? TextInputType.text,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      obscureText: widget.obscureText && !passwordVisible,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
          labelText: widget.label,
          suffixIcon: TXIconButtonWidget(
            icon: Icon(
              widget.obscureText
                  ? passwordIcon
                  : widget.iconData ?? Icons.adjust,
              color: R.color.primary_color,
            ),
            onPressed: widget.obscureText
                ? () {
                    _setPasswordVisible(!passwordVisible);
                  }
                : null,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(45)))),
    );
  }

  _setPasswordVisible(bool visible) {
    setState(() {
      passwordVisible = visible;
    });
  }
}
