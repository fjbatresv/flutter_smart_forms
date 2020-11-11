import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:smart_forms/models/field.model.dart';

class SmartDatepicker extends StatefulWidget {
  final FieldModel field;
  final FocusNode focus;
  final FocusNode nextFocus;
  final DateFormat format;
  final TextEditingController controller;

  const SmartDatepicker({
    Key key,
    this.field,
    this.focus,
    this.controller,
    this.nextFocus,
    this.format,
  }) : super(key: key);
  @override
  _SmartDatepickerState createState() => _SmartDatepickerState();
}

class _SmartDatepickerState extends State<SmartDatepicker> {
  DateTime dateTime;
  DateTime initial;

  @override
  void initState() {
    // 18 Years aprox
    super.initState();
  }

  setInitialDate() {
    this.initial = DateTime.now().subtract(Duration(days: (366 * 18)));
  }

  _launchAndroidPicker(BuildContext context) async {
    setInitialDate();
    DateTime date = await showDatePicker(
      context: context,
      initialDate: this.initial,
      firstDate: this.initial.subtract(Duration(days: 36600)),
      lastDate: this.initial,
    );
    _datePicked(date);
  }

  _datePicked(DateTime date) {
    this.dateTime = date;
    widget.controller.text =
        this.dateTime.toUtc().millisecondsSinceEpoch.toString();
    if (widget.nextFocus != null && Platform.isAndroid) {
      FocusScope.of(context).requestFocus(widget.nextFocus);
    }
  }

  _launchIosPicker(BuildContext context) {
    setInitialDate();
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return Container(
            height: MediaQuery.of(context).size.height / 4,
            width: double.infinity,
            child: CupertinoDatePicker(
              onDateTimeChanged: _datePicked,
              initialDateTime: this.initial,
              minimumDate: this.initial.subtract(Duration(days: 36600)),
              maximumDate: this.initial,
              mode: CupertinoDatePickerMode.date,
            ),
          );
        });
  }

  _launchPicker(BuildContext context) {
    _launchAndroidPicker(context);
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
            Text(
              this.dateTime == null
                  ? widget.field.hint
                  : widget.format.format(this.dateTime),
            )
          ],
        ),
      ),
    );
  }
}
