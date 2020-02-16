import 'package:flutter/material.dart';
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

  const TXTextFieldWidget(
      {Key key,
      this.label,
      this.controller,
      this.validator,
      this.textInputAction,
      this.textInputType,
      this.obscureText = false,
      this.iconData,
      this.onChanged})
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
      keyboardType: widget.textInputType ?? TextInputType.text,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      obscureText: widget.obscureText,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          labelText: widget.label,
          suffixIcon: TXIconButtonWidget(
            icon: Icon(widget.obscureText
                ? passwordVisible ? Icons.visibility : Icons.visibility_off
                : widget.iconData ?? Icons.adjust),
            onPressed: widget.obscureText
                ? () {
                    _setPasswordVisible(!passwordVisible);
                  }
                : null,
          ),
          border: OutlineInputBorder()),
    );
  }

  _setPasswordVisible(bool visible) {
    setState(() {
      passwordVisible = visible;
    });
  }
}
