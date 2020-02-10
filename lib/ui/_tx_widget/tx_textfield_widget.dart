import 'package:flutter/material.dart';

class TXTextFieldWidget extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final FormFieldValidator validator;
  final Widget prefixIcon;

  const TXTextFieldWidget(
      {Key key, this.label, this.controller, this.validator, this.prefixIcon})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TXTextFieldWidgetState();
}

class _TXTextFieldWidgetState extends State<TXTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      decoration: InputDecoration(
          labelText: widget.label,
          suffixIcon: widget.prefixIcon,
          border: OutlineInputBorder()),
    );
  }
}
