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
  final TextEditingController controller;

  const SmartDropDown({
    Key key,
    this.field,
    this.focus,
    this.controller,
    this.nextFocus,
  }) : super(key: key);

  @override
  _SmartDropDownState createState() => _SmartDropDownState();
}

class _SmartDropDownState extends State<SmartDropDown> {
  String value;

  @override
  void initState() {
    this.value = widget.field.value == null
        ? widget.field.options[0].value
        : widget.field.value;
    widget.controller.text =
        widget.field.value == null ? this.value : widget.field.value;
    super.initState();
  }

  _onChange(dynamic newValue) {
    if (Platform.isAndroid) {
      this.value = newValue;
      widget.focus.unfocus();
    } else if (Platform.isIOS) {
      this.value = widget.field.options[newValue].value;
    }
    widget.controller.text = this.value;
    setState(() {});
  }

  _launchIosPicker(BuildContext context) {
    FocusScope.of(context).requestFocus(widget.focus);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return Container(
          height: MediaQuery.of(context).size.height / 4,
          width: double.infinity,
          child: CupertinoPicker(
            itemExtent: 32,
            onSelectedItemChanged: _onChange,
            children: widget.field.options.map<Widget>((option) {
              return Text(option.label);
            }).toList(),
          ),
        );
      },
    )..then((value) => widget.focus.unfocus());
  }

  @override
  Widget build(BuildContext context) {
    Widget dropdown;
    if (Platform.isAndroid) {
      dropdown = _androidDropDown();
    } else if (Platform.isIOS) {
      dropdown = _iosDropDown(context);
    }
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: Platform.isIOS ? 16 : 0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: Platform.isIOS ? 1 : 0,
            color: widget.focus.hasFocus
                ? Theme.of(context).accentColor
                : Color(0xFF7C7C7C),
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.field.label,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: widget.focus.hasFocus
                  ? Theme.of(context).accentColor
                  : Color(0xFF7C7C7C),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          dropdown
        ],
      ),
    );
  }

  Widget _iosDropDown(BuildContext context) {
    return InkWell(
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
      onTap: () => FocusScope.of(context).requestFocus(widget.focus),
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
