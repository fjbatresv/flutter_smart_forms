import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_forms/models/field.model.dart';

class SmartDatepicker extends StatefulWidget {
  final FieldModel field;
  final FocusNode focus;
  final FocusNode nextFocus;
  final TextEditingController controller;

  const SmartDatepicker({
    Key key,
    this.field,
    this.focus,
    this.controller,
    this.nextFocus,
  }) : super(key: key);
  @override
  _SmartDatepickerState createState() => _SmartDatepickerState();
}

class _SmartDatepickerState extends State<SmartDatepicker> {
  DateTime dateTime;

  @override
  void initState() {
    dateTime = DateTime.now().subtract(Duration(days: 6574)); // 18 Years aprox
    super.initState();
  }

  Future<DateTime> _launchAndroidPicker(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: this.dateTime,
      firstDate: this.dateTime,
      lastDate: this.dateTime,
      locale: Locale('es'),
    );
  }

  _launchPicker(BuildContext context) async {
    this.dateTime = await _launchAndroidPicker(context);
    if (widget.nextFocus != null) {
      FocusScope.of(context).requestFocus(widget.nextFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusNode: widget.focus,
      onTap: () => _launchPicker(context),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
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
          ],
        ),
      ),
    );
  }
}
