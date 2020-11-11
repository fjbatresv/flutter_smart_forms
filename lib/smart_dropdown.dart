import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_forms/models/field.model.dart';

class SmartDropDown extends StatefulWidget {
  final FieldModel field;
  final FocusNode focus;
  final FocusNode nextFocus;
  final Function callback;
  final TextEditingController controller;

  const SmartDropDown(
      {Key key,
      this.field,
      this.focus,
      this.controller,
      this.nextFocus,
      this.callback})
      : super(key: key);

  @override
  _SmartDropDownState createState() => _SmartDropDownState();
}

class _SmartDropDownState extends State<SmartDropDown> {
  dynamic value;

  @override
  void initState() {
    super.initState();
  }

  _onChange(dynamic newValue) {
    this.value = newValue;
    widget.controller.text = this.value;
    setState(() {});
    if (widget.nextFocus != null) {
      FocusScope.of(context).requestFocus(widget.nextFocus);
    } else {
      widget.callback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      focusNode: widget.focus,
      isExpanded: true,
      hint: Text(widget.field.hint),
      icon: Icon(Icons.arrow_drop_down),
      items: widget.field.options.map<DropdownMenuItem>((option) {
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
