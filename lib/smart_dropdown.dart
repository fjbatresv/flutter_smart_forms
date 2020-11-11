import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_forms/models/field.model.dart';
import 'package:smart_forms/models/fieldOptions.model.dart';

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
  String value;

  @override
  void initState() {
    super.initState();
  }

  _onChange(dynamic newValue) {
    if (Platform.isAndroid) {
      this.value = newValue;
    } else if (Platform.isIOS) {
      this.value = widget.field.options[newValue].value;
    }
    widget.controller.text = this.value;
    setState(() {});
    if (widget.nextFocus != null) {
      FocusScope.of(context).requestFocus(widget.nextFocus);
    } else {
      widget.callback();
    }
  }

  _launchIosPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoPicker(
          itemExtent: 32,
          onSelectedItemChanged: _onChange,
          children: widget.field.options.map<Widget>((option) {
            return Text(option.label);
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return _androidDropDown();
    } else if (Platform.isIOS) {
      return _iosDropDown(context);
    }
  }

  Widget _iosDropDown(BuildContext context) {
    return InkWell(
      focusNode: widget.focus,
      onTap: () => _launchIosPicker(context),
      child: Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value != null
                  ? widget.field.options
                      .firstWhere((option) => option.value == this.value)
                      .label
                  : widget.field.hint,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: value != null ? Colors.black : Color(0xFF7c7c7c),
              ),
            ),
            Icon(
              Icons.expand_more,
              size: 16,
              color: Theme.of(context).accentColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _androidDropDown() {
    return DropdownButton(
      focusNode: widget.focus,
      isExpanded: true,
      hint: Text(widget.field.hint),
      icon: Icon(
        Icons.expand_more,
        size: 16,
        color: Theme.of(context).accentColor,
      ),
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
