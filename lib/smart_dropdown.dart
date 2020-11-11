import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_forms/models/field.model.dart';

class SmartDropDown extends StatefulWidget {
  final FieldModel field;
  final FocusNode focus;
  final FocusNode nextFocus;
  final TextEditingController controller;

  const SmartDropDown(
      {Key key, this.field, this.focus, this.controller, this.nextFocus})
      : super(key: key);

  @override
  _SmartDropDownState createState() => _SmartDropDownState();
}

class _SmartDropDownState extends State<SmartDropDown> {
  dynamic value;

  @override
  void initState() {
    this.value = widget.field.options[0].value;
    widget.controller.text = this.value;
    super.initState();
  }

  _onChange(dynamic newValue) {
    this.value = newValue;
    if (widget.nextFocus != null) {
      widget.nextFocus.requestFocus();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      focusNode: widget.focus,
      hint: Text(widget.field.hint),
      icon: Icon(Icons.arrow_drop_down),
      items: widget.field.options.map<Widget>((option) {
        return DropdownMenuItem(
          child: Text(option.label),
          value: option.value,
        );
      }).toList(),
      value: this.value,
      onChanged: _onChange,
    );
  }
}
